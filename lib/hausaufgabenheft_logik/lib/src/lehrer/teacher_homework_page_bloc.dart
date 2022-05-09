// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:bloc_base/bloc_base.dart';
import 'package:common_domain_models/common_domain_models.dart';
import 'package:hausaufgabenheft_logik/color.dart';
import 'package:hausaufgabenheft_logik/hausaufgabenheft_logik_lehrer.dart';
import 'package:meta/meta.dart';
import 'package:random_string/random_string.dart';

export 'events.dart';
export 'states.dart';

class _Homeworks {
  static final _noSubmissionNoPermissions = randomHomeworkViewWith(
    title: 'S. 35 a)',
    colorDate: false,
    withSubmissions: false,
    canViewCompletionOrSubmissionList: false,
    canDeleteForEveryone: true,
    canEditForEveryone: true,
  );

  static final _noSubmissionWithPermissions = randomHomeworkViewWith(
    title: 'AB "Dichter"',
    withSubmissions: false,
    canViewCompletionOrSubmissionList: true,
    canDeleteForEveryone: false,
    canEditForEveryone: false,
  );

  static final _withSubmissionNoPermissions = randomHomeworkViewWith(
    title: 'AB "trigonometrie"',
    withSubmissions: true,
    canViewCompletionOrSubmissionList: false,
    canDeleteForEveryone: true,
    canEditForEveryone: false,
  );

  static final _withSubmissionWithPermissions = randomHomeworkViewWith(
    title: 'S. 23 b)',
    withSubmissions: true,
    canViewCompletionOrSubmissionList: true,
    canDeleteForEveryone: false,
    canEditForEveryone: true,
  );
}

enum _ArchivedHwLazyLoadingState {
  askedForFirstBatch,
  askedForSecondBatch,
  askedForAll
}

class _States {
  // ignore: unused_field
  static final _uninitialized = Uninitialized();

  // ignore: unused_field
  static final _placeholder = Success(
    TeacherOpenHomeworkListView([],
        sorting: HomeworkSort.smallestDateSubjectAndTitle),
    TeacherArchivedHomeworkListView([], loadedAllArchivedHomeworks: true),
  );

  /// Answer for [_ArchivedHwLazyLoadingState.askedForFirstBatch]
  static final __archivedHomeworksFirstState = TeacherArchivedHomeworkListView([
    _Homeworks._noSubmissionNoPermissions,
    _Homeworks._withSubmissionWithPermissions,
    ..._generateRandomHomeworks(count: 18)
  ], loadedAllArchivedHomeworks: false);

  /// Answer for [_ArchivedHwLazyLoadingState.askedForSecondBatch]
  static final __archivedHomeworksSecondState =
      TeacherArchivedHomeworkListView([
    ...__archivedHomeworksFirstState.orderedHomeworks,
    ..._generateRandomHomeworks(count: 10)
  ], loadedAllArchivedHomeworks: false);

  /// Answer for [_ArchivedHwLazyLoadingState.askedForAll]
  static final __archivedHomeworksLoadedAllState =
      TeacherArchivedHomeworkListView([
    ...__archivedHomeworksSecondState.orderedHomeworks,
    ..._generateRandomHomeworks(count: 10)
  ], loadedAllArchivedHomeworks: true);

  static TeacherArchivedHomeworkListView __getArchivedListView(
      _ArchivedHwLazyLoadingState _loadingState) {
    switch (_loadingState) {
      case _ArchivedHwLazyLoadingState.askedForFirstBatch:
        return __archivedHomeworksFirstState;
      case _ArchivedHwLazyLoadingState.askedForSecondBatch:
        return __archivedHomeworksSecondState;
      case _ArchivedHwLazyLoadingState.askedForAll:
        return __archivedHomeworksLoadedAllState;
    }
    throw UnimplementedError();
  }

  static Success _homeworksAllLoadedSortedBySubject(
      _ArchivedHwLazyLoadingState _loadingState) {
    return Success(
        TeacherOpenHomeworkListView([
          TeacherHomeworkSectionView('Mathe', [
            _Homeworks._noSubmissionWithPermissions,
            _Homeworks._withSubmissionNoPermissions
          ])
        ], sorting: HomeworkSort.subjectSmallestDateAndTitleSort),
        __getArchivedListView(_loadingState));
  }

  static Success _homeworksAllLoadedSortedByTodoDate(
      _ArchivedHwLazyLoadingState _loadingState) {
    return Success(
      TeacherOpenHomeworkListView([
        TeacherHomeworkSectionView('Heute', [
          _Homeworks._noSubmissionWithPermissions,
        ]),
        TeacherHomeworkSectionView('In 3 Tagen', [
          _Homeworks._withSubmissionNoPermissions,
        ])
      ], sorting: HomeworkSort.smallestDateSubjectAndTitle),
      __getArchivedListView(_loadingState),
    );
  }
}

List<TeacherHomeworkView> _generateRandomHomeworks({@required int count}) {
  return List.generate(
      count, (index) => randomHomeworkViewWith(/*Random content*/));
}

@visibleForTesting
TeacherHomeworkView randomHomeworkViewWith({
  String title,
  int nrOfStudentsCompletedOrSubmitted,
  bool withSubmissions,
  bool colorDate,
  bool canViewCompletionOrSubmissionList,
  bool canDeleteForEveryone,
  bool canEditForEveryone,
}) {
  bool _randomBool() {
    // 👈😎👉 SO SMART 👈😎👉
    return randomBetween(0, 2).isEven;
  }

  String randomDate() {
    final randomDay = randomBetween(0, 30);
    final randomMonthNr = randomBetween(0, 12);
    final randomMonth =
        randomMonthNr < 10 ? '0$randomMonthNr' : '$randomMonthNr';

    return '$randomDay.$randomMonth.2021';
  }

  final subject = _randomBool() ? 'Englisch' : 'Mathe';
  return TeacherHomeworkView(
    id: HomeworkId(randomAlphaNumeric(10)),
    title: title ?? 'S. ${randomBetween(1, 300)} Nr. ${randomBetween(1, 20)}',
    abbreviation: subject.substring(0, 1),
    colorDate: colorDate ?? _randomBool(),
    nrOfStudentsCompletedOrSubmitted:
        nrOfStudentsCompletedOrSubmitted ?? randomBetween(0, 30),
    subject: subject,
    subjectColor: Color.fromARGB(200, randomBetween(100, 200), 200, 255),
    todoDate: randomDate(),
    withSubmissions: withSubmissions ?? _randomBool(),
    canViewCompletionOrSubmissionList:
        canViewCompletionOrSubmissionList ?? _randomBool(),
    canDeleteForEveryone: canDeleteForEveryone ?? _randomBool(),
    canEditForEveryone: canEditForEveryone ?? _randomBool(),
  );
}

/// A fake bloc for the homework page for teachers.
///
/// Fake means that it really doesn't do much. It doesn't work yet.
/// The current implementation only makes it look as roughly how it should work
/// in the end. In reality only the fake homeworks above are returned.
///
/// It is currently only used for local development of the new teacher homework
/// UI. The real logic will be implemented in the future.
class TeacherHomeworkPageBloc
    extends Bloc<TeacherHomeworkPageEvent, TeacherHomeworkPageState>
    implements BlocBase {
  TeacherHomeworkPageBloc();

  @override
  TeacherHomeworkPageState get initialState => Uninitialized();

  HomeworkSort _currentSort = HomeworkSort.smallestDateSubjectAndTitle;
  _ArchivedHwLazyLoadingState _archivedHwLazyLoadingState =
      _ArchivedHwLazyLoadingState.askedForFirstBatch;

  @override
  Stream<TeacherHomeworkPageState> mapEventToState(
      TeacherHomeworkPageEvent event) async* {
    if (event is OpenHwSortingChanged) {
      _currentSort = event.sort;
    }
    if (event is AdvanceArchivedHomeworks) {
      _advanveArchivedHwLazyLoadingState();
      await Future.delayed(Duration(milliseconds: 1200));
    }
    if (event is LoadHomeworks) {
      // Reset so that we can inspect the lazy loading again when we change
      // away and back to the homework page again.
      _archivedHwLazyLoadingState =
          _ArchivedHwLazyLoadingState.askedForFirstBatch;
    }

    // Uncomment to see placeholder (as if the user has no homework)
    // yield _States._placeholder;

    yield _currentSort == HomeworkSort.smallestDateSubjectAndTitle
        ? _States._homeworksAllLoadedSortedByTodoDate(
            _archivedHwLazyLoadingState)
        : _States._homeworksAllLoadedSortedBySubject(
            _archivedHwLazyLoadingState);
  }

  void _advanveArchivedHwLazyLoadingState() {
    switch (_archivedHwLazyLoadingState) {
      case _ArchivedHwLazyLoadingState.askedForFirstBatch:
        _archivedHwLazyLoadingState =
            _ArchivedHwLazyLoadingState.askedForSecondBatch;
        break;
      case _ArchivedHwLazyLoadingState.askedForSecondBatch:
        _archivedHwLazyLoadingState = _ArchivedHwLazyLoadingState.askedForAll;
        break;
      case _ArchivedHwLazyLoadingState.askedForAll:
      default:
        return;
    }
  }

  @override
  void dispose() {}
}
