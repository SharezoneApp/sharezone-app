import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:bloc_base/bloc_base.dart';
import 'package:hausaufgabenheft_logik/hausaufgabenheft_logik.dart';
import 'package:hausaufgabenheft_logik/src/student_homework_page_bloc/homework_sorting_cache.dart';
import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';
import 'package:hausaufgabenheft_logik/src/open_homeworks/sort_and_subcategorization/sort/src/homework_sort_enum_sort_object_conversion_extensions.dart';
import 'package:hausaufgabenheft_logik/src/completed_homeworks/completed_homeworks_view_bloc/completed_homeworks_view_bloc.dart';
import 'package:hausaufgabenheft_logik/src/completed_homeworks/completed_homeworks_view_bloc/events.dart'
    as completed;
import 'package:hausaufgabenheft_logik/src/completed_homeworks/completed_homeworks_view_bloc/states.dart'
    as completed;
import 'package:hausaufgabenheft_logik/src/homework_completion/homework_page_completion_dispatcher.dart';
import 'package:hausaufgabenheft_logik/src/open_homeworks/open_homework_view_bloc/events.dart'
    as open;
import 'package:hausaufgabenheft_logik/src/open_homeworks/open_homework_view_bloc/open_homework_view_bloc.dart';
import 'package:hausaufgabenheft_logik/src/open_homeworks/open_homework_view_bloc/states.dart'
    as open;

import 'events.dart';
import 'states.dart';

/// This Bloc serves basically only as an interface to the outer world with 2
/// tasks:
/// * It delegates all incomming [HomeworkPageEvent]s to the other blocs.
/// * It merges the Success states from the [OpenHomeworksViewBloc] and
///   [CompletedHomeworksViewBloc] together into one [Success] state.
/// * It caches the last sorting of Homeworks so that it stays consistent
///   between visits of the homework page.
class HomeworkPageBloc extends Bloc<HomeworkPageEvent, HomeworkPageState>
    implements BlocBase {
  final OpenHomeworksViewBloc _openHomeworksViewBloc;
  final CompletedHomeworksViewBloc _completedHomeworksViewBloc;
  final HomeworkPageCompletionDispatcher _homeworkCompletionReceiver;
  final HomeworkSortingCache _homeworkSortingCache;
  final DateTime Function() _getCurrentDateTime;

  /// Whether [close] or [dispose] has been called;
  bool _isClosed = false;

  HomeworkPageBloc({
    @required OpenHomeworksViewBloc openHomeworksViewBloc,
    @required CompletedHomeworksViewBloc completedHomeworksViewBloc,
    @required HomeworkPageCompletionDispatcher homeworkCompletionReceiver,
    @required HomeworkSortingCache homeworkSortingCache,
    @required DateTime Function() getCurrentDateTime,
  })  : _openHomeworksViewBloc = openHomeworksViewBloc,
        _completedHomeworksViewBloc = completedHomeworksViewBloc,
        _homeworkSortingCache = homeworkSortingCache,
        _homeworkCompletionReceiver = homeworkCompletionReceiver,
        _getCurrentDateTime = getCurrentDateTime;

  Date _getCurrentDate() {
    return Date.fromDateTime(_getCurrentDateTime());
  }

  @override
  HomeworkPageState get initialState => Uninitialized();

  @override
  Stream<HomeworkPageState> mapEventToState(HomeworkPageEvent event) async* {
    if (event is LoadHomeworks) {
      yield* _mapLoadHomeworksToState();
    } else if (event is AdvanceCompletedHomeworks) {
      yield* _mapAdvanceCompletedHomeworks(event);
    } else if (event is OpenHwSortingChanged) {
      yield* _mapFilterChangedToState(event);
    } else if (event is CompletionStatusChanged) {
      yield* _mapHomeworkChangedCompletionStatus(event);
    } else if (event is CompletedAllOverdue) {
      yield* _mapHomeworkMarkOverdueToState(event);
    } else if (event is _Yield) {
      yield event.success;
    } else {
      throw UnimplementedError('$event is not implemented.');
    }
  }

  StreamSubscription _combineLatestSubscription;
  Stream<HomeworkPageState> _mapLoadHomeworksToState() async* {
    _completedHomeworksViewBloc.add(completed.StartTransformingHomeworks());

    final sortEnum = await _homeworkSortingCache.getLastSorting(
        orElse: HomeworkSort.smallestDateSubjectAndTitle);
    final sort = sortEnum.toSortObject();
    _openHomeworksViewBloc.add(open.LoadHomeworks(sort));

    final completedHomeworksSuccessStates =
        _completedHomeworksViewBloc.whereType<completed.Success>();

    final openHomeworksSuccessStates =
        _openHomeworksViewBloc.whereType<open.Success>();

    _combineLatestSubscription =
        Rx.combineLatest2<completed.Success, open.Success, Success>(
      completedHomeworksSuccessStates,
      openHomeworksSuccessStates,
      _toSuccessState,
    ).listen((s) {
      if (!_isClosed) {
        add(_Yield(s));
      }
    });
  }

  Success _toSuccessState(completed.Success completed, open.Success open) =>
      Success(completed.completedHomeworksView, open.openHomeworkListView);

  Stream<HomeworkPageState> _mapAdvanceCompletedHomeworks(
      AdvanceCompletedHomeworks event) async* {
    _completedHomeworksViewBloc
        .add(completed.AdvanceCompletedHomeworks(event.advanceBy));
  }

  Stream<HomeworkPageState> _mapFilterChangedToState(
      OpenHwSortingChanged event) async* {
    await _homeworkSortingCache.setLastSorting(event.sort);
    final newSorting = event.sort.toSortObject(getCurrentDate: _getCurrentDate);
    _openHomeworksViewBloc.add(open.SortingChanged(newSorting));
  }

  Stream<HomeworkPageState> _mapHomeworkChangedCompletionStatus(
      CompletionStatusChanged event) async* {
    await _homeworkCompletionReceiver
        .add(SingleHomeworkCompletionEvent(event.homeworkId, event.newValue));
  }

  Stream<HomeworkPageState> _mapHomeworkMarkOverdueToState(
      CompletedAllOverdue event) async* {
    await _homeworkCompletionReceiver.add(AllOverdueHomeworkCompletionEvent());
  }

  @override
  Future<void> close() {
    _isClosed = true;
    _combineLatestSubscription?.cancel();
    return super.close();
  }

  @override
  void dispose() {
    _isClosed = true;
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
