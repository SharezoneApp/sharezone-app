// Copyright (c) 2023 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:bloc/bloc.dart';
import 'package:bloc_presentation/bloc_presentation.dart';
import 'package:common_domain_models/common_domain_models.dart';
import 'package:date/date.dart';
import 'package:equatable/equatable.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:files_basics/files_models.dart';
import 'package:files_basics/local_file.dart';
import 'package:filesharing_logic/filesharing_logic_models.dart';
import 'package:firebase_hausaufgabenheft_logik/firebase_hausaufgabenheft_logik.dart';
import 'package:meta/meta.dart';
import 'package:sharezone/blocs/homework/homework_dialog_bloc.dart';
import 'package:time/time.dart';

sealed class HomeworkDialogEvent extends Equatable {
  const HomeworkDialogEvent();
}

class Submit extends HomeworkDialogEvent {
  const Submit();

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
  // TODO: Add error states (title, course, Due date?)
  final String title;
  final CourseState course;
  final Date? dueDate;
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
  // TODO: Remove?
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
  @override
  List<Object?> get props => [];
  const NoCourseChosen();
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
  title: '',
  course: const NoCourseChosen(),
  dueDate: null,
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

// TODO: Maybe two different classes - one if trying to save with invalid data
// and one if saving failed due to some other error?
// TODO: test
class SavingFailed extends HomeworkDialogBlocPresentationEvent {
  const SavingFailed();

  @override
  List<Object?> get props => [];
}

/// Since [HomeworkDto] can't have a null value for [todoUntil] we need to use
/// a magic number to know if the user changed the due date and submission time
/// or not.
final _kNoDateSelectedDateTime = DateTime(1337, 13, 37, 13, 37, 13, 37);
HomeworkDto _kNoDataChangedHomework = HomeworkDto.create(courseID: '')
    .copyWith(todoUntil: _kNoDateSelectedDateTime);

class NewHomeworkDialogBloc
    extends Bloc<HomeworkDialogEvent, HomeworkDialogState>
    with
        BlocPresentationMixin<HomeworkDialogState,
            HomeworkDialogBlocPresentationEvent> {
  final HomeworkDialogApi api;
  HomeworkDto? _initialHomework;
  late final IList<CloudFile> _initialAttachments;
  late final bool isEditing;

  late HomeworkDto _homework;
  var _cloudFiles = IList<CloudFile>();
  var _localFiles = IList<LocalFile>();

  NewHomeworkDialogBloc({required this.api, HomeworkId? homeworkId})
      : super(homeworkId != null
            ? LoadingHomework(homeworkId, isEditing: true)
            : emptyCreateHomeworkDialogState) {
    isEditing = homeworkId != null;
    if (isEditing) {
      _loadExistingData(homeworkId!);
    } else {
      _homework = _kNoDataChangedHomework;
      _initialAttachments = IList();
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

        emit(_getNewState());
      },
    );
    on<Submit>(
      (event, emit) async {
        await api.createHomework(
            CourseId(_homework.courseID),
            UserInput(
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
            ));

        emit(SavedSucessfully(isEditing: homeworkId != null));
      },
    );
    on<TitleChanged>(
      (event, emit) {
        _homework = _homework.copyWith(title: event.newTitle);
        emit(_getNewState());
      },
    );
    on<DueDateChanged>(
      (event, emit) {
        _homework = _homework.copyWith(
            // copyWith because we need to keep the magic "not changed" value to
            // know if the user changed the submission time.
            todoUntil: _homework.todoUntil.copyWith(
          year: event.newDueDate.year,
          month: event.newDueDate.month,
          day: event.newDueDate.day,
        ));
        emit(_getNewState());
      },
    );
    on<CourseChanged>(
      (event, emit) async {
        final course = await api.loadCourse(event.newCourseId);
        _homework =
            _homework.copyWith(courseID: course.id, courseName: course.name);
        emit(_getNewState());
      },
    );
    on<SubmissionsChanged>(
      (event, emit) {
        _homework = _homework.copyWith(
          withSubmissions: event.newSubmissionsOptions.enabled,
          // copyWith because we need to keep the magic "not changed" value to
          // know if the user changed the due date.
          todoUntil: _homework.todoUntil.copyWith(
            hour: event.newSubmissionsOptions.submissionTime?.hour ?? 23,
            minute: event.newSubmissionsOptions.submissionTime?.minute ?? 59,
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
      title: _homework.title,
      course: _homework.courseID != ''
          ? CourseChosen(
              courseId: CourseId(_homework.courseID),
              courseName: _homework.courseName,
              isChangeable: !isEditing,
            )
          : const NoCourseChosen(),
      dueDate:
          hasChangedTodoDate ? Date.fromDateTime(_homework.todoUntil) : null,
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
      isPrivate: (_homework.private, isChangeable: !_homework.withSubmissions),
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
