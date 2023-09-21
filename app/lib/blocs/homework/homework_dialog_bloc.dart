// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:bloc_base/bloc_base.dart';
import 'package:files_basics/local_file.dart';
import 'package:filesharing_logic/filesharing_logic_models.dart';
import 'package:firebase_hausaufgabenheft_logik/firebase_hausaufgabenheft_logik.dart';
import 'package:group_domain_models/group_domain_models.dart';
import 'package:rxdart/rxdart.dart';
import 'package:sharezone/markdown/markdown_analytics.dart';
import 'package:sharezone/util/api.dart';
import 'package:sharezone/util/next_lesson_calculator/next_lesson_calculator.dart';
import 'package:sharezone_common/helper_functions.dart';
import 'package:sharezone_common/homework_validators.dart';
import 'package:sharezone_common/validators.dart';
import 'package:time/time.dart';
import 'package:user/user.dart';

extension on DateTime {
  Time toTime() => Time(hour: hour, minute: minute);
}

class HomeworkDialogBloc extends BlocBase with HomeworkValidators {
  List<CloudFile> initialCloudFiles = [];
  final _titleSubject = BehaviorSubject<String?>();
  final _courseSegmentSubject = BehaviorSubject<Course>();
  final _todoUntilSubject = BehaviorSubject<DateTime>();
  final _descriptionSubject = BehaviorSubject<String>();
  final _privateSubject = BehaviorSubject.seeded(false);
  final _sendNotificationSubject = BehaviorSubject<bool>();
  final _localFilesSubject = BehaviorSubject.seeded(<LocalFile>[]);
  final _cloudFilesSubject = BehaviorSubject.seeded(<CloudFile>[]);
  final _withSubmissionsSubject = BehaviorSubject.seeded(false);
  final _submissionTimeSubject =
      BehaviorSubject<Time>.seeded(Time(hour: 23, minute: 59));

  final HomeworkDialogApi api;
  final HomeworkDto? initialHomework;

  final MarkdownAnalytics _markdownAnalytics;

  HomeworkDialogBloc(this.api, this._markdownAnalytics, {HomeworkDto? homework})
      : initialHomework = homework {
    if (homework != null) {
      _loadInitialCloudFiles(homework.courseReference!.id, homework.id);

      changeTitle(homework.title);
      changeTodoUntil(homework.todoUntil);
      changeDescription(homework.description);
      changePrivate(homework.private);
      changeWithSubmissions(homework.withSubmissions);
      if (homework.withSubmissions) {
        changeSubmissionTime(homework.todoUntil.toTime());
      }

      final c = Course.create().copyWith(
        subject: homework.subject,
        name: homework.subject,
        sharecode: "000000",
        abbreviation: homework.subjectAbbreviation,
        id: homework.courseReference!.id,
      );
      changeCourseSegment(c);
      changeSendNotification(homework.sendNotification);
    }
  }

  bool get hasAttachments =>
      _localFilesSubject.valueOrNull != null &&
      _localFilesSubject.valueOrNull!.isNotEmpty;

  Stream<String> get title => _titleSubject.stream.transform(validateTitle);
  Stream<DateTime> get todoUntil => _todoUntilSubject;
  Stream<String> get description => _descriptionSubject;
  Stream<Course> get courseSegment => _courseSegmentSubject;
  Stream<bool> get private => _privateSubject;
  Stream<List<LocalFile>> get localFiles => _localFilesSubject;
  Stream<List<CloudFile>> get cloudFiles => _cloudFilesSubject;
  Stream<bool> get sendNotification => _sendNotificationSubject;
  Stream<bool> get withSubmissions => _withSubmissionsSubject;
  Stream<bool> get isSubmissionEnableable =>
      _privateSubject.map((private) => !private);
  Stream<Time> get submissionTime => _submissionTimeSubject;

  Function(String) get changeTitle => _titleSubject.sink.add;
  Function(String) get changeDescription => _descriptionSubject.sink.add;
  Function(bool) get changeWithSubmissions => _withSubmissionsSubject.sink.add;
  Function(Course) get changeCourseSegment => (courseSegment) {
        _courseSegmentSubject.sink.add(courseSegment);
        if (_todoUntilSubject.valueOrNull == null) {
          changeTodoUntilNextLessonOrNextSchoolDay(courseSegment.id);
        }
      };
  Function(DateTime) get changeTodoUntil => _todoUntilSubject.sink.add;
  Function(bool) get changePrivate => (isPrivate) {
        if (isPrivate) _withSubmissionsSubject.sink.add(false);
        return _privateSubject.sink.add(isPrivate);
      };

  Function(Time) get changeSubmissionTime => _submissionTimeSubject.sink.add;

  Function(bool) get changeSendNotification =>
      _sendNotificationSubject.sink.add;

  Function(List<LocalFile>) get addLocalFile => (localFiles) {
        final list = <LocalFile>[];
        if (_localFilesSubject.valueOrNull != null) {
          list.addAll(_localFilesSubject.valueOrNull!);
        }
        list.addAll(localFiles);
        _localFilesSubject.sink.add(list);
      };
  Function(LocalFile) get removeLocalFile => (localFile) {
        final list = <LocalFile>[];
        if (_localFilesSubject.valueOrNull != null) {
          list.addAll(_localFilesSubject.valueOrNull!);
        }
        list.remove(localFile);
        _localFilesSubject.sink.add(list);
      };
  Function(CloudFile) get removeCloudFile => (cloudFile) {
        final list = <CloudFile>[];
        if (_cloudFilesSubject.valueOrNull != null) {
          list.addAll(_cloudFilesSubject.valueOrNull!);
        }
        list.remove(cloudFile);
        _cloudFilesSubject.sink.add(list);
      };

  /// Prüfen, ob der Nutzer in den Eingabefelder etwas geändert hat. Falls ja,
  /// wird true zurückgegeben.
  ///
  /// Attribut [private] & [sendNotifcation] werden vernachlässtig, da
  /// dieser Input kein großer Verlust ist, wenn man versehentlich den
  /// Dialog schließt.
  bool hasInputChanged() {
    final title = _titleSubject.valueOrNull;
    final course = _courseSegmentSubject.valueOrNull;
    final todoUntil = _todoUntilSubject.valueOrNull;
    final description = _descriptionSubject.valueOrNull;
    final localFiles = _localFilesSubject.valueOrNull;

    final hasAttachments = localFiles != null && localFiles.isNotEmpty;
    final cloudFiles =
        _cloudFilesSubject.valueOrNull!.map((cf) => cf.id).toList();

    // Prüfen, ob Nutzer eine neue Hausaufgabe erstellt
    if (initialHomework == null) {
      return isNotEmptyOrNull(title) ||
          isNotEmptyOrNull(description) ||
          hasAttachments ||
          course != null ||
          todoUntil != null;
    } else {
      return title != initialHomework!.title ||
          description != initialHomework!.description ||
          course!.id != initialHomework!.courseID ||
          todoUntil != initialHomework!.todoUntil ||
          hasAttachments ||
          initialHomework!.attachments.length != cloudFiles.length;
    }
  }

  static DateTime _getSeedTodoUntilDate() {
    DateTime now =
        DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
    if (DateTime.now().weekday == DateTime.friday ||
        DateTime.now().weekday == DateTime.saturday) {
      DateTime monday = now.add(
          Duration(days: DateTime.now().weekday == DateTime.friday ? 3 : 2));
      return monday;
    } else {
      DateTime tomorrow = now.add(const Duration(days: 1));
      return tomorrow;
    }
  }

  void changeTodoUntilNextLessonOrNextSchoolDay(String courseID) {
    api.nextLessonCalculator.calculateNextLesson(courseID).then((result) {
      if (result == null) {
        changeTodoUntil(_getSeedTodoUntilDate());
      } else {
        changeTodoUntil(result.toDateTime);
      }
    });
  }

  bool isValid() {
    final validatorTitle = NotEmptyOrNullValidator(_titleSubject.valueOrNull);
    if (!validatorTitle.isValid()) {
      _titleSubject.addError(
          TextValidationException(HomeworkValidators.emptyTitleUserMessage));
      throw InvalidTitleException();
    }

    final validatorCourse = NotNullValidator(_courseSegmentSubject.valueOrNull);
    if (!validatorCourse.isValid()) {
      _courseSegmentSubject.addError(
          TextValidationException(HomeworkValidators.emptyCourseUserMessage));
      throw InvalidCourseException();
    }

    final validatorTodoUntil = NotNullValidator(_todoUntilSubject.valueOrNull);
    if (!validatorTodoUntil.isValid()) {
      _todoUntilSubject.addError(
          TextValidationException(HomeworkValidators.emptyDueDateUserMessage));
      throw InvalidTodoUntilException();
    }

    return true;
  }

  Future<void> _loadInitialCloudFiles(
      String courseID, String homeworkID) async {
    List<CloudFile> cloudFiles = await api.api.fileSharing.cloudFilesGateway
        .filesStreamAttachment(courseID, homeworkID)
        .first;
    _cloudFilesSubject.sink.add(cloudFiles);
    initialCloudFiles.addAll(cloudFiles);
  }

  Future<void> submit({HomeworkDto? oldHomework}) async {
    if (isValid()) {
      final todoUntil = DateTime(
          _todoUntilSubject.valueOrNull!.year,
          _todoUntilSubject.valueOrNull!.month,
          _todoUntilSubject.valueOrNull!.day);
      final description = _descriptionSubject.valueOrNull;
      final private = _privateSubject.valueOrNull;
      final localFiles = _localFilesSubject.valueOrNull;

      final userInput = UserInput(
        _titleSubject.valueOrNull,
        _courseSegmentSubject.valueOrNull,
        todoUntil,
        description,
        private,
        localFiles,
        _sendNotificationSubject.valueOrNull,
        _submissionTimeSubject.valueOrNull,
        _withSubmissionsSubject.valueOrNull!,
      );

      final hasAttachments = localFiles != null && localFiles.isNotEmpty;
      if (oldHomework == null) {
        // Falls der Nutzer keine Anhänge hochlädt, wird kein 'await' verwendet,
        // weil die Daten sofort in Firestore gespeichert werden können und somit
        // auch offline hinzufügbar sind.
        hasAttachments ? await api.create(userInput) : api.create(userInput);

        if (_markdownAnalytics.containsMarkdown(description)) {
          _markdownAnalytics.logMarkdownUsedHomework();
        }
      } else {
        // Falls ein Nutzer Anhänge beim Bearbeiten enfernt hat, werden die IDs
        // dieser Anhänge in [removedCloudFiles] gespeichert und über das HomeworkGateway
        // von der Hausaufgabe entfernt.
        final removedCloudFiles = matchRemovedCloudFilesFromTwoList(
            initialCloudFiles, _cloudFilesSubject.valueOrNull!);
        if (hasAttachments) {
          await api.edit(oldHomework, userInput,
              removedCloudFiles: removedCloudFiles);
        } else {
          api.edit(oldHomework, userInput,
              removedCloudFiles: removedCloudFiles);
        }

        // Falls beim Bearbeiten ein Markdown-Text hinzugefügt wurde, wird dies
        // geloggt.
        if (!_markdownAnalytics.containsMarkdown(oldHomework.description)) {
          _markdownAnalytics.logMarkdownUsedHomework();
        }
      }
    }
  }

  @override
  void dispose() {
    _titleSubject.close();
    _descriptionSubject.close();
    _courseSegmentSubject.close();
    _todoUntilSubject.close();
    _privateSubject.close();
    _localFilesSubject.close();
    _cloudFilesSubject.close();
    _sendNotificationSubject.close();
    _withSubmissionsSubject.close();
    _submissionTimeSubject.close();
  }
}

class InvalidTitleException implements Exception {}

class InvalidCourseException implements Exception {}

class InvalidTodoUntilException implements Exception {}

class UserInput {
  final String? title, description;
  final Course? course;
  DateTime? todoUntil;
  final bool? private;
  final List<LocalFile>? localFiles;
  final bool? sendNotification;
  final bool withSubmission;

  UserInput(
    this.title,
    this.course,
    final DateTime todoUntil,
    this.description,
    this.private,
    this.localFiles,
    this.sendNotification,
    final Time? submissionTime,
    this.withSubmission,
  ) {
    if (withSubmission && submissionTime != null) {
      this.todoUntil = DateTime(todoUntil.year, todoUntil.month, todoUntil.day,
          submissionTime.hour, submissionTime.minute);
    } else {
      this.todoUntil = todoUntil;
    }
  }
}

class HomeworkDialogApi {
  final SharezoneGateway api;
  final NextLessonCalculator nextLessonCalculator;

  HomeworkDialogApi(this.api, this.nextLessonCalculator);

  Future<HomeworkDto> create(UserInput userInput) async {
    final localFiles = userInput.localFiles;
    final course = userInput.course!;
    final authorReference = api.references.users.doc(api.user.authUser!.uid);
    final authorName = (await api.user.userStream.first)!.name;
    final authorID = api.user.authUser!.uid;
    final typeOfUser = (await api.user.userStream.first)!.typeOfUser;

    final attachments = await api.fileSharing.uploadAttachments(
        localFiles, userInput.course!.id, authorReference.id, authorName);

    final homework = HomeworkDto.create(
            courseReference: api.references.getCourseReference(course.id),
            courseID: course.id)
        .copyWith(
      subject: course.subject,
      subjectAbbreviation: course.abbreviation,
      courseName: course.name,
      authorReference: authorReference,
      authorID: authorID,
      title: userInput.title,
      description: userInput.description,
      todoUntil: userInput.todoUntil,
      attachments: attachments,
      withSubmissions: userInput.withSubmission,
      private: userInput.private,
      forUsers: <String, bool>{authorID: false},
      authorName: authorName,
      latestEditor: authorID,
      sendNotification: userInput.sendNotification,
      assignedUserArrays: AssignedUserArrays(
        allAssignedUids: [authorID],
        openStudentUids: [if (typeOfUser == TypeOfUser.student) authorID],
        completedStudentUids: [],
      ),
    );

    if (userInput.private!) {
      await api.homework.addPrivateHomework(homework, false,
          attachments: attachments, fileSharingGateway: api.fileSharing);
    } else {
      await api.homework.addHomeworkToCourse(homework,
          attachments: attachments, fileSharingGateway: api.fileSharing);
    }

    // If the homework will be added to the create, the wrong homework object will be return (the new forUsers map is missing)
    return homework;
  }

  Future<HomeworkDto> edit(HomeworkDto oldHomework, UserInput userInput,
      {List<CloudFile> removedCloudFiles = const []}) async {
    List<String> attachments = oldHomework.attachments.toList();
    final editorName = (await api.user.userStream.first)!.name;
    final editorID = api.user.authUser!.uid;

    for (int i = 0; i < removedCloudFiles.length; i++) {
      attachments.remove(removedCloudFiles[i].id);
      api.fileSharing.removeReferenceData(removedCloudFiles[i].id!,
          ReferenceData(type: ReferenceType.blackboard, id: oldHomework.id));
    }

    final localFiles = userInput.localFiles;
    final newAttachments = await api.fileSharing.uploadAttachments(
      localFiles,
      oldHomework.courseReference!.id,
      editorID,
      editorName,
    );
    attachments.addAll(newAttachments);

    final homework = oldHomework.copyWith(
      title: userInput.title,
      description: userInput.description,
      todoUntil: userInput.todoUntil,
      attachments: attachments,
      latestEditor: editorID,
      withSubmissions: userInput.withSubmission,
      sendNotification: userInput.sendNotification,
    );

    final hasAttachments = attachments.isNotEmpty;
    if (hasAttachments) {
      await api.homework.addPrivateHomework(homework, true,
          attachments: newAttachments, fileSharingGateway: api.fileSharing);
    } else {
      api.homework.addPrivateHomework(homework, true,
          attachments: newAttachments, fileSharingGateway: api.fileSharing);
    }
    return homework;
  }
}
