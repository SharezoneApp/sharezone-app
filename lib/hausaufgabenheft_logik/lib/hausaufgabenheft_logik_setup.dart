/// Die nötigen Klassen um einen [HomeworkPageBloc] zu erstellen.
/// Beispielcode:
/// ```dart
///     final config = HausaufgabenheftConfig(
///         defaultCourseColorValue: Colors.lightBlue.value,
///         nrOfInitialCompletedHomeworksToLoad: 8);
///     /// Die Klassen von firebase_hausaufgabenheft_logik, die die Logik an Firebase anbinden.
///     final dependencies = HausaufgabenheftDependencies(
///         firestoreHomeworkRepository,
///         _homeworkCompletionDispatcher,
///         firestoreHomeworkRepository.getCurrentOpenOverdueHomeworkIds);
///     final homeworkPageBloc = createHomeworkPageBloc(dependencies, config);
/// ```

export 'src/setup/config.dart';
export 'src/setup/dependencies.dart';
export 'src/setup/create_homework_page_bloc.dart';
export 'src/student_homework_page_bloc/student_homework_page_bloc.dart';
