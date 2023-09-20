import 'dart:async';

import 'package:flutter/material.dart';
import 'package:group_domain_models/group_domain_models.dart';
import 'package:rxdart/rxdart.dart';
import 'package:sharezone/calendrical_events/models/calendrical_event.dart';
import 'package:sharezone/sharezone_plus/subscription_service/subscription_service.dart';
import 'package:sharezone/timetable/src/widgets/events/event_view.dart';
import 'package:sharezone/util/api/course_gateway.dart';
import 'package:sharezone/util/api/school_class_gateway.dart';
import 'package:sharezone/util/api/timetable_gateway.dart';

class PastCalendricalEventsPageController extends ChangeNotifier {
  late PastCalendricalEventsPageState state;
  EventsSortingOrder _sortingOrder = EventsSortingOrder.ascending;
  EventsSortingOrder get sortingOrder => _sortingOrder;

  StreamSubscription<List<EventView>>? _eventsSubscription;
  late StreamSubscription<bool> _hasUnlockedSubscription;
  late TimetableGateway _timetableGateway;
  late CourseGateway _courseGateway;
  late SchoolClassGateway _schoolClassGateway;

  /// The date until which events should be fetched.
  ///
  /// This is used to determine which events are past events and which are
  /// upcoming events.
  late DateTime _getEventsUntilDate;

  PastCalendricalEventsPageController({
    required DateTime now,
    required SubscriptionService subscriptionService,
    required TimetableGateway timetableGateway,
    required CourseGateway courseGateway,
    required SchoolClassGateway schoolClassGateway,
  }) {
    _getEventsUntilDate = now;
    _timetableGateway = timetableGateway;
    _courseGateway = courseGateway;
    _schoolClassGateway = schoolClassGateway;

    state = PastCalendricalEventsPageNotUnlockedState();
    _hasUnlockedSubscription = subscriptionService
        .hasFeatureUnlockedStream(SharezonePlusFeature.viewPastEvents)
        .listen((hasUnlocked) {
      // if (!hasUnlocked) {
      if (!hasUnlocked) {
        _listenToPastEvents();
      } else {
        state = PastCalendricalEventsPageNotUnlockedState();
        notifyListeners();
      }
    });
  }

  void _listenToPastEvents() {
    _eventsSubscription = CombineLatestStream([
      _timetableGateway.streamEventsBefore(
        _getEventsUntilDate,
        descending: sortingOrder == EventsSortingOrder.descending,
      ),
      _courseGateway.getGroupInfoStream(_schoolClassGateway)
    ], (streamValues) {
      final events = streamValues[0] as List<CalendricalEvent>? ?? [];
      final groupInfos = streamValues[1] as Map<String, GroupInfo>? ?? {};

      final eventViews = events
          .map((event) =>
              EventView.fromEventAndGroupInfo(event, groupInfos[event.groupID]))
          .toList();

      return eventViews;
    }).listen((events) {
      state = PastCalendricalEventsPageLoadedState(events);
      notifyListeners();
    })
      ..onError((error) {
        state = PastCalendricalEventsPageErrorState('$error');
        notifyListeners();
      });
  }

  set setSortOrder(EventsSortingOrder order) {
    _sortingOrder = order;
    _refresh();
  }

  void _refresh() {
    state = PastCalendricalEventsPageLoadingState();

    _eventsSubscription?.cancel();
    _eventsSubscription = null;

    notifyListeners();
    _listenToPastEvents();
  }

  @override
  void dispose() {
    _hasUnlockedSubscription.cancel();
    _eventsSubscription?.cancel();
    super.dispose();
  }
}

enum EventsSortingOrder {
  ascending,
  descending;
}

sealed class PastCalendricalEventsPageState {
  const PastCalendricalEventsPageState();
}

class PastCalendricalEventsPageNotUnlockedState
    extends PastCalendricalEventsPageState {}

class PastCalendricalEventsPageLoadingState
    extends PastCalendricalEventsPageState {}

class PastCalendricalEventsPageErrorState
    extends PastCalendricalEventsPageState {
  final String error;

  const PastCalendricalEventsPageErrorState(this.error);
}

class PastCalendricalEventsPageLoadedState
    extends PastCalendricalEventsPageState {
  final List<EventView> events;

  const PastCalendricalEventsPageLoadedState(this.events);
}
