// Copyright (c) 2023 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:analytics/analytics.dart';
import 'package:bloc/bloc.dart';
import 'package:bloc_presentation/bloc_presentation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:common_domain_models/common_domain_models.dart';
import 'package:date/date.dart';
import 'package:equatable/equatable.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:files_basics/files_models.dart';
import 'package:files_basics/local_file.dart';
import 'package:filesharing_logic/filesharing_logic_models.dart';
import 'package:firebase_hausaufgabenheft_logik/firebase_hausaufgabenheft_logik.dart';
import 'package:group_domain_models/group_domain_models.dart';
import 'package:meta/meta.dart';
import 'package:sharezone/markdown/markdown_analytics.dart';
import 'package:sharezone/util/api.dart';
import 'package:sharezone/util/next_lesson_calculator/next_lesson_calculator.dart';
import 'package:time/time.dart';
import 'package:user/user.dart';

sealed class HomeworkDialogEvent extends Equatable {
  const HomeworkDialogEvent();
}

class Save extends HomeworkDialogEvent {
  const Save();

  @override
  List<Object?> get props => [];
}

class TitleChanged extends HomeworkDialogEvent {
  final String newTitle;

  const TitleChanged(this.newTitle);

  @override
  List<Object?> get props => [newTitle];
}

class DueDateChanged extends HomeworkDialogEvent {
  final Date newDueDate;

  const DueDateChanged(this.newDueDate);

  @override
  List<Object?> get props => [newDueDate];
}

class CourseChanged extends HomeworkDialogEvent {
  final CourseId newCourseId;

  const CourseChanged(this.newCourseId);

  @override
  List<Object?> get props => [newCourseId];
}

class SubmissionsChanged extends HomeworkDialogEvent {
  final ({bool enabled, Time? submissionTime}) newSubmissionsOptions;

  const SubmissionsChanged(this.newSubmissionsOptions);

  @override
  List<Object?> get props => [newSubmissionsOptions];
}

class DescriptionChanged extends HomeworkDialogEvent {
  final String newDescription;

  const DescriptionChanged(this.newDescription);

  @override
  List<Object?> get props => [newDescription];
}

class AttachmentsAdded extends HomeworkDialogEvent {
  final IList<LocalFile> newFiles;

  const AttachmentsAdded(this.newFiles);

  @override
  List<Object?> get props => [newFiles];
}

class AttachmentRemoved extends HomeworkDialogEvent {
  final FileId id;

  const AttachmentRemoved(this.id);

  @override
  List<Object?> get props => [id];
}

class NotifyCourseMembersChanged extends HomeworkDialogEvent {
  final bool newNotifyCourseMembers;

  const NotifyCourseMembersChanged(this.newNotifyCourseMembers);

  @override
  List<Object?> get props => [newNotifyCourseMembers];
}

class IsPrivateChanged extends HomeworkDialogEvent {
  final bool newIsPrivate;

  const IsPrivateChanged(this.newIsPrivate);

  @override
  List<Object?> get props => [newIsPrivate];
}

sealed class HomeworkDialogState extends Equatable {
  final bool isEditing;
  @override
  List<Object?> get props => [isEditing];

  const HomeworkDialogState({required this.isEditing});
}

class Ready extends HomeworkDialogState {
  final (String, {dynamic error}) title;
  final CourseState course;
  final (Date?, {dynamic error}) dueDate;
  final SubmissionState submissions;
  final String description;
  final IList<FileView> attachments;
  final bool notifyCourseMembers;
  final (bool, {bool isChangeable}) isPrivate;
  final bool hasModifiedData;

  @override
  List<Object?> get props => [
        title,
        course,
        dueDate,
        submissions,
        description,
        attachments,
        notifyCourseMembers,
        isPrivate,
        hasModifiedData,
        super.isEditing,
      ];

  const Ready({
    required this.title,
    required this.course,
    required this.dueDate,
    required this.submissions,
    required this.description,
    required this.attachments,
    required this.notifyCourseMembers,
    required this.isPrivate,
    required this.hasModifiedData,
    required super.isEditing,
  });
}

class SavedSucessfully extends HomeworkDialogState {
  @override
  List<Object?> get props => [super.isEditing];

  const SavedSucessfully({required super.isEditing});
}

class FileView extends Equatable {
  final FileId fileId;
  final String fileName;
  final FileFormat format;
  // TODO: Should be able to remove, because we use FileId now
  final LocalFile? localFile;
  final CloudFile? cloudFile;

  @override
  List<Object?> get props => [fileId, fileName, format, localFile, cloudFile];

  const FileView({
    required this.fileId,
    required this.fileName,
    required this.format,
    this.localFile,
    this.cloudFile,
  }) : assert((localFile != null && cloudFile == null) ||
            (localFile == null && cloudFile != null));
}

sealed class SubmissionState extends Equatable {
  bool get isChangeable;
  bool get isEnabled => this is SubmissionsEnabled;
  const SubmissionState();
}

class SubmissionsDisabled extends SubmissionState {
  /// If the user can update the [SubmissionState], i.e. turn on submissions.
  ///
  /// If a homework is private submissions can not be turned on. This field
  /// would be `true` in this case.
  @override
  final bool isChangeable;
  @override
  List<Object?> get props => [isChangeable];

  const SubmissionsDisabled({required this.isChangeable});
}

class SubmissionsEnabled extends SubmissionState {
  @override
  bool get isChangeable => true;

  final Time deadline;
  @override
  List<Object?> get props => [isChangeable, deadline];

  const SubmissionsEnabled({required this.deadline});
}

sealed class CourseState extends Equatable {
  const CourseState();
}

class NoCourseChosen extends CourseState {
  final dynamic error;
  @override
  List<Object?> get props => [error];

  const NoCourseChosen({this.error});
}

class CourseChosen extends CourseState {
  final CourseId courseId;
  final String courseName;

  /// If the user can update the [CourseState]..
  ///
  /// If editing an existing homework this will be `false`, since one can't move
  /// a homework from course a to course b.
  final bool isChangeable;

  @override
  List<Object?> get props => [courseId, courseName, isChangeable];

  const CourseChosen({
    required this.courseId,
    required this.courseName,
    required this.isChangeable,
  });
}

class LoadingHomework extends HomeworkDialogState {
  final HomeworkId homework;
  @override
  List<Object?> get props => [homework, super.isEditing];

  const LoadingHomework(this.homework, {required super.isEditing});
}

@visibleForTesting
final emptyCreateHomeworkDialogState = Ready(
  title: ('', error: null),
  course: const NoCourseChosen(),
  dueDate: (null, error: null),
  submissions: const SubmissionsDisabled(isChangeable: true),
  description: '',
  attachments: IList(),
  notifyCourseMembers: false,
  isPrivate: (false, isChangeable: true),
  hasModifiedData: false,
  isEditing: false,
);

class _LoadedHomeworkData extends HomeworkDialogEvent {
  @override
  List<Object?> get props => [];
}

sealed class HomeworkDialogBlocPresentationEvent extends Equatable {
  const HomeworkDialogBlocPresentationEvent();
}

class StartedUploadingAttachments extends HomeworkDialogBlocPresentationEvent {
  const StartedUploadingAttachments();

  @override
  List<Object?> get props => [];
}

// TODO: Use
class SavingFailed extends HomeworkDialogBlocPresentationEvent {
  const SavingFailed(this.error, this.stackTrace);

  final dynamic error;
  final StackTrace? stackTrace;

  @override
  List<Object?> get props => [error, stackTrace];
}

/// Since [HomeworkDto] can't have a null value for [todoUntil] we need to use
/// a magic number to know if the user changed the due date and submission time
/// or not.
final _kNoDateSelectedDateTime = DateTime(1337, 13, 37, 13, 37, 13, 37);
HomeworkDto _kNoDataChangedHomework = HomeworkDto.create(courseID: '')
    .copyWith(todoUntil: _kNoDateSelectedDateTime);

class EmptyTitleException extends Equatable implements Exception {
  const EmptyTitleException();

  @override
  List<Object?> get props => [];
}

class NoCourseChosenException extends Equatable implements Exception {
  const NoCourseChosenException();

  @override
  List<Object?> get props => [];
}

class NoDueDateSelectedException extends Equatable implements Exception {
  const NoDueDateSelectedException();

  @override
  List<Object?> get props => [];
}

class HomeworkDialogBloc extends Bloc<HomeworkDialogEvent, HomeworkDialogState>
    with
        BlocPresentationMixin<HomeworkDialogState,
            HomeworkDialogBlocPresentationEvent> {
  final HomeworkDialogApi api;
  final Analytics analytics;
  final MarkdownAnalytics markdownAnalytics;
  final NextLessonCalculator nextLessonCalculator;
  HomeworkDto? _initialHomework;
  late final IList<CloudFile> _initialAttachments;
  late final bool isEditing;

  bool finishedInitializing = false;

  bool showTitleEmptyError = false;
  bool showNoCourseChosenError = false;
  bool showNoDueDateChosenError = false;

  late HomeworkDto _homework;
  var _cloudFiles = IList<CloudFile>();
  var _localFiles = IList<LocalFile>();

  @override
  void onEvent(HomeworkDialogEvent event) {
    super.onEvent(event);
    if (event is! _LoadedHomeworkData && !finishedInitializing) {
      throw StateError('Bloc has not finished initializing yet. Events should '
          'not be added before the initialization is finished. If you see this '
          'error is thrown in a test, either await the first $Ready state or '
          'use `pumpEventQueue` after creating the bloc.');
    }
  }

  HomeworkDialogBloc({
    required this.api,
    required this.nextLessonCalculator,
    required this.analytics,
    required this.markdownAnalytics,
    HomeworkId? homeworkId,
  }) : super(homeworkId != null
            ? LoadingHomework(homeworkId, isEditing: true)
            : emptyCreateHomeworkDialogState) {
    isEditing = homeworkId != null;
    if (isEditing) {
      _loadExistingData(homeworkId!);
    } else {
      _homework = _kNoDataChangedHomework;
      _initialAttachments = IList();
      finishedInitializing = true;
    }

    on<_LoadedHomeworkData>(
      (event, emit) {
        // Because currently sendNotifications can be true for existing
        // homeworks and because we don't want to set the UI value depending on
        // the existing value, we set the value to false here.
        // This also helps us when comparing if the user changed the homework by
        // using `_initialHomework != _homework` since otherwise it might be
        // false when the user didn't change anything as the sendNotification
        // value might be `true` in the _initialHomework.
        _initialHomework = _initialHomework!.copyWith(sendNotification: false);
        _homework = _initialHomework!;
        _cloudFiles = _initialAttachments;
        finishedInitializing = true;

        emit(_getNewState());
      },
    );
    on<Save>(
      (event, emit) async {
        bool hasInputErrors = false;
        if (_homework.title.isEmpty) {
          showTitleEmptyError = true;
          hasInputErrors = true;
        }
        if (_homework.courseID.isEmpty) {
          showNoCourseChosenError = true;
          hasInputErrors = true;
        }
        if (_homework.todoUntil.year == _kNoDateSelectedDateTime.year) {
          showNoDueDateChosenError = true;
          hasInputErrors = true;
        }
        if (hasInputErrors) {
          emit(_getNewState());
          return;
        }

        final userInput = UserInput(
          title: _homework.title,
          todoUntil: DateTime(
            _homework.todoUntil.year,
            _homework.todoUntil.month,
            _homework.todoUntil.day,
            _homework.withSubmissions ? _homework.todoUntil.hour : 0,
            _homework.withSubmissions ? _homework.todoUntil.minute : 0,
          ),
          description: _homework.description,
          withSubmission: _homework.withSubmissions,
          localFiles: _localFiles,
          sendNotification: _homework.sendNotification,
          private: _homework.private,
        );

        // TODO: Can the offline behavior be tested?
        if (isEditing) {
          try {
            // try-catch won't work for this case as we don't await the future.
            // This might be solved with Zones (handleUncaughtError).
            if (userInput.localFiles.isEmpty) {
              // If user is offline Firestore will add the homework locally but
              // won't complete the future until the server has received the
              // homework. We remove the await so that the user can save the
              // homework while being offline.
              api.editHomework(HomeworkId(_homework.id), userInput,
                  removedCloudFiles:
                      _initialAttachments.removeAll(_cloudFiles).toList());
            } else {
              emitPresentation(const StartedUploadingAttachments());
              // As we can't save a homework with attachments when we are offline,
              // we await the future here.
              await api.editHomework(HomeworkId(_homework.id), userInput,
                  removedCloudFiles:
                      _initialAttachments.removeAll(_cloudFiles).toList());
            }
          } catch (e, s) {
            emitPresentation(SavingFailed(e, s));
            return;
          }

          analytics.log(NamedAnalyticsEvent(name: 'homework_edit'));
          if (markdownAnalytics.containsMarkdown(_homework.description) &&
              !markdownAnalytics
                  .containsMarkdown(_initialHomework?.description ?? '')) {
            markdownAnalytics.logMarkdownUsedHomework();
          }
        } else {
          try {
            // try-catch won't work for this case as we don't await the future.
            // This might be solved with Zones (handleUncaughtError).
            if (userInput.localFiles.isEmpty) {
              // If user is offline Firestore will add the homework locally but
              // won't complete the future until the server has received the
              // homework. We remove the await so that the user can save the
              // homework while being offline.
              api.createHomework(CourseId(_homework.courseID), userInput);
            } else {
              emitPresentation(const StartedUploadingAttachments());
              // As we can't save a homework with attachments when we are offline,
              // we await the future here.
              await api.createHomework(CourseId(_homework.courseID), userInput);
            }
          } catch (e, s) {
            emitPresentation(SavingFailed(e, s));
            return;
          }

          analytics.log(NamedAnalyticsEvent(name: 'homework_add'));
          if (markdownAnalytics.containsMarkdown(_homework.description)) {
            markdownAnalytics.logMarkdownUsedHomework();
          }
        }

        emit(SavedSucessfully(isEditing: isEditing));
      },
    );
    on<TitleChanged>(
      (event, emit) {
        _homework = _homework.copyWith(title: event.newTitle);
        if (showTitleEmptyError && _homework.title.isNotEmpty) {
          showTitleEmptyError = false;
        }
        emit(_getNewState());
      },
    );
    on<DueDateChanged>(
      (event, emit) {
        _homework = _homework.copyWith(
            // copyWith because we need to keep the magic "not changed" value for
            // the submission time (hour, minute, second, etc.).
            todoUntil: _homework.todoUntil.copyWith(
          year: event.newDueDate.year,
          month: event.newDueDate.month,
          day: event.newDueDate.day,
        ));
        if (showNoDueDateChosenError) {
          showNoDueDateChosenError = false;
        }
        emit(_getNewState());
      },
    );
    on<CourseChanged>(
      (event, emit) async {
        final course = await api.loadCourse(event.newCourseId);
        if (showNoCourseChosenError) {
          showNoCourseChosenError = false;
        }
        _homework =
            _homework.copyWith(courseID: course.id, courseName: course.name);

        emit(_getNewState());

        // Manual date was already set, we don't want to overwrite it.
        if (_homework.todoUntil.year != _kNoDateSelectedDateTime.year) {
          return;
        }
        final nextLesson =
            await nextLessonCalculator.tryCalculateNextLesson(course.id);
        if (nextLesson != null) {
          add(DueDateChanged(nextLesson));
        }
      },
    );
    on<SubmissionsChanged>(
      (event, emit) {
        _homework = _homework.copyWith(
          withSubmissions: event.newSubmissionsOptions.enabled,
          // copyWith because we need to keep the magic "not changed" value for
          // the due date (year, month, day attributes).
          todoUntil: _homework.todoUntil.copyWith(
            hour: event.newSubmissionsOptions.submissionTime?.hour ?? 23,
            minute: event.newSubmissionsOptions.submissionTime?.minute ?? 59,
            // Remove magic number used to indicate that submission time has not
            // been changed.
            millisecond: 0,
            microsecond: 0,
          ),
        );
        emit(_getNewState());
      },
    );
    on<DescriptionChanged>(
      (event, emit) {
        _homework = _homework.copyWith(description: event.newDescription);
        emit(_getNewState());
      },
    );
    on<AttachmentsAdded>(
      (event, emit) {
        _localFiles = _localFiles.addAll(event.newFiles);
        emit(_getNewState());
      },
    );
    on<AttachmentRemoved>(
      (event, emit) {
        _localFiles =
            _localFiles.removeWhere((file) => file.fileId == event.id);
        _cloudFiles = _cloudFiles
            .removeWhere((cloudFile) => FileId(cloudFile.id!) == event.id);

        emit(_getNewState());
      },
    );
    on<NotifyCourseMembersChanged>(
      (event, emit) {
        _homework =
            _homework.copyWith(sendNotification: event.newNotifyCourseMembers);
        emit(_getNewState());
      },
    );
    on<IsPrivateChanged>(
      (event, emit) {
        _homework = _homework.copyWith(private: event.newIsPrivate);
        emit(_getNewState());
      },
    );
  }

  Ready _getNewState() {
    final didHomeworkChange = isEditing
        ? _initialHomework != _homework
        : _homework != _kNoDataChangedHomework;
    final didFilesChange = _initialAttachments != _cloudFiles;
    final didLocalFilesChange = _localFiles.isNotEmpty;
    final didDataChange =
        didHomeworkChange || didFilesChange || didLocalFilesChange;

    final hasChangedTodoDate =
        _homework.todoUntil.year != _kNoDataChangedHomework.todoUntil.year;
    final hasUserEditedSubmissionTime =
        _homework.todoUntil.millisecond != _kNoDateSelectedDateTime.millisecond;

    return Ready(
      title: (
        _homework.title,
        error: showTitleEmptyError ? const EmptyTitleException() : null
      ),
      course: _homework.courseID != ''
          ? CourseChosen(
              courseId: CourseId(_homework.courseID),
              courseName: _homework.courseName,
              isChangeable: !isEditing,
            )
          : NoCourseChosen(
              error: showNoCourseChosenError
                  ? const NoCourseChosenException()
                  : null,
            ),
      dueDate: (
        hasChangedTodoDate ? Date.fromDateTime(_homework.todoUntil) : null,
        error: showNoDueDateChosenError
            ? const NoDueDateSelectedException()
            : null,
      ),
      submissions: _homework.withSubmissions
          ? SubmissionsEnabled(
              deadline: hasUserEditedSubmissionTime
                  ? _homework.todoUntil.toTime()
                  : Time(hour: 23, minute: 59))
          : SubmissionsDisabled(isChangeable: !_homework.private),
      description: _homework.description,
      attachments: IList([
        for (final attachment in _localFiles)
          FileView(
            fileId: attachment.fileId,
            fileName: attachment.getName(),
            format:
                fileFormatEnumFromFilenameWithExtension(attachment.getName()),
            localFile: attachment,
          ),
        for (final attachment in _cloudFiles)
          FileView(
            fileId: FileId(attachment.id!),
            fileName: attachment.name,
            format: attachment.fileFormat,
            cloudFile: attachment,
          ),
      ]),
      notifyCourseMembers: _homework.sendNotification,
      isPrivate: (
        _homework.private,
        isChangeable: !(isEditing || _homework.withSubmissions)
      ),
      hasModifiedData: didDataChange,
      isEditing: isEditing,
    );
  }

  Future<void> _loadExistingData(HomeworkId homeworkId) async {
    _initialHomework = await api.loadHomework(homeworkId);
    _initialAttachments = (await api.loadCloudFiles(
      homeworkId: _initialHomework!.id,
    ))
        .toIList();
    add(_LoadedHomeworkData());
  }
}

extension LocalFileHashcodeFileId on LocalFile {
  FileId get fileId => FileId(hashCode.toString());
}

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
    // TODO: Fallback to internet?
    return _api.homework.singleHomework(homeworkId.id, source: Source.cache);
  }

  Future<List<CloudFile>> loadCloudFiles({required String homeworkId}) async {
    final homework = await _api.homework.singleHomeworkStream(homeworkId).first;
    return _api.fileSharing.cloudFilesGateway
        .filesStreamAttachment(homework.courseID, homeworkId)
        .first;
  }

  Future<Course> loadCourse(CourseId courseId) async {
    return (await _api.course.streamCourse(courseId.id).first)!;
  }

  Future<HomeworkDto> createHomework(
      CourseId courseId, UserInput userInput) async {
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

  Future<HomeworkDto> editHomework(HomeworkId homeworkId, UserInput userInput,
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
