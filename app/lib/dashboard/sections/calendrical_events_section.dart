// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

part of '../dashboard_page.dart';

class _EventsSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<DashboardBloc>(context);
    return _Section(
      title: _EventsSectionTitle(),
      child: StreamBuilder<List<EventView>>(
        stream: bloc.upcomingEvents,
        builder: (context, snapshot) {
          final eventViews = snapshot.data ?? [];
          if (eventViews.isEmpty) return _NoEventsViews();
          return SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                for (final view in eventViews)
                  SizedBox(width: 150, child: CalenderEventCard(view))
              ],
            ),
          );
        },
      ),
    );
  }
}

class _EventsSectionTitle extends StatelessWidget {
  const _EventsSectionTitle({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<DashboardBloc>(context);
    return StreamBuilder<int>(
      stream: bloc.numberOfUpcomingEvents,
      builder: (context, snapshot) {
        final numberOfUrgentHomeworks = snapshot.data ?? 0;
        return Text(
            "Anstehende Termine ${numberOfUrgentHomeworks != 0 ? "($numberOfUrgentHomeworks)" : ""}");
      },
    );
  }
}

class _NoEventsViews extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: CustomCard(
        onTap: () {
          final bloc = BlocProvider.of<NavigationBloc>(context);
          bloc.navigateTo(NavigationItem.events);
        },
        padding: const EdgeInsets.all(8),
        child: Center(
          child: Text(
            "In den nächsten 14 Tagen stehen keine Termine an! 👻",
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
