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
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:hausaufgabenheft_logik/hausaufgabenheft_logik.dart';
import 'package:hausaufgabenheft_logik/src/completed_homeworks/views/completed_homework_list_view_factory.dart';
import 'package:hausaufgabenheft_logik/src/open_homeworks/sort_and_subcategorization/sort/src/homework_sort_enum_sort_object_conversion_extensions.dart';
import 'package:hausaufgabenheft_logik/src/open_homeworks/views/open_homework_list_view_factory.dart';
import 'package:hausaufgabenheft_logik/src/student_homework_page_bloc/homework_sorting_cache.dart';
import 'package:rxdart/rxdart.dart';

class HomeworkPageBloc extends Bloc<HomeworkPageEvent, HomeworkPageState>
    implements bloc_base.BlocBase {
  final StudentHomeworkPageApi _homeworkApi;
  final HomeworkSortingCache _homeworkSortingCache;
  final DateTime Function() _getCurrentDateTime;
  final int numberOfInitialCompletedHomeworksToLoad;
  final CompletedHomeworkListViewFactory _completedHomeworkListViewFactory;
  final OpenHomeworkListViewFactory _openHomeworkListViewFactory;
  final _currentSortStream = BehaviorSubject<Sort<StudentHomeworkReadModel>>();
  LazyLoadingController<StudentHomeworkReadModel>? _lazyLoadingController;

  /// Whether [close] or [dispose] has been called;
  bool _isClosed = false;

  HomeworkPageBloc({
    required HomeworkSortingCache homeworkSortingCache,
    required StudentHomeworkPageApi homeworkApi,
    required CompletedHomeworkListViewFactory completedHomeworkListViewFactory,
    required OpenHomeworkListViewFactory openHomeworkListViewFactory,
    required this.numberOfInitialCompletedHomeworksToLoad,
    required DateTime Function() getCurrentDateTime,
  })  : _homeworkApi = homeworkApi,
        _openHomeworkListViewFactory = openHomeworkListViewFactory,
        _homeworkSortingCache = homeworkSortingCache,
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
    final sortEnum = await _homeworkSortingCache.getLastSorting() ??
        HomeworkSort.smallestDateSubjectAndTitle;
    _currentSortStream
        .add(sortEnum.toSortObject(getCurrentDate: _getCurrentDate));

    _lazyLoadingController =
        _homeworkApi.getLazyLoadingCompletedHomeworksController(
            numberOfInitialCompletedHomeworksToLoad);

    _combineLatestSubscription = Rx.combineLatest3<
            IList<StudentHomeworkReadModel>,
            Sort<StudentHomeworkReadModel>,
            LazyLoadingResult<StudentHomeworkReadModel>,
            Success>(_homeworkApi.openHomeworks, _currentSortStream,
        _lazyLoadingController!.results, (openHws, sort, lazyCompletedHwsRes) {
      final open = _openHomeworkListViewFactory.create(openHws, sort);

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
    _currentSortStream
        .add(event.sort.toSortObject(getCurrentDate: _getCurrentDate));
  }

  Future<void> _mapHomeworkChangedCompletionStatus(
      CompletionStatusChanged event) async {
    await _homeworkApi.completeHomework(
        HomeworkId(event.homeworkId),
        event.newValue == true
            ? CompletionStatus.completed
            : CompletionStatus.open);
  }

  Future<void> _mapHomeworkMarkOverdueToState(CompletedAllOverdue event) async {
    final hws = await _homeworkApi.getOpenOverdueHomeworkIds();
    for (final hw in hws) {
      _homeworkApi.completeHomework(hw, CompletionStatus.completed);
    }
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
class _Yield extends HomeworkPageEvent {
  final Success success;

  _Yield(this.success);

  @override
  List<Object> get props => [success];
}
