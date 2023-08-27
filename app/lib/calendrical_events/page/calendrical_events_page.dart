// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

//@dart=2.12

import 'package:bloc_provider/bloc_provider.dart';
import 'package:flutter/material.dart';
import 'package:sharezone/calendrical_events/bloc/calendrical_events_page_bloc.dart';
import 'package:sharezone/calendrical_events/bloc/calendrical_events_page_bloc_factory.dart';
import 'package:sharezone/navigation/logic/navigation_bloc.dart';
import 'package:sharezone/navigation/models/navigation_item.dart';
import 'package:sharezone/navigation/scaffold/sharezone_main_scaffold.dart';
import 'package:sharezone/timetable/src/widgets/events/calender_event_card.dart';
import 'package:sharezone/timetable/src/widgets/events/event_view.dart';
import 'package:sharezone/timetable/timetable_page/timetable_page.dart';
import 'package:sharezone/widgets/material/modal_bottom_sheet_big_icon_button.dart';
import 'package:sharezone_widgets/sharezone_widgets.dart';

enum _FABEventListOption { event, exam }

class CalendricalEventsPage extends StatefulWidget {
  static const tag = "timetable-event-list";

  @override
  _CalendricalEventsPageState createState() => _CalendricalEventsPageState();
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
    return WillPopScope(
      onWillPop: () => popToOverview(context),
      child: BlocProvider(
        bloc: bloc,
        child: SharezoneMainScaffold(
          body: const _CalendricalEventsPageBody(),
          floatingActionButton: _EventListFAB(),
          navigationItem: NavigationItem.events,
        ),
      ),
    );
  }
}

class _CalendricalEventsPageBody extends StatelessWidget {
  const _CalendricalEventsPageBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<CalendricalEventsPageBloc>(context);
    return StreamBuilder<List<EventView>>(
      initialData: bloc.allUpcomingEvents.valueOrNull,
      stream: bloc.allUpcomingEvents,
      builder: (context, snapshot) {
        final events = snapshot.data;

        if (events == null) return Container();
        if (events.isEmpty) return _EmptyEventList();
        return _EventList(events: events);
      },
    );
  }
}

class _EventList extends StatelessWidget {
  const _EventList({Key? key, required this.events}) : super(key: key);

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

    if (result != null) {
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
                    color: isDarkThemeEnabled(context)
                        ? Colors.grey[100]
                        : Colors.grey[800],
                    fontSize: 18)),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Container(
                height: 150,
                child: Stack(
                  children: const <Widget>[
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
  const _EmptyEventList({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: PlaceholderWidgetWithAnimation(
      iconSize: const Size(150, 150),
      title: "Es stehen keine Termine und Prüfungen in der Zukunft an.",
      svgPath: "assets/icons/calendar.svg",
      description: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Column(
          children: const <Widget>[
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
  const _AddEventTile({Key? key}) : super(key: key);

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
  const _AddExamTile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CardListTile(
      title: const Text("Prüfung eintragen"),
      centerTitle: true,
      onTap: () => showTimetableAddEventPage(context, isExam: true),
    );
  }
}
