// Copyright (c) 2023 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'dart:math';
import 'dart:ui';

import 'package:date/date.dart';
import 'package:design/design.dart';
import 'package:flutter/material.dart';
import 'package:group_domain_models/group_domain_models.dart';
import 'package:provider/provider.dart';
import 'package:sharezone/calendrical_events/models/calendrical_event.dart';
import 'package:sharezone/calendrical_events/models/calendrical_event_types.dart';
import 'package:sharezone/calendrical_events/provider/past_calendrical_events_page_controller.dart';
import 'package:sharezone/calendrical_events/provider/past_calendrical_events_page_controller_factory.dart';
import 'package:sharezone/sharezone_plus/page/sharezone_plus_page.dart';
import 'package:sharezone/timetable/src/widgets/events/calender_event_card.dart';
import 'package:sharezone/timetable/src/widgets/events/event_view.dart';
import 'package:sharezone_widgets/sharezone_widgets.dart';
import 'package:time/time.dart';

class PastCalendricalEventsPage extends StatefulWidget {
  const PastCalendricalEventsPage({super.key});

  static const tag = "past-calendrical-events-page";

  @override
  State<PastCalendricalEventsPage> createState() =>
      _PastCalendricalEventsPageState();
}

class _PastCalendricalEventsPageState extends State<PastCalendricalEventsPage> {
  late PastCalendricalEventsPageController controller;

  @override
  void initState() {
    super.initState();

    // The controller must be disposed of when the page closes. Otherwise, it
    // will keep the `_getEventsUntilDate` value from the first time the page
    // opened, even if it was closed and reopened later. The
    // `_getEventsUntilDate` value is used to determine which events are past
    // events and which are upcoming events.
    final factory = context.read<PastCalendricalEventsPageControllerFactory>();
    controller = factory.create();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: controller,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Vergangene Termine'),
          actions: const [
            _ToggleSortOrder(),
          ],
        ),
        body: const _Body(),
      ),
    );
  }
}

class _ToggleSortOrder extends StatelessWidget {
  const _ToggleSortOrder();

  @override
  Widget build(BuildContext context) {
    final sortingOrder =
        context.watch<PastCalendricalEventsPageController>().sortingOrder;
    return PopupMenuButton<EventsSortingOrder>(
      tooltip: 'Sortierreihenfolge',
      onSelected: (order) {
        context.read<PastCalendricalEventsPageController>().setSortOrder =
            order;
      },
      icon: const Icon(Icons.sort),
      itemBuilder: (context) => [
        PopupMenuItem(
          value: EventsSortingOrder.descending,
          child: _SortingTile(
            value: EventsSortingOrder.descending,
            selectedValue: sortingOrder,
          ),
        ),
        PopupMenuItem(
          value: EventsSortingOrder.ascending,
          child: _SortingTile(
            value: EventsSortingOrder.ascending,
            selectedValue: sortingOrder,
          ),
        ),
      ],
    );
  }
}

class _SortingTile extends StatelessWidget {
  const _SortingTile({
    required this.value,
    required this.selectedValue,
  });

  final EventsSortingOrder value;
  final EventsSortingOrder selectedValue;

  @override
  Widget build(BuildContext context) {
    final isSelected = value == selectedValue;
    return ListTile(
      leading: isSelected
          ? const Padding(
              padding: EdgeInsets.all(8.0),
              child: Icon(Icons.check, color: Colors.green),
            )
          : const SizedBox(width: 24, height: 24),
      title: Text(switch (value) {
        EventsSortingOrder.ascending => 'Aufsteigend',
        EventsSortingOrder.descending => 'Absteigend',
      }),
      subtitle: Text(switch (value) {
        EventsSortingOrder.ascending => 'Älteste Termine zuerst',
        EventsSortingOrder.descending => 'Neueste Termine zuerst',
      }),
      mouseCursor: SystemMouseCursors.click,
      contentPadding: const EdgeInsets.symmetric(horizontal: 0),
    );
  }
}

class _Body extends StatelessWidget {
  const _Body();

  @override
  Widget build(BuildContext context) {
    final state = context.watch<PastCalendricalEventsPageController>().state;
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      child: switch (state) {
        PastCalendricalEventsPageLoadingState() => const _LoadingIndicator(),
        PastCalendricalEventsPageNotUnlockedState() => const _SharezonePlusAd(),
        PastCalendricalEventsPageErrorState(error: final error) =>
          _Error(error),
        PastCalendricalEventsPageLoadedState(events: final events) =>
          _PastEventsList(events),
      },
    );
  }
}

class _SharezonePlusAd extends StatelessWidget {
  const _SharezonePlusAd();

  EventView _createDummyEventView({
    required String title,
    required String dateText,
    required String courseName,
    required Random random,
  }) {
    return EventView(
      groupID: 'groupId',
      dateText: dateText,
      title: title,
      courseName: courseName,
      event: CalendricalEvent(
        authorID: 'authorId',
        groupID: 'groupId',
        title: 'title',
        date: Date('01-01-2023'),
        detail: null,
        endTime: Time(hour: 12, minute: 0),
        eventID: 'eventId',
        eventType: Exam(),
        groupType: GroupType.course,
        latestEditor: null,
        place: null,
        sendNotification: false,
        startTime: Time(hour: 10, minute: 0),
      ),
      design: Design.random(random),
    );
  }

  @override
  Widget build(BuildContext context) {
    final random = Random(42);
    final dummyEvents = [
      _createDummyEventView(
        title: 'Sportfest',
        dateText: 'Jan 1, 2023',
        random: random,
        courseName: 'Sport',
      ),
      _createDummyEventView(
        title: 'Klausur Nr. 2',
        dateText: 'Feb 12, 2023',
        random: random,
        courseName: 'Mathe',
      ),
      _createDummyEventView(
        title: 'Elternsprechtag',
        dateText: 'Apr 3, 2023',
        random: random,
        courseName: 'Orga',
      ),
      _createDummyEventView(
        title: 'Klausur Nr. 3',
        dateText: 'Apr 12, 2023',
        random: random,
        courseName: 'Mathe',
      ),
      _createDummyEventView(
        title: 'Klausur Nr. 4',
        dateText: 'Apr 12, 2023',
        random: random,
        courseName: 'Mathe',
      ),
      _createDummyEventView(
        title: 'Schulfrei',
        dateText: 'Apr 13, 2023',
        random: random,
        courseName: 'Orga',
      ),
      _createDummyEventView(
        title: 'Klausur Nr. 5',
        dateText: 'Jun 14, 2023',
        random: random,
        courseName: 'Mathe',
      ),
      _createDummyEventView(
        title: 'Test Nr. 6',
        dateText: 'Jun 14, 2023',
        random: random,
        courseName: 'Biologie',
      ),
    ];

    return Stack(
      alignment: Alignment.center,
      children: [
        IgnorePointer(
          // We ignore the pointer to avoid that the user can scroll in blurred
          // the list.
          ignoring: true,
          child: _PastEventsList(dummyEvents),
        ),
        BackdropFilter(
          // We should use a blur that is not too strong so that a user can
          // identify that the users in the list are no real users. Otherwise
          // the user might think that some of the users have already read the
          // info sheet.
          filter: ImageFilter.blur(sigmaX: 2.5, sigmaY: 2.5),
          child: const SizedBox.expand(),
        ),
        Padding(
          padding: const EdgeInsets.all(12),
          child: SharezonePlusFeatureInfoCard(
            withLearnMoreButton: true,
            onLearnMorePressed: () => navigateToSharezonePlusPage(context),
            underlayColor: Theme.of(context).scaffoldBackgroundColor,
            child: const Text(
                'Erwerbe Sharezone Plus, alle vergangene Termine einzusehen.'),
          ),
        ),
      ],
    );
  }
}

class _PastEventsList extends StatelessWidget {
  const _PastEventsList(this.events);

  final List<EventView> events;

  @override
  Widget build(BuildContext context) {
    if (events.isEmpty) return const _EmptyList();
    return ListView.builder(
      padding: const EdgeInsets.only(top: 12),
      itemCount: events.length,
      itemBuilder: (context, index) {
        final event = events[index];
        return MaxWidthConstraintBox(
          child: Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: CalenderEventCard(event),
          ),
        );
      },
    );
  }
}

class _EmptyList extends StatelessWidget {
  const _EmptyList();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        'Keine vergangenen Termine',
      ),
    );
  }
}

class _LoadingIndicator extends StatelessWidget {
  const _LoadingIndicator();

  @override
  Widget build(BuildContext context) {
    return const Center(child: CircularProgressIndicator());
  }
}

class _Error extends StatelessWidget {
  const _Error(this.error);

  final String error;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'Fehler beim Laden der vergangenen Termine: $error',
        style: TextStyle(color: Theme.of(context).colorScheme.error),
      ),
    );
  }
}
