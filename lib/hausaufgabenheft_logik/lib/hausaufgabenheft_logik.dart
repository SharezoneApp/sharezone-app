// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

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
///    log("success!");
///    log("completed homeworks: ${state.completed}")
///  } else if (state is Loading) {
///    log("loading!");
///  }
/// });
/// ```
///
/// Ein Bloc kann über hausaufgabenheft_logik_setup erstellt werden.
///
library hausaufgabenheft_logik;

export 'src/firebase/firebase_hausaufgabenheft_logik.dart';
export 'src/shared/homework_list_extensions.dart';
export 'src/shared/homework_page_api.dart';
export 'src/shared/models/homework.dart';
export 'src/shared/models/models.dart';
export 'src/shared/homework_section_view.dart';
export 'src/student/views/student_homework_section_view.dart';
export 'src/student/views/student_open_homework_list_view.dart';
export 'src/shared/lazy_loading_homework_list_view.dart';
export 'src/shared/sort/sorts.dart';
export 'src/student/student_homework_list_extensions.dart';
export 'src/student/bloc/events.dart';
export 'src/student/bloc/states.dart';
export 'src/student/bloc/student_homework_page_bloc.dart';
export 'src/student/views/student_homework_view.dart';
