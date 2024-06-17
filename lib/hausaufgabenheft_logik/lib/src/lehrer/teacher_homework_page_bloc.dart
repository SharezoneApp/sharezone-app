// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:bloc_base/bloc_base.dart' as bloc_base;
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:hausaufgabenheft_logik/hausaufgabenheft_logik.dart'
    hide Uninitialized, LoadHomeworks, OpenHwSortingChanged, Success, Sort;
import 'package:hausaufgabenheft_logik/hausaufgabenheft_logik_lehrer.dart';
import 'package:hausaufgabenheft_logik/src/student_homework_page_bloc/homework_sorting_cache.dart';
import 'package:rxdart/rxdart.dart';

import 'completed_homeworks/views/completed_homework_list_view_factory.dart';

export 'events.dart';
export 'states.dart';

class TeacherHomeworkPageBloc
    extends Bloc<TeacherHomeworkPageEvent, TeacherHomeworkPageState>
    implements bloc_base.BlocBase {
  final HomeworkDataSource<TeacherHomeworkReadModel> _homeworkDataSource;
  final HomeworkSortingCache _homeworkSortingCache;
  final DateTime Function() _getCurrentDateTime;
  final int numberOfInitialCompletedHomeworksToLoad;
  final TeacherCompletedHomeworkListViewFactory
      _completedHomeworkListViewFactory;
  final TeacherOpenHomeworkListViewFactory _openHomeworkListViewFactory;
  final _currentSortStream = BehaviorSubject<Sort<TeacherHomeworkReadModel>>();
  LazyLoadingController<TeacherHomeworkReadModel>? _lazyLoadingController;

  /// Whether [close] or [dispose] has been called;
  bool _isClosed = false;

  TeacherHomeworkPageBloc({
    required HomeworkSortingCache homeworkSortingCache,
    required HomeworkDataSource<TeacherHomeworkReadModel> homeworkDataSource,
    required TeacherCompletedHomeworkListViewFactory
        completedHomeworkListViewFactory,
    required TeacherOpenHomeworkListViewFactory openHomeworkListViewFactory,
    required this.numberOfInitialCompletedHomeworksToLoad,
    required DateTime Function() getCurrentDateTime,
  })  : _homeworkDataSource = homeworkDataSource,
        _openHomeworkListViewFactory = openHomeworkListViewFactory,
        _homeworkSortingCache = homeworkSortingCache,
        _completedHomeworkListViewFactory = completedHomeworkListViewFactory,
        _getCurrentDateTime = getCurrentDateTime,
        super(Uninitialized()) {
    on<LoadHomeworks>((event, emit) {
      _mapLoadHomeworksToState();
    });
    on<AdvanceArchivedHomeworks>((event, emit) {
      _mapAdvanceArchivedHomeworks(event);
    });
    on<OpenHwSortingChanged>((event, emit) {
      _mapFilterChangedToState(event);
    });
    on<_Yield>((event, emit) {
      emit(event.success);
    });
  }

  Date _getCurrentDate() {
    return Date.fromDateTime(_getCurrentDateTime());
  }

  StreamSubscription? _combineLatestSubscription;
  Future<void> _mapLoadHomeworksToState() async {
    final sortEnum = await _homeworkSortingCache.getLastSorting() ??
        HomeworkSort.smallestDateSubjectAndTitle;
    _currentSortStream
        .add(sortEnum.toSortObject(getCurrentDate: _getCurrentDate));

    _lazyLoadingController =
        _homeworkDataSource.getLazyLoadingCompletedHomeworksController(
            numberOfInitialCompletedHomeworksToLoad);

    _combineLatestSubscription = Rx.combineLatest3<
            IList<TeacherHomeworkReadModel>,
            Sort<TeacherHomeworkReadModel>,
            LazyLoadingResult<TeacherHomeworkReadModel>,
            Success>(_homeworkDataSource.openHomeworks, _currentSortStream,
        _lazyLoadingController!.results, (openHws, sort, lazyCompletedHwsRes) {
      final open = _openHomeworkListViewFactory.create(openHws, sort);

      final archived = _completedHomeworkListViewFactory.create(
          lazyCompletedHwsRes.homeworks,
          !lazyCompletedHwsRes.moreHomeworkAvailable);

      return Success(open, archived);
    }).listen((s) {
      if (!_isClosed) {
        add(_Yield(s));
      }
    });
  }

  void _mapAdvanceArchivedHomeworks(AdvanceArchivedHomeworks event) async {
    _lazyLoadingController!.advanceBy(event.advanceBy);
  }

  Future<void> _mapFilterChangedToState(OpenHwSortingChanged event) async {
    await _homeworkSortingCache.setLastSorting(event.sort);
    _currentSortStream
        .add(event.sort.toSortObject(getCurrentDate: _getCurrentDate));
  }

  @override
  Future<void> close() {
    _isClosed = true;
    _currentSortStream.close();
    _combineLatestSubscription?.cancel();
    return super.close();
  }

  @override
  void dispose() {
    _isClosed = true;
    _currentSortStream.close();
    _combineLatestSubscription?.cancel();
  }
}

/// As you can't yield in a listen callback of a stream
/// and you can't return the stream as this stops the
/// bloc from working (as the Stream never finishes)
/// this acts a as a simple wrapper to yield the
/// given value
class _Yield extends TeacherHomeworkPageEvent {
  final Success success;

  _Yield(this.success);

  @override
  List<Object> get props => [success];
}
