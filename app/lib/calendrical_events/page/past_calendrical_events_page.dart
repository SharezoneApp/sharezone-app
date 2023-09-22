// Copyright (c) 2023 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sharezone/calendrical_events/provider/past_calendrical_events_page_controller.dart';
import 'package:sharezone/calendrical_events/provider/past_calendrical_events_page_controller_factory.dart';
import 'package:sharezone/sharezone_plus/page/sharezone_plus_page.dart';
import 'package:sharezone/timetable/src/widgets/events/calender_event_card.dart';
import 'package:sharezone/timetable/src/widgets/events/event_view.dart';
import 'package:sharezone_widgets/sharezone_widgets.dart';

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
            value: EventsSortingOrder.ascending,
            child: _SortingTile(
              value: EventsSortingOrder.ascending,
              selectedValue: sortingOrder,
            )),
        PopupMenuItem(
          value: EventsSortingOrder.descending,
          child: _SortingTile(
            value: EventsSortingOrder.descending,
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

  String getTitel() {
    switch (value) {
      case EventsSortingOrder.ascending:
        return 'Aufsteigend';
      case EventsSortingOrder.descending:
        return 'Absteigend';
    }
  }

  String getSubtitle() {
    switch (value) {
      case EventsSortingOrder.ascending:
        return 'Älteste Termine zuerst';
      case EventsSortingOrder.descending:
        return 'Neueste Termine zuerst';
    }
  }

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
      title: Text(getTitel()),
      subtitle: Text(getSubtitle()),
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

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SharezonePlusFeatureInfoCard(
        withLearnMoreButton: true,
        onLearnMorePressed: () => navigateToSharezonePlusPage(context),
        child: const Text(
            'Erwerbe Sharezone Plus, alle vergangene Termine einzusehen.'),
      ),
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
