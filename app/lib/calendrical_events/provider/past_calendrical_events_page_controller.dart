// Copyright (c) 2023 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'dart:async';

import 'package:date/date.dart';
import 'package:flutter/material.dart';
import 'package:group_domain_models/group_domain_models.dart';
import 'package:rxdart/rxdart.dart';
import 'package:sharezone/calendrical_events/analytics/past_calendrical_events_page_analytics.dart';
import 'package:sharezone/calendrical_events/models/calendrical_event.dart';
import 'package:sharezone/sharezone_plus/subscription_service/subscription_service.dart';
import 'package:sharezone/timetable/src/widgets/events/event_view.dart';
import 'package:sharezone/util/api/course_gateway.dart';
import 'package:sharezone/util/api/school_class_gateway.dart';
import 'package:sharezone/util/api/timetable_gateway.dart';

class PastCalendricalEventsPageController extends ChangeNotifier {
  late PastCalendricalEventsPageState state;
  EventsSortingOrder _sortingOrder = EventsSortingOrder.descending;
  EventsSortingOrder get sortingOrder => _sortingOrder;

  StreamSubscription<List<EventView>>? _eventsSubscription;
  final TimetableGateway timetableGateway;
  final CourseGateway courseGateway;
  final SchoolClassGateway schoolClassGateway;
  final PastCalendricalEventsPageAnalytics analytics;

  /// The date until which events should be fetched.
  ///
  /// This is used to determine which events are past events and which are
  /// upcoming events.
  late DateTime _getEventsUntilDateTime;

  PastCalendricalEventsPageController({
    required DateTime now,
    required SubscriptionService subscriptionService,
    required this.timetableGateway,
    required this.courseGateway,
    required this.schoolClassGateway,
    required this.analytics,
  }) {
    _getEventsUntilDateTime = now;

    state = PastCalendricalEventsPageLoadingState();
    final hasUnlocked = subscriptionService
        .hasFeatureUnlocked(SharezonePlusFeature.viewPastEvents);
    if (hasUnlocked) {
      _listenToPastEvents();
    } else {
      state = PastCalendricalEventsPageNotUnlockedState();
      notifyListeners();
    }
  }

  void _listenToPastEvents() {
    try {
      _eventsSubscription = CombineLatestStream([
        timetableGateway.streamEventsBeforeOrOn(
          Date.fromDateTime(_getEventsUntilDateTime),
          descending: sortingOrder == EventsSortingOrder.descending,
        ),
        courseGateway.getGroupInfoStream(schoolClassGateway)
      ], (streamValues) {
        final events = streamValues[0] as List<CalendricalEvent>? ?? [];

        // Because we can only query by the date and not by the date and time, we
        // need to filter out events that are not past events, i.e. events that
        // are on the same day as the current date.
        final pastEvents = events
            .where(
                (event) => event.endDateTime.isBefore(_getEventsUntilDateTime))
            .toList();

        final groupInfos = streamValues[1] as Map<String, GroupInfo>? ?? {};

        final eventViews = pastEvents
            .map((event) => EventView.fromEventAndGroupInfo(
                event, groupInfos[event.groupID]))
            .toList();

        return eventViews;
      }).listen((events) {
        state = PastCalendricalEventsPageLoadedState(events);
        notifyListeners();
      })
        ..onError((e) {
          _setError('$e');
        });
    } catch (e) {
      _setError('$e');
    }
  }

  set setSortOrder(EventsSortingOrder order) {
    _sortingOrder = order;
    analytics.logChangedOrder(order);
    _refresh();
  }

  void _refresh() {
    state = PastCalendricalEventsPageLoadingState();

    _eventsSubscription?.cancel();
    _eventsSubscription = null;

    notifyListeners();
    _listenToPastEvents();
  }

  void _setError(String error) {
    state = PastCalendricalEventsPageErrorState(error);
    notifyListeners();
  }

  @override
  void dispose() {
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
