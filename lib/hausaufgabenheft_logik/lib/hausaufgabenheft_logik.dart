/// Die Logik für das Laden und Anzeigen der Hausaufgaben im Kontext des
/// Hausaufgabenhefts.
///
/// Hausaufgaben sind in dem Package von dem Rest der Infrastruktur getrennt,
/// wie z.B. Speicherort und -Art der letztendlichen Hausaufgabe.
///
/// Hier ist alles nur auf den Benutzer und auf die persönliche Informationen
/// der zugehörigen Hausaufgaben zugeschnitten. Das heißt, dass hier eine
/// Hausaufgabe nur einen simplen "gemacht" Status hat, der nur auf den einzelnen
/// Nutzer zugeschnitten ist, unabhängig von der letztendlichen
/// Speichertart/-struktur in der Datenbank.
///
/// Benutzt wird das Package durch den [HomeworkPageBloc]. Dieser konsumiert
/// [HomeworkPageEvent]s und gibt [HomeworkPageState]s aus.
///
/// Beispiel:
/// ```dart
/// homeworkPageBloc.dispatch(LoadHomeworks())
/// homeworkPageBloc.dispatch(SortHomeworks(SubjectSmallestDateAndTitleSort()))
/// homeworkPageBloc.state.listen((state) {
///  if(state is Success) {
///    print("success!");
///    print("completed homeworks: ${state.completed}")
///  } else if (state is Loading) {
///    print("loading!");
///  }
/// });
/// ```
///
/// Ein Bloc kann über hausaufgabenheft_logik_setup erstellt werden.
///
library hausaufgabenheft_logik;

export 'src/student_homework_page_bloc/events.dart';
export 'src/student_homework_page_bloc/student_homework_page_bloc.dart';
export 'src/student_homework_page_bloc/states.dart';
export 'src/models/homework/homework.dart';
export 'src/models/homework/models_used_by_homework.dart';
export 'src/open_homeworks/sort_and_subcategorization/sort/smallest_date_subject_and_title_sort.dart';
export 'src/open_homeworks/sort_and_subcategorization/sort/src/sort.dart';
export 'src/open_homeworks/sort_and_subcategorization/sort/subject_smallest_date_and_title_sort.dart';
export 'src/completed_homeworks/views/completed_homwork_list_view.dart';
export 'src/open_homeworks/views/open_homework_list_view.dart';
export 'src/open_homeworks/sort_and_subcategorization/sort_and_subcategorizer.dart';
export 'src/views/homework_view.dart';
export 'src/open_homeworks/views/homework_section_view.dart';
export 'src/data_source/homework_data_source.dart';
export 'src/homework_completion/homework_completion_dispatcher.dart';
