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
import 'package:group_domain_models/group_domain_models.dart';
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
  // TODO: Don't know if this is really what we need.
  final LocalFile? localFile;
  final CloudFile? cloudFile;

  const AttachmentRemoved({this.localFile, this.cloudFile});

  @override
  List<Object?> get props => [localFile, cloudFile];
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
  final DateTime? dueDate;
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

class NewHomeworkDialogBloc
    extends Bloc<HomeworkDialogEvent, HomeworkDialogState>
    with
        BlocPresentationMixin<HomeworkDialogState,
            HomeworkDialogBlocPresentationEvent> {
  final HomeworkDialogApi api;
  late HomeworkDto _initialHomework;
  late List<CloudFile> _initialAttachments;

  late HomeworkDto _homework;
  var _localFiles = IList<LocalFile>();

  NewHomeworkDialogBloc({required this.api, HomeworkId? homeworkId})
      : super(homeworkId != null
            ? LoadingHomework(homeworkId, isEditing: true)
            : emptyCreateHomeworkDialogState) {
    if (homeworkId != null) {
      _loadExistingData(homeworkId);
    }
    {
      _homework = HomeworkDto.create(courseID: '').copyWith(
        todoUntil: null,
      );
    }

    on<_LoadedHomeworkData>(
      (event, emit) {
        _homework = _initialHomework;

        emit(Ready(
          title: _initialHomework.title,
          course: CourseChosen(
            courseId: CourseId(_initialHomework.courseID),
            courseName: _initialHomework.courseName,
            isChangeable: false,
          ),
          dueDate: _initialHomework.todoUntil,
          submissions: _initialHomework.withSubmissions
              ? SubmissionsEnabled(
                  deadline: _initialHomework.todoUntil.toTime())
              : const SubmissionsDisabled(isChangeable: true),
          description: _initialHomework.description,
          attachments: IList([
            for (final attachment in _initialAttachments)
              FileView(
                fileId: FileId(attachment.id!),
                fileName: attachment.name,
                format: attachment.fileFormat,
                cloudFile: attachment,
              )
          ]),
          notifyCourseMembers: false,
          isPrivate: (
            _initialHomework.private,
            isChangeable: homeworkId == null
          ),
          hasModifiedData: false,
          isEditing: true,
        ));
      },
    );
    on<Submit>(
      (event, emit) async {
        await api.createHomework(
            CourseId(_homework.courseID),
            UserInput(
              title: _homework.title,
              todoUntil: _homework.todoUntil,
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
      },
    );
    on<DueDateChanged>(
      (event, emit) {
        _homework = _homework.copyWith(todoUntil: event.newDueDate.toDateTime);
      },
    );
    on<CourseChanged>(
      (event, emit) {
        _homework = _homework.copyWith(courseID: event.newCourseId.id);
      },
    );
    on<SubmissionsChanged>(
      (event, emit) {
        // TODO
      },
    );
    on<DescriptionChanged>(
      (event, emit) {
        _homework = _homework.copyWith(description: event.newDescription);
      },
    );
    on<AttachmentsAdded>(
      (event, emit) {
        _localFiles = _localFiles.addAll(event.newFiles);
      },
    );
    on<AttachmentRemoved>(
      (event, emit) {
        if (event.localFile != null) {
          _localFiles = _localFiles.remove(event.localFile!);
        }
      },
    );
    on<NotifyCourseMembersChanged>(
      (event, emit) {
        // TODO
      },
    );
    on<IsPrivateChanged>(
      (event, emit) {
        _homework = _homework.copyWith(private: event.newIsPrivate);
      },
    );
  }

  Future<void> _loadExistingData(HomeworkId homeworkId) async {
    _initialHomework = await api.loadHomework(homeworkId);
    _initialAttachments = await api.loadCloudFiles(
      homeworkId: _initialHomework.id,
    );
    add(_LoadedHomeworkData());
  }
}
