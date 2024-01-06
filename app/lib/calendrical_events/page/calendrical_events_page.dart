// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:bloc_provider/bloc_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sharezone/calendrical_events/bloc/calendrical_events_page_bloc.dart';
import 'package:sharezone/calendrical_events/bloc/calendrical_events_page_bloc_factory.dart';
import 'package:sharezone/calendrical_events/page/past_calendrical_events_page.dart';
import 'package:sharezone/calendrical_events/models/calendrical_events_layout.dart';
import 'package:sharezone/navigation/logic/navigation_bloc.dart';
import 'package:sharezone/navigation/models/navigation_item.dart';
import 'package:sharezone/navigation/scaffold/app_bar_configuration.dart';
import 'package:sharezone/navigation/scaffold/sharezone_main_scaffold.dart';
import 'package:sharezone/sharezone_plus/subscription_service/subscription_flag.dart';
import 'package:sharezone/timetable/src/widgets/events/calender_event_card.dart';
import 'package:sharezone/timetable/src/widgets/events/event_view.dart';
import 'package:sharezone/timetable/timetable_page/timetable_page.dart';
import 'package:sharezone/widgets/material/modal_bottom_sheet_big_icon_button.dart';
import 'package:sharezone_widgets/sharezone_widgets.dart';

enum _FABEventListOption { event, exam }

class CalendricalEventsPage extends StatefulWidget {
  static const tag = "timetable-event-list";

  const CalendricalEventsPage({super.key});

  @override
  State createState() => _CalendricalEventsPageState();
}

class _CalendricalEventsPageState extends State<CalendricalEventsPage> {
  late CalendricalEventsPageBloc bloc;

  @override
  void initState() {
    super.initState();
    bloc = BlocProvider.of<CalendricalEventsPageBlocFactory>(context).create();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
        if (didPop) return;
        popToOverview(context);
      },
      child: BlocProvider(
        bloc: bloc,
        child: SharezoneMainScaffold(
          appBarConfiguration: const AppBarConfiguration(
            actions: [
              _PastEventsIconButton(),
              _LayoutIconButton(),
            ],
          ),
          body: const _CalendricalEventsPageBody(),
          floatingActionButton: _EventListFAB(),
          navigationItem: NavigationItem.events,
        ),
      ),
    );
  }
}

class _PastEventsIconButton extends StatelessWidget {
  const _PastEventsIconButton();

  void logAnalytics(BuildContext context) {
    final bloc = BlocProvider.of<CalendricalEventsPageBloc>(context);
    bloc.logPastEventsPageOpened();
  }

  @override
  Widget build(BuildContext context) {
    final isSharezonePlusEnabled =
        context.watch<SubscriptionEnabledFlag>().isEnabled;

    if (!isSharezonePlusEnabled) {
      return const SizedBox();
    }

    return IconButton(
      tooltip: 'Vergangene Termine',
      onPressed: () {
        logAnalytics(context);
        Navigator.pushNamed(context, PastCalendricalEventsPage.tag);
      },
      icon: const Icon(Icons.history),
    );
  }
}

class _LayoutIconButton extends StatefulWidget {
  const _LayoutIconButton();

  @override
  State<_LayoutIconButton> createState() => _LayoutIconButtonState();
}

class _LayoutIconButtonState extends State<_LayoutIconButton>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation<double> animation;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(vsync: this);
    animation = Tween<double>(begin: 0.0, end: 1.0).animate(controller);

    _setInitialAnimatedIconPosition();
  }

  void _setInitialAnimatedIconPosition() {
    final bloc = BlocProvider.of<CalendricalEventsPageBloc>(context);
    bloc.layout.first.then((layout) {
      controller.value = switch (layout) {
        CalendricalEventsPageLayout.list => 0.0,
        CalendricalEventsPageLayout.grid => 1.0,
      };
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<CalendricalEventsPageBloc>(context);
    return StreamBuilder<CalendricalEventsPageLayout>(
      stream: bloc.layout,
      builder: (context, snapshot) {
        final layout = snapshot.data;
        if (layout == null) return const SizedBox();

        return IconButton(
          tooltip: switch (layout) {
            CalendricalEventsPageLayout.list => 'Auf Kacheln umschalten',
            CalendricalEventsPageLayout.grid => 'Auf Liste umschalten',
          },
          onPressed: () {
            bloc.setLayout(
              switch (layout) {
                CalendricalEventsPageLayout.list =>
                  CalendricalEventsPageLayout.grid,
                CalendricalEventsPageLayout.grid =>
                  CalendricalEventsPageLayout.list,
              },
            );
            controller.fling(
              velocity: switch (layout) {
                CalendricalEventsPageLayout.list => 1.0,
                CalendricalEventsPageLayout.grid => -1.0,
              },
            );
          },
          icon: AnimatedIcon(
            icon: AnimatedIcons.view_list,
            progress: animation,
          ),
        );
      },
    );
  }
}

class _CalendricalEventsPageBody extends StatelessWidget {
  const _CalendricalEventsPageBody();

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<CalendricalEventsPageBloc>(context);
    return StreamBuilder<List<EventView>>(
      initialData: bloc.allUpcomingEvents.valueOrNull,
      stream: bloc.allUpcomingEvents,
      builder: (context, snapshot) {
        final events = snapshot.data;

        if (events == null) return Container();
        if (events.isEmpty) return const _EmptyEventList();
        return _Events(events: events);
      },
    );
  }
}

class _Events extends StatelessWidget {
  const _Events({required this.events});

  final List<EventView> events;

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<CalendricalEventsPageBloc>(context);
    return SafeArea(
      child: StreamBuilder<CalendricalEventsPageLayout>(
        stream: bloc.layout,
        builder: (context, snapshot) {
          final layout = snapshot.data;
          return AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: switch (layout) {
              CalendricalEventsPageLayout.list => _EventList(events: events),
              CalendricalEventsPageLayout.grid => _EventGrid(events: events),
              null => const SizedBox()
            },
          );
        },
      ),
    );
  }
}

class _EventList extends StatelessWidget {
  const _EventList({required this.events});

  final List<EventView> events;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ListView.builder(
        padding: const EdgeInsets.fromLTRB(0, 16, 12, 4),
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
      ),
    );
  }
}

class _EventGrid extends StatelessWidget {
  const _EventGrid({required this.events});

  final List<EventView> events;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(0, 16, 12, 4),
      child: SafeArea(
        child: WrappableList(
          minWidth: 150.0,
          maxElementsPerSection: 3,
          children: <Widget>[
            for (final event in events)
              Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: CalenderEventCard(event),
              )
          ],
        ),
      ),
    );
  }
}

class _EventListFAB extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ModalFloatingActionButton(
      onPressed: () => openEventListFABSheet(context),
      icon: const Icon(Icons.add),
      tooltip: 'Termin oder Prüfung hinzufügen',
    );
  }

  Future<TimetableResult?> openEventListFABSheet(BuildContext context) async {
    final result = await showModalBottomSheet(
      context: context,
      builder: (context) => _EventListFABSheet(),
    );

    if (result != null && context.mounted) {
      if (result == _FABEventListOption.event) {
        return showTimetableAddEventPage(context, isExam: false);
      } else if (result == _FABEventListOption.exam) {
        return showTimetableAddEventPage(context, isExam: true);
      }
    }

    return null;
  }
}

class _EventListFABSheet extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const SizedBox(height: 20),
            Text("Neu erstellen",
                style: TextStyle(
                    color: Theme.of(context).isDarkTheme
                        ? Colors.grey[100]
                        : Colors.grey[800],
                    fontSize: 18)),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 12),
              child: SizedBox(
                height: 150,
                child: Stack(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(right: 145),
                      child: ModalBottomSheetBigIconButton<_FABEventListOption>(
                        title: "Termin",
                        alignment: Alignment.center,
                        iconData: Icons.event,
                        popValue: _FABEventListOption.event,
                        tooltip: "Neuen Termin erstellen",
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 145),
                      child: ModalBottomSheetBigIconButton<_FABEventListOption>(
                        alignment: Alignment.center,
                        title: "Prüfung",
                        iconData: Icons.school,
                        popValue: _FABEventListOption.exam,
                        tooltip: "Neue Prüfung erstellen",
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class _EmptyEventList extends StatelessWidget {
  const _EmptyEventList();

  @override
  Widget build(BuildContext context) {
    return const SafeArea(
        child: PlaceholderWidgetWithAnimation(
      iconSize: Size(150, 150),
      title: "Es stehen keine Termine und Prüfungen in der Zukunft an.",
      svgPath: "assets/icons/calendar.svg",
      description: Padding(
        padding: EdgeInsets.symmetric(vertical: 8),
        child: Column(
          children: <Widget>[
            _AddExamTile(),
            SizedBox(height: 12),
            _AddEventTile(),
          ],
        ),
      ),
    ));
  }
}

class _AddEventTile extends StatelessWidget {
  const _AddEventTile();

  @override
  Widget build(BuildContext context) {
    return CardListTile(
      title: const Text("Termin eintragen"),
      centerTitle: true,
      onTap: () => showTimetableAddEventPage(context, isExam: false),
    );
  }
}

class _AddExamTile extends StatelessWidget {
  const _AddExamTile();

  @override
  Widget build(BuildContext context) {
    return CardListTile(
      title: const Text("Prüfung eintragen"),
      centerTitle: true,
      onTap: () => showTimetableAddEventPage(context, isExam: true),
    );
  }
}
