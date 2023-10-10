import 'package:bloc/bloc.dart';
import 'package:bloc_presentation/bloc_presentation.dart';
import 'package:common_domain_models/common_domain_models.dart';
import 'package:equatable/equatable.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:files_basics/files_models.dart';
import 'package:filesharing_logic/filesharing_logic_models.dart';
import 'package:firebase_hausaufgabenheft_logik/firebase_hausaufgabenheft_logik.dart';
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

sealed class HomeworkDialogState extends Equatable {
  final bool isEditing;
  @override
  List<Object?> get props => [isEditing];

  const HomeworkDialogState({required this.isEditing});
}

class Ready extends HomeworkDialogState {
  // TODO: Add error states (title, Due date?)
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

class FileView extends Equatable {
  final FileId fileId;
  final String fileName;
  final FileFormat format;

  @override
  List<Object?> get props => [fileId, fileName, format];

  const FileView(
      {required this.fileId, required this.fileName, required this.format});
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

final emptyDialog = Ready(
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

  NewHomeworkDialogBloc({required this.api, HomeworkId? homeworkId})
      : super(homeworkId != null
            ? LoadingHomework(homeworkId, isEditing: true)
            : emptyDialog) {
    on<_LoadedHomeworkData>(
      (event, emit) => emit(Ready(
        title: _initialHomework.title,
        course: CourseChosen(
          courseId: CourseId(_initialHomework.courseID),
          courseName: _initialHomework.courseName,
          isChangeable: false,
        ),
        dueDate: _initialHomework.todoUntil,
        submissions: const SubmissionsDisabled(isChangeable: true),
        description: _initialHomework.description,
        attachments: IList([
          for (final attachment in _initialAttachments)
            FileView(
              fileId: FileId(attachment.id!),
              fileName: attachment.name,
              format: attachment.fileFormat,
            )
        ]),
        notifyCourseMembers: false,
        isPrivate: (false, isChangeable: false),
        hasModifiedData: false,
        isEditing: true,
      )),
    );
    if (homeworkId != null) {
      _loadExistingData(homeworkId);
    }
  }

  Future<void> _loadExistingData(HomeworkId homeworkId) async {
    _initialHomework = await api.loadHomework(homeworkId);
    _initialAttachments = await api.loadCloudFiles(
      courseId: _initialHomework.courseID,
      homeworkId: _initialHomework.id,
    );
    add(_LoadedHomeworkData());
  }
}
