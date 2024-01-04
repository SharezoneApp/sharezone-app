// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

part of '../dashboard_page.dart';

class _HomeworkSection extends StatelessWidget {
  const _HomeworkSection();

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<DashboardBloc>(context);
    return _Section(
      title: const _HomeworkSectionTitle(),
      child: SharezoneAnimatedStreamList<HomeworkView>(
        listStream: bloc.urgentHomeworks,
        isListEmptyStream: bloc.urgentHomeworksEmpty,
        height: 115,
        padding: const EdgeInsets.only(right: 12),
        emptyListWidget: _NoUrgentHomeworks(),
        scrollDirection: Axis.horizontal,
        itemBuilder: (view, index, context, animation) => FadeTransition(
          key: Key(view.homework.id),
          opacity: animation,
          child: HomeworkCardRedesigned(
            width: 170,
            homeworkView: view,
            padding: const EdgeInsets.only(left: 12),
          ),
        ),
        itemRemovedBuilder: (view, index, context, animation) => FadeTransition(
          key: Key(view.homework.id),
          opacity: animation,
          child: HomeworkCardRedesigned(
            homeworkView: view,
            width: 170,
            padding: const EdgeInsets.only(left: 12),
            forceIsDone: true,
          ),
        ),
      ),
    );
  }
}

class _HomeworkSectionTitle extends StatelessWidget {
  const _HomeworkSectionTitle();

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<DashboardBloc>(context);
    return StreamBuilder<int>(
      stream: bloc.numberOfUrgentHomeworks,
      builder: (context, snapshot) {
        final numberOfUrgentHomeworks = snapshot.data ?? 0;
        return Text(
            "Dringende Hausaufgaben ${numberOfUrgentHomeworks != 0 ? "($numberOfUrgentHomeworks)" : ""}");
      },
    );
  }
}

class _NoUrgentHomeworks extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: CustomCard(
        onTap: () {
          final bloc = BlocProvider.of<NavigationBloc>(context);
          bloc.navigateTo(NavigationItem.homework);
        },
        padding: const EdgeInsets.all(6),
        child: const Center(
          child: Text(
            "Es stehen keine dringenden Hausaufgaben an 😅\nJetzt ist Zeit für die wichtigen Dinge! 😉",
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
