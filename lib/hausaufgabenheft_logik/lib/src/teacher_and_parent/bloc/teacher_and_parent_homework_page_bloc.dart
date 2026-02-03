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
import 'package:hausaufgabenheft_logik/hausaufgabenheft_logik.dart'
    hide Uninitialized, LoadHomeworks, OpenHwSortingChanged, Success, Sort;
import 'package:hausaufgabenheft_logik/hausaufgabenheft_logik_lehrer.dart';
import 'package:hausaufgabenheft_logik/src/shared/homework_sorting_cache.dart';
import 'package:rxdart/rxdart.dart';

export 'events.dart';
export 'states.dart';

class TeacherAndParentHomeworkPageBloc
    extends
        Bloc<
          TeacherAndParentHomeworkPageEvent,
          TeacherAndParentHomeworkPageState
        >
    implements bloc_base.BlocBase {
  final TeacherAndParentHomeworkPageApi _homeworkApi;
  final HomeworkSortingCache _homeworkSortingCache;
  final DateTime Function() _getCurrentDateTime;
  final int numberOfInitialCompletedHomeworksToLoad;
  final TeacherAndParentHomeworkViewFactory _viewFactory;
  final TeacherAndParentOpenHomeworkListViewFactory
  _openHomeworkListViewFactory;
  final Stream<ISet<CourseId>> _courseFilterStream;
  final _currentSortStream = BehaviorSubject<Sort<BaseHomeworkReadModel>>();
  LazyLoadingController<TeacherHomeworkReadModel>? _lazyLoadingController;

  /// Whether [close] or [dispose] has been called;
  bool _isClosed = false;

  TeacherAndParentHomeworkPageBloc({
    required HomeworkSortingCache homeworkSortingCache,
    required TeacherAndParentHomeworkPageApi homeworkApi,
    required TeacherAndParentHomeworkViewFactory viewFactory,
    required TeacherAndParentOpenHomeworkListViewFactory
    openHomeworkListViewFactory,
    required this.numberOfInitialCompletedHomeworksToLoad,
    required DateTime Function() getCurrentDateTime,
    Stream<ISet<CourseId>>? courseFilterStream,
  }) : _homeworkApi = homeworkApi,
       _openHomeworkListViewFactory = openHomeworkListViewFactory,
       _homeworkSortingCache = homeworkSortingCache,
       _viewFactory = viewFactory,
       _getCurrentDateTime = getCurrentDateTime,
       _courseFilterStream =
           (courseFilterStream ?? Stream.value(ISet<CourseId>())).startWith(
             ISet<CourseId>(),
           ),
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
    final sortEnum =
        await _homeworkSortingCache.getLastSorting() ??
        HomeworkSort.smallestDateSubjectAndTitle;
    _currentSortStream.add(
      sortEnum.toSortObject(getCurrentDate: _getCurrentDate),
    );

    _lazyLoadingController = _homeworkApi
        .getLazyLoadingArchivedHomeworksController(
          numberOfInitialCompletedHomeworksToLoad,
        );

    _combineLatestSubscription = Rx.combineLatest4<
      IList<TeacherHomeworkReadModel>,
      Sort<BaseHomeworkReadModel>,
      LazyLoadingResult<TeacherHomeworkReadModel>,
      ISet<CourseId>,
      Success
    >(
      _homeworkApi.openHomeworks,
      _currentSortStream,
      _lazyLoadingController!.results,
      _courseFilterStream,
      (openHws, sort, lazyCompletedHwsRes, courseFilter) {
        final filteredOpen = _filterByCourse(openHws, courseFilter);
        final filteredArchived = _filterByCourse(
          lazyCompletedHwsRes.homeworks,
          courseFilter,
        );
        final open = _openHomeworkListViewFactory.create(filteredOpen, sort);

        final archived = LazyLoadingHomeworkListView(
          filteredArchived.map(_viewFactory.createFrom).toIList(),
          loadedAllHomeworks: !lazyCompletedHwsRes.moreHomeworkAvailable,
        );

        return Success(open, archived);
      },
    ).listen((s) {
      if (!_isClosed) {
        add(_Yield(s));
      }
    });
  }

  IList<T> _filterByCourse<T extends BaseHomeworkReadModel>(
    IList<T> homeworks,
    ISet<CourseId> courseFilter,
  ) {
    if (courseFilter.isEmpty) {
      return homeworks;
    }
    return homeworks
        .where((homework) => courseFilter.contains(homework.courseId))
        .toIList();
  }

  void _mapAdvanceArchivedHomeworks(AdvanceArchivedHomeworks event) async {
    _lazyLoadingController!.advanceBy(event.advanceBy);
  }

  Future<void> _mapFilterChangedToState(OpenHwSortingChanged event) async {
    await _homeworkSortingCache.setLastSorting(event.sort);
    _currentSortStream.add(
      event.sort.toSortObject(getCurrentDate: _getCurrentDate),
    );
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
class _Yield extends TeacherAndParentHomeworkPageEvent {
  final Success success;

  _Yield(this.success);

  @override
  List<Object> get props => [success];
}
