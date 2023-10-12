// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'dart:async';

import 'package:analytics/analytics.dart';
import 'package:bloc_base/bloc_base.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:common_domain_models/common_domain_models.dart';
import 'package:equatable/equatable.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:files_basics/local_file.dart';
import 'package:filesharing_logic/filesharing_logic_models.dart';
import 'package:firebase_hausaufgabenheft_logik/firebase_hausaufgabenheft_logik.dart';
import 'package:group_domain_models/group_domain_models.dart';
import 'package:rxdart/rxdart.dart';
import 'package:sharezone/markdown/markdown_analytics.dart';
import 'package:sharezone/util/api.dart';
import 'package:sharezone/util/next_lesson_calculator/next_lesson_calculator.dart';
import 'package:sharezone_common/helper_functions.dart';
import 'package:time/time.dart';
import 'package:user/user.dart';

class HomeworkDialogBloc extends BlocBase {
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
  final NextLessonCalculator nextLessonCalculator;
  final HomeworkDto? initialHomework;

  final MarkdownAnalytics _markdownAnalytics;
  final Analytics analytics;

  HomeworkDialogBloc(this.api, this.nextLessonCalculator,
      this._markdownAnalytics, this.analytics,
      {HomeworkDto? homework})
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
        name: homework.courseName,
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

  Stream<String> get title =>
      _titleSubject.stream.transform(_validateTitleTransformer);
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
    nextLessonCalculator.calculateNextLesson(courseID).then((result) {
      // If the user has closed the dialog before the result is calculated, the
      // stream is closed. In this case, the result is not used.
      if (_todoUntilSubject.isClosed) return;

      if (result == null) {
        changeTodoUntil(_getSeedTodoUntilDate());
      } else {
        changeTodoUntil(result.toDateTime);
      }
    });
  }

  final _validateTitleTransformer =
      StreamTransformer<String?, String>.fromHandlers(
          handleData: (title, sink) {
    if (isEmptyOrNull(title)) {
      sink.addError(EmptyTitleException());
    } else {
      sink.add(title!);
    }
  });

  void validateInputOrThrow() {
    bool isNullOrEmpty(String? s) => s == null || s.isEmpty;

    // This should be the same behavior as for [_validateTitleTransformer]
    // above.
    if (isNullOrEmpty(_titleSubject.valueOrNull)) {
      throw EmptyTitleException();
    }

    if (_courseSegmentSubject.valueOrNull == null) {
      throw EmptyCourseException();
    }

    if (_todoUntilSubject.valueOrNull == null) {
      throw EmptyTodoUntilException();
    }
  }

  Future<void> _loadInitialCloudFiles(
      String courseID, String homeworkID) async {
    final cloudFiles = await api.loadCloudFiles(homeworkId: homeworkID);
    _cloudFilesSubject.sink.add(cloudFiles);
    initialCloudFiles.addAll(cloudFiles);
  }

  Future<void> submit() async {
    validateInputOrThrow();
    final todoUntil = DateTime(
      _todoUntilSubject.value.year,
      _todoUntilSubject.value.month,
      _todoUntilSubject.value.day,
      _submissionTimeSubject.valueOrNull?.hour ?? 0,
      _submissionTimeSubject.valueOrNull?.minute ?? 0,
    );
    final courseId = CourseId(_courseSegmentSubject.value.id);
    final description = _descriptionSubject.valueOrNull;
    final private = _privateSubject.value;
    final localFiles = IList(_localFilesSubject.value);

    final userInput = UserInput(
      title: _titleSubject.value!,
      todoUntil: todoUntil,
      description: _descriptionSubject.value,
      private: private,
      localFiles: localFiles,
      sendNotification: _sendNotificationSubject.value,
      withSubmission: _withSubmissionsSubject.value,
    );

    final hasAttachments = localFiles.isNotEmpty;

    if (initialHomework == null) {
      // Falls der Nutzer keine Anhänge hochlädt, wird kein 'await' verwendet,
      // weil die Daten sofort in Firestore gespeichert werden können und somit
      // auch offline hinzufügbar sind.
      hasAttachments
          ? await api.create(courseId, userInput)
          : api.create(courseId, userInput);

      if (_markdownAnalytics.containsMarkdown(description)) {
        _markdownAnalytics.logMarkdownUsedHomework();
      }
      analytics.log(NamedAnalyticsEvent(name: "homework_add"));
    } else {
      // Falls ein Nutzer Anhänge beim Bearbeiten enfernt hat, werden die IDs
      // dieser Anhänge in [removedCloudFiles] gespeichert und über das HomeworkGateway
      // von der Hausaufgabe entfernt.
      final removedCloudFiles = matchRemovedCloudFilesFromTwoList(
          initialCloudFiles, _cloudFilesSubject.valueOrNull!);
      if (hasAttachments) {
        await api.edit(HomeworkId(initialHomework!.id), userInput,
            removedCloudFiles: removedCloudFiles);
      } else {
        api.edit(HomeworkId(initialHomework!.id), userInput,
            removedCloudFiles: removedCloudFiles);
      }

      // If markdown is added to the edited homework and the homework didn't
      // contain markdown before, log it.
      if (!_markdownAnalytics.containsMarkdown(initialHomework!.description) &&
          _markdownAnalytics.containsMarkdown(description)) {
        _markdownAnalytics.logMarkdownUsedHomework();
      }
      analytics.log(NamedAnalyticsEvent(name: "homework_edit"));
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

sealed class InvalidHomeworkInputException implements Exception {}

class EmptyTitleException implements InvalidHomeworkInputException {}

class EmptyCourseException implements InvalidHomeworkInputException {}

class EmptyTodoUntilException implements InvalidHomeworkInputException {}

class UserInput extends Equatable {
  final String title;
  final String description;
  final DateTime todoUntil;
  final bool private;
  final IList<LocalFile> localFiles;
  final bool sendNotification;
  final bool withSubmission;

  @override
  List<Object?> get props => [
        title,
        description,
        todoUntil,
        private,
        localFiles,
        sendNotification,
        withSubmission
      ];

  const UserInput({
    required this.title,
    required this.todoUntil,
    required this.description,
    required this.private,
    required this.localFiles,
    required this.sendNotification,
    required this.withSubmission,
  });
}

class HomeworkDialogApi {
  final SharezoneGateway _api;

  HomeworkDialogApi(this._api);

  Future<HomeworkDto> loadHomework(HomeworkId homeworkId) async {
    return _api.homework.singleHomework(homeworkId.id, source: Source.cache);
  }

  Future<List<CloudFile>> loadCloudFiles({required String homeworkId}) async {
    final homework = await _api.homework.singleHomeworkStream(homeworkId).first;
    return _api.fileSharing.cloudFilesGateway
        .filesStreamAttachment(homework.courseID, homeworkId)
        .first;
  }

  Future<HomeworkDto> create(CourseId courseId, UserInput userInput) async {
    final localFiles = userInput.localFiles;
    final course = (await _api.course.streamCourse(courseId.id).first)!;
    final authorReference = _api.references.users.doc(_api.user.authUser!.uid);
    final authorName = (await _api.user.userStream.first)!.name;
    final authorID = _api.user.authUser!.uid;
    final typeOfUser = (await _api.user.userStream.first)!.typeOfUser;

    final attachments = await _api.fileSharing.uploadAttachments(
        localFiles, courseId.id, authorReference.id, authorName);

    final homework = HomeworkDto.create(
            courseReference: _api.references.getCourseReference(course.id),
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

    if (userInput.private) {
      await _api.homework.addPrivateHomework(homework, false,
          attachments: attachments, fileSharingGateway: _api.fileSharing);
    } else {
      await _api.homework.addHomeworkToCourse(homework,
          attachments: attachments, fileSharingGateway: _api.fileSharing);
    }

    // If the homework will be added to the create, the wrong homework object will be return (the new forUsers map is missing)
    return homework;
  }

  Future<HomeworkDto> edit(HomeworkId homeworkId, UserInput userInput,
      {List<CloudFile> removedCloudFiles = const []}) async {
    final oldHomework =
        await _api.homework.singleHomeworkStream(homeworkId.id).first;
    List<String> attachments = oldHomework.attachments.toList();
    final editorName = (await _api.user.userStream.first)!.name;
    final editorID = _api.user.authUser!.uid;

    for (int i = 0; i < removedCloudFiles.length; i++) {
      attachments.remove(removedCloudFiles[i].id);
      _api.fileSharing.removeReferenceData(removedCloudFiles[i].id!,
          ReferenceData(type: ReferenceType.blackboard, id: oldHomework.id));
    }

    final localFiles = userInput.localFiles;
    final newAttachments = await _api.fileSharing.uploadAttachments(
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
      await _api.homework.addPrivateHomework(homework, true,
          attachments: newAttachments, fileSharingGateway: _api.fileSharing);
    } else {
      _api.homework.addPrivateHomework(homework, true,
          attachments: newAttachments, fileSharingGateway: _api.fileSharing);
    }
    return homework;
  }
}
