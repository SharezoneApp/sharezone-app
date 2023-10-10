import 'package:bloc/bloc.dart';
import 'package:common_domain_models/common_domain_models.dart';
import 'package:equatable/equatable.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:files_basics/files_models.dart';
import 'package:filesharing_logic/filesharing_logic_models.dart';
import 'package:firebase_hausaufgabenheft_logik/firebase_hausaufgabenheft_logik.dart';
import 'package:sharezone/blocs/homework/homework_dialog_bloc.dart';
import 'package:time/time.dart';

sealed class HomeworkDialogEvent extends Equatable {}

sealed class HomeworkDialogState extends Equatable {
  const HomeworkDialogState();
}

class Ready extends HomeworkDialogState {
  final String title;
  final CourseState course;
  final DateTime? dueDate;
  final SubmissionState submissions;
  final String description;
  final IList<FileView> attachments;
  final bool notifyCourseMembers;
  final (bool, {bool isChangeable}) isPrivate;

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
  const SubmissionState();
}

class SubmissionsDisabled extends SubmissionState {
  /// If the user can update the [SubmissionState], i.e. turn on submissions.
  ///
  /// If a homework is private submissions can not be turned on. This field
  /// would be `true` in this case.
  final bool isChangeable;
  @override
  List<Object?> get props => [isChangeable];

  const SubmissionsDisabled({required this.isChangeable});
}

class SubmissionsEnabled extends SubmissionState {
  final Time deadline;
  @override
  List<Object?> get props => [deadline];

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
  List<Object?> get props => [homework];

  const LoadingHomework(this.homework);
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
);

class _LoadedHomeworkData extends HomeworkDialogEvent {
  @override
  List<Object?> get props => [];
}

class NewHomeworkDialogBloc
    extends Bloc<HomeworkDialogEvent, HomeworkDialogState> {
  final HomeworkDialogApi api;
  late HomeworkDto _initialHomework;
  late List<CloudFile> _initialAttachments;

  NewHomeworkDialogBloc({required this.api, HomeworkId? homeworkId})
      : super(homeworkId != null ? LoadingHomework(homeworkId) : emptyDialog) {
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
