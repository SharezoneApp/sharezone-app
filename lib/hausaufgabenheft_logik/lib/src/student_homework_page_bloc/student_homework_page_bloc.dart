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
import 'package:common_domain_models/common_domain_models.dart';
import 'package:hausaufgabenheft_logik/hausaufgabenheft_logik.dart';
import 'package:hausaufgabenheft_logik/src/completed_homeworks/views/completed_homework_list_view_factory.dart';
import 'package:hausaufgabenheft_logik/src/homework_completion/homework_page_completion_dispatcher.dart';
import 'package:hausaufgabenheft_logik/src/open_homeworks/sort_and_subcategorization/sort/src/homework_sort_enum_sort_object_conversion_extensions.dart';
import 'package:hausaufgabenheft_logik/src/open_homeworks/views/open_homework_list_view_factory.dart';
import 'package:hausaufgabenheft_logik/src/student_homework_page_bloc/homework_sorting_cache.dart';
import 'package:rxdart/rxdart.dart';

/// This Bloc serves basically only as an interface to the outer world with 2
/// tasks:
/// * It delegates all incoming [HomeworkPageEvent]s to the other blocs.
/// * It merges the Success states from the [OpenHomeworksViewBloc] and
///   [CompletedHomeworksViewBloc] together into one [Success] state.
/// * It caches the last sorting of Homeworks so that it stays consistent
///   between visits of the homework page.
class HomeworkPageBloc extends Bloc<HomeworkPageEvent, HomeworkPageState>
    implements bloc_base.BlocBase {
  final HomeworkPageCompletionDispatcher _homeworkCompletionReceiver;
  final HomeworkDataSource _homeworkDataSource;
  final HomeworkSortingCache _homeworkSortingCache;
  final DateTime Function() _getCurrentDateTime;
  final int numberOfInitialCompletedHomeworksToLoad;
  final CompletedHomeworkListViewFactory _completedHomeworkListViewFactory;
  final OpenHomeworkListViewFactory _openHomeworkListViewFactory;
  final sortingStream = BehaviorSubject<HomeworkSort>();
  LazyLoadingController? _lazyLoadingController;

  /// Whether [close] or [dispose] has been called;
  bool _isClosed = false;

  HomeworkPageBloc({
    required HomeworkPageCompletionDispatcher homeworkCompletionReceiver,
    required HomeworkSortingCache homeworkSortingCache,
    required HomeworkDataSource homeworkDataSource,
    required CompletedHomeworkListViewFactory completedHomeworkListViewFactory,
    required OpenHomeworkListViewFactory openHomeworkListViewFactory,
    required this.numberOfInitialCompletedHomeworksToLoad,
    required DateTime Function() getCurrentDateTime,
  })  : _homeworkDataSource = homeworkDataSource,
        _openHomeworkListViewFactory = openHomeworkListViewFactory,
        _homeworkSortingCache = homeworkSortingCache,
        _homeworkCompletionReceiver = homeworkCompletionReceiver,
        _completedHomeworkListViewFactory = completedHomeworkListViewFactory,
        _getCurrentDateTime = getCurrentDateTime,
        super(Uninitialized()) {
    on<LoadHomeworks>((event, emit) {
      _mapLoadHomeworksToState();
    });
    on<AdvanceCompletedHomeworks>((event, emit) {
      _mapAdvanceCompletedHomeworks(event);
    });
    on<OpenHwSortingChanged>((event, emit) {
      _mapFilterChangedToState(event);
    });
    on<CompletionStatusChanged>((event, emit) {
      _mapHomeworkChangedCompletionStatus(event);
    });
    on<CompletedAllOverdue>((event, emit) {
      _mapHomeworkMarkOverdueToState(event);
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
    _lazyLoadingController =
        _homeworkDataSource.getLazyLoadingCompletedHomeworksController(
            numberOfInitialCompletedHomeworksToLoad);

    final sortEnum = (await _homeworkSortingCache.getLastSorting(
        orElse: HomeworkSort.smallestDateSubjectAndTitle))!;
    sortingStream.add(sortEnum);

    _combineLatestSubscription = Rx.combineLatest3<List<HomeworkReadModel>,
            HomeworkSort, LazyLoadingResult, Success>(
        _homeworkDataSource.openHomeworks,
        sortingStream,
        _lazyLoadingController!.results, (openHws, sort, lazyCompletedHwsRes) {
      final sortObj = sort.toSortObject(getCurrentDate: _getCurrentDate);
      final open = _openHomeworkListViewFactory.create(openHws, sortObj);

      final completed = _completedHomeworkListViewFactory.create(
          lazyCompletedHwsRes.homeworks,
          !lazyCompletedHwsRes.moreHomeworkAvailable);

      return Success(completed, open);
    }).listen((s) {
      if (!_isClosed) {
        add(_Yield(s));
      }
    });
  }

  void _mapAdvanceCompletedHomeworks(AdvanceCompletedHomeworks event) async {
    _lazyLoadingController!.advanceBy(event.advanceBy);
  }

  Future<void> _mapFilterChangedToState(OpenHwSortingChanged event) async {
    await _homeworkSortingCache.setLastSorting(event.sort);
    sortingStream.add(event.sort);
  }

  Future<void> _mapHomeworkChangedCompletionStatus(
      CompletionStatusChanged event) async {
    await _homeworkCompletionReceiver.changeCompletionStatus(
        HomeworkId(event.homeworkId),
        event.newValue == true
            ? CompletionStatus.completed
            : CompletionStatus.open);
  }

  Future<void> _mapHomeworkMarkOverdueToState(CompletedAllOverdue event) async {
    await _homeworkCompletionReceiver.completeAllOverdueHomeworks();
  }

  @override
  Future<void> close() {
    _isClosed = true;
    sortingStream.close();
    _combineLatestSubscription?.cancel();
    return super.close();
  }

  @override
  void dispose() {
    _isClosed = true;
    sortingStream.close();
    _combineLatestSubscription?.cancel();
  }
}

/// As you can't yield in a listen callback of a stream
/// and you can't return the stream as this stops the
/// bloc from working (as the Stream never finishes)
/// this acts a as a simple wrapper to yield the
/// given value
class _Yield extends HomeworkPageEvent {
  final Success success;

  _Yield(this.success);

  @override
  List<Object> get props => [success];
}
