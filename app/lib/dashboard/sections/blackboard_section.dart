// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

part of '../dashboard_page.dart';

class _BlackboardSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<DashboardBloc>(context);
    return _Section(
      title: _BlackboardSectionTitle(),
      child: StreamBuilder<List<BlackboardView>>(
        stream: bloc.unreadBlackboardViews,
        builder: (context, snapshot) {
          final list = snapshot.data ?? [];
          if (list.isEmpty) return _NoBlackboardViews();

          return SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                for (final view in list)
                  BlackboardCardDashboard(
                    width: 220,
                    view: view,
                    maxLines: 2,
                    withDetailsButton: false,
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _BlackboardSectionTitle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<DashboardBloc>(context);
    return StreamBuilder<int>(
      stream: bloc.numberOfUnreadBlackboardViews,
      builder: (context, snapshot) {
        final numberOfUnreadsBlackboardViews = snapshot.data ?? 0;
        return Text(
            "Ungelesene Infozettel ${numberOfUnreadsBlackboardViews != 0 ? "($numberOfUnreadsBlackboardViews)" : ""}");
      },
    );
  }
}

class _NoBlackboardViews extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: CustomCard(
        onTap: () {
          final bloc = BlocProvider.of<NavigationBloc>(context);
          bloc.navigateTo(NavigationItem.blackboard);
        },
        padding: const EdgeInsets.all(8),
        child: Center(
          child: Text(
            "Du hast alle Infozettel gelesen 👍",
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
