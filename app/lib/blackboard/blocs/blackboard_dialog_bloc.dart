// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:bloc_base/bloc_base.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:files_basics/local_file.dart';
import 'package:filesharing_logic/filesharing_logic_models.dart';
import 'package:group_domain_models/group_domain_models.dart';
import 'package:rxdart/rxdart.dart';
import 'package:sharezone/blackboard/blackboard_item.dart';
import 'package:sharezone/markdown/markdown_analytics.dart';
import 'package:sharezone/util/api.dart';
import 'package:sharezone_common/api_errors.dart';
import 'package:sharezone_common/blackboard_validators.dart';
import 'package:sharezone_common/helper_functions.dart';
import 'package:sharezone_common/validators.dart';

class BlackboardDialogBloc extends BlocBase with BlackboardValidators {
  List<CloudFile> initialCloudFiles = [];
  final _titleSubject = BehaviorSubject<String>();
  final _courseSegmentSubject = BehaviorSubject<Course>();
  final _textSubject = BehaviorSubject<String>();
  final _pictureURLSubject = BehaviorSubject<String>();
  final _localFilesSubject = BehaviorSubject.seeded(<LocalFile>[]);
  final _cloudFilesSubject = BehaviorSubject.seeded(<CloudFile>[]);
  final _sendNotificationSubject = BehaviorSubject<bool>();

  final BlackboardDialogApi api;
  final BlackboardItem? initialBlackboardItem;

  final MarkdownAnalytics _markdownAnalytics;

  BlackboardDialogBloc(
    this.api,
    this._markdownAnalytics, {
    BlackboardItem? blackboardItem,
  }) : initialBlackboardItem = blackboardItem {
    if (blackboardItem != null) {
      loadInitialCloudFiles(
          blackboardItem.courseReference!.id, blackboardItem.id);

      changeTitle(blackboardItem.title);
      if (blackboardItem.text != null) {
        changeText(blackboardItem.text!);
      }
      if (blackboardItem.pictureURL != null) {
        changePictureURL(blackboardItem.pictureURL!);
      }
      changeSendNotification(false);
      final c = Course.create().copyWith(
        subject: blackboardItem.subject,
        name: blackboardItem.subject,
        sharecode: "000000",
        abbreviation: blackboardItem.subjectAbbreviation,
        id: blackboardItem.courseReference!.id,
      );
      changeCourseSegment(c);
    }
  }

  Stream<String> get title => _titleSubject.stream.transform(validateTitle);
  Stream<Course> get courseSegment => _courseSegmentSubject;
  Stream<String> get text => _textSubject;
  Stream<String> get pictureURL => _pictureURLSubject;
  Stream<List<LocalFile>> get localFiles => _localFilesSubject;
  Stream<List<CloudFile>> get cloudFiles => _cloudFilesSubject;
  Stream<bool> get sendNotification => _sendNotificationSubject;

  Function(String) get changeTitle => _titleSubject.sink.add;
  Function(Course) get changeCourseSegment => _courseSegmentSubject.sink.add;
  Function(String) get changeText => _textSubject.sink.add;
  Function(String) get changePictureURL => _pictureURLSubject.sink.add;
  Function(bool) get changeSendNotification =>
      _sendNotificationSubject.sink.add;
  Function(List<LocalFile>) get addLocalFile => (localFiles) {
        final list = <LocalFile>[];
        list.addAll(_localFilesSubject.value);
        list.addAll(localFiles);
        _localFilesSubject.sink.add(list);
      };
  Function(LocalFile) get removeLocalFile => (localFile) {
        final list = <LocalFile>[];
        list.addAll(_localFilesSubject.value);
        list.remove(localFile);
        _localFilesSubject.sink.add(list);
      };
  Function(CloudFile) get removeCloudFile => (cloudFile) {
        final list = <CloudFile>[];
        list.addAll(_cloudFilesSubject.value);
        list.remove(cloudFile);
        _cloudFilesSubject.sink.add(list);
      };

  Future<void> loadInitialCloudFiles(
      String courseID, String blackboardItemID) async {
    List<CloudFile> cloudFiles = await api.api.fileSharing.cloudFilesGateway
        .filesStreamAttachment(courseID, blackboardItemID)
        .first;
    _cloudFilesSubject.sink.add(cloudFiles);
    initialCloudFiles.addAll(cloudFiles);
  }

  bool isValid() {
    final validatorTitle = NotEmptyOrNullValidator(_titleSubject.valueOrNull);
    if (!validatorTitle.isValid()) {
      _titleSubject.addError(
          TextValidationException(BlackboardValidators.emptyTitleUserMessage));
      throw InvalidTitleException();
    }

    final validatorCourse = NotNullValidator(_courseSegmentSubject.valueOrNull);
    if (!validatorCourse.isValid()) {
      _courseSegmentSubject.addError(
          TextValidationException(BlackboardValidators.emptyCourseUserMessage));
      throw InvalidCourseException();
    }

    return true;
  }

  /// Prüfen, ob der Nutzer in den Eingabefelder etwas geändert hat. Falls ja,
  /// wird true zurückgegeben.
  ///
  /// Attribut [pictureURL] & [sendNotification] werden vernachlässigt, da
  /// dieser Input kein großer Verlust ist, wenn man versehentlich den Dialog
  /// schließt.
  bool hasInputChanged() {
    final title = _titleSubject.valueOrNull;
    final course = _courseSegmentSubject.valueOrNull;
    final text = _textSubject.valueOrNull;
    final localFiles = _localFilesSubject.valueOrNull;

    final hasAttachments = localFiles != null && localFiles.isNotEmpty;
    final cloudFiles =
        _cloudFilesSubject.valueOrNull!.map((cf) => cf.id).toList();

    // Prüfen, ob Nutzer eine neue Hausaufgabe erstellt
    if (initialBlackboardItem == null) {
      return isNotEmptyOrNull(title) ||
          isNotEmptyOrNull(text) ||
          hasAttachments ||
          course != null;
    } else {
      return title != initialBlackboardItem?.title ||
          text != initialBlackboardItem?.text ||
          course?.id != initialBlackboardItem?.courseReference?.id ||
          hasAttachments ||
          initialBlackboardItem?.attachments.length != cloudFiles.length;
    }
  }

  Future<void> submit({BlackboardItem? oldBlackboardItem}) async {
    if (isValid()) {
      final title = _titleSubject.valueOrNull;
      final course = _courseSegmentSubject.valueOrNull;
      final text = _textSubject.valueOrNull;
      final pictureURL = _pictureURLSubject.valueOrNull;
      final localFiles = _localFilesSubject.valueOrNull;
      final sendNotification = _sendNotificationSubject.valueOrNull;

      final userInput = UserInput(
        title: title!,
        course: course!,
        text: text,
        pictureURL: pictureURL,
        localFiles: localFiles,
        sendNotification: sendNotification,
      );

      final hasAttachments = localFiles != null && localFiles.isNotEmpty;
      if (oldBlackboardItem == null) {
        // Falls der Nutzer keine Anhänge hochlädt, wird kein 'await' verwendet,
        // weil die Daten sofort in Firestore gespeichert werden können und somit
        // auch offline hinzufügbar sind.
        hasAttachments ? await api.create(userInput) : api.create(userInput);

        if (_markdownAnalytics.containsMarkdown(text)) {
          _markdownAnalytics.logMarkdownUsedBlackboard();
        }
      } else {
        final removedCloudFiles = matchRemovedCloudFilesFromTwoList(
          initialCloudFiles,
          _cloudFilesSubject.valueOrNull!,
        );

        // Falls der Nutzer keine Anhänge hochlädt, wird kein 'await' verwendet,
        // weil die Daten sofort in Firestore gespeichert werden können und somit
        // auch offline hinzufügbar sind.
        hasAttachments
            ? await api.edit(oldBlackboardItem, userInput, removedCloudFiles)
            : api.edit(oldBlackboardItem, userInput, removedCloudFiles);

        if (!_markdownAnalytics.containsMarkdown(oldBlackboardItem.text)) {
          _markdownAnalytics.logMarkdownUsedBlackboard();
        }
      }
    }
  }

  @override
  void dispose() {
    _titleSubject.close();
    _courseSegmentSubject.close();
    _textSubject.close();
    _pictureURLSubject.close();
    _localFilesSubject.close();
    _cloudFilesSubject.close();
    _sendNotificationSubject.close();
  }
}

class UserInput {
  final String title;
  final String? text, pictureURL;
  final Course course;
  final List<LocalFile>? localFiles;
  final bool? sendNotification;

  UserInput({
    required this.title,
    required this.course,
    this.text,
    this.pictureURL,
    this.localFiles,
    this.sendNotification,
  });
}

class BlackboardDialogApi {
  final SharezoneGateway api;

  BlackboardDialogApi(this.api);

  Future<BlackboardItem> create(UserInput userInput) async {
    final courseReference = api.references.courses.doc(userInput.course.id);
    final courseName = userInput.course.name;
    final subject = userInput.course.subject;
    final subjectAbbreviation = userInput.course.abbreviation;
    final pictureURL = userInput.pictureURL;
    final text = userInput.text;
    final title = userInput.title;
    final localFiles = userInput.localFiles;
    final sendNotification = userInput.sendNotification;

    final authorName = (await api.user.userStream.first)?.name ?? "-";
    final authorID = api.user.authUser!.uid;

    final attachments = await api.fileSharing.uploadAttachments(
      IList(localFiles ?? []),
      courseReference.id,
      authorID,
      authorName,
    );

    final blackboardItem = BlackboardItem.create(
            authorID: authorID, courseReference: courseReference)
        .copyWith(
      authorName: authorName,
      courseName: courseName,
      subject: subject,
      subjectAbbreviation: subjectAbbreviation,
      latestEditor: authorID,
      pictureURL: pictureURL,
      text: text,
      title: title,
      attachments: attachments,
      sendNotification: sendNotification,
      forUsers: {api.userId.toString(): false},
    );

    await api.blackboard.addBlackboardItemToCourse(
        blackboardItem, attachments, api.fileSharing);

    return blackboardItem;
  }

  Future<BlackboardItem> edit(BlackboardItem oldBlackboardItem,
      UserInput userInput, List<CloudFile> removedCloudFiles) async {
    final attachments = oldBlackboardItem.attachments.toList();

    final editorName = (await api.user.userStream.first)?.name ?? "-";
    final editorID = api.user.authUser!.uid;

    for (int i = 0; i < removedCloudFiles.length; i++) {
      attachments.remove(removedCloudFiles[i].id);
      api.fileSharing.removeReferenceData(
          removedCloudFiles[i].id!,
          ReferenceData(
              type: ReferenceType.blackboard, id: oldBlackboardItem.id));
    }

    final localFiles = userInput.localFiles;
    final newAttachments = await api.fileSharing.uploadAttachments(
      IList(localFiles ?? []),
      oldBlackboardItem.courseReference!.id,
      editorID,
      editorName,
    );
    attachments.addAll(newAttachments);

    final blackboardItem = oldBlackboardItem.copyWith(
      title: userInput.title,
      text: userInput.text,
      pictureURL: userInput.pictureURL,
      latestEditor: editorID,
      attachments: attachments,
      sendNotification: userInput.sendNotification,
    );

    await api.blackboard.add(blackboardItem, true,
        attachments: newAttachments,
        fileSharingGateway: api.fileSharing,
        courseID: userInput.course.id);

    return blackboardItem;
  }
}
