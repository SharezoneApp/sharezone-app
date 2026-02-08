// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:bloc_provider/bloc_provider.dart';
import 'package:flutter/material.dart';
import 'package:hausaufgabenheft_logik/hausaufgabenheft_logik_lehrer.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';
import 'package:sharezone/homework/shared/shared.dart';
import 'package:sharezone/homework/student/src/homework_bottom_action_bar.dart';
import 'package:sharezone/navigation/logic/navigation_bloc.dart';
import 'package:sharezone/navigation/models/navigation_item.dart';
import 'package:sharezone/navigation/scaffold/app_bar_configuration.dart';
import 'package:sharezone/navigation/scaffold/bottom_bar_configuration.dart';
import 'package:sharezone/navigation/scaffold/sharezone_main_scaffold.dart';
import 'package:sharezone_localizations/sharezone_localizations.dart';
import 'package:sharezone_widgets/sharezone_widgets.dart';

import 'src/teacher_and_parent_src.dart';

class TeacherAndParentHomeworkPage extends StatelessWidget {
  const TeacherAndParentHomeworkPage({super.key});

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<TeacherAndParentHomeworkPageBloc>(context);

    final bottomBarBackgroundColor =
        Theme.of(context).isDarkTheme ? Colors.grey[900] : Colors.grey[100];
    return ChangeNotifierProvider<BottomOfScrollViewInvisibilityController>(
      create: (_) => BottomOfScrollViewInvisibilityController(),
      child: PopScope<Object?>(
        canPop: false,
        onPopInvokedWithResult: (didPop, _) {
          if (didPop) return;
          popToOverview(context);
        },
        child: DefaultTabController(
          length: 2,
          child: SharezoneMainScaffold(
            colorBehindBNB: bottomBarBackgroundColor,
            appBarConfiguration: AppBarConfiguration(
              bottom: HomeworkTabBar(
                tabs: [
                  Tab(text: context.l10n.homeworkTabOpenUppercase),
                  Tab(text: context.l10n.homeworkTabArchivedUppercase),
                ],
              ),
              actions: <Widget>[],
            ),
            body: const TeacherHomeworkBody(),
            navigationItem: NavigationItem.homework,
            bottomBarConfiguration: BottomBarConfiguration(
              bottomBar: AnimatedTabVisibility(
                visibleInTabIndicies: const [0],
                // Else the Sort shown in the button and the current sort
                // could get out of order
                maintainState: true,
                child: HomeworkBottomActionBar(
                  currentHomeworkSortStream: bloc.stream
                      .whereType<Success>()
                      .map((s) => s.open.sorting),
                  backgroundColor: bottomBarBackgroundColor,
                  showOverflowMenu: false,
                  // Not visible since we don't show the overflow menu
                  onCompletedAllOverdue: () => throw UnimplementedError(),
                  onSortingChanged:
                      (newSort) => bloc.add(OpenHwSortingChanged(newSort)),
                ),
              ),
            ),
            floatingActionButton: const BottomOfScrollViewInvisibility(
              child: HomeworkFab(),
            ),
          ),
        ),
      ),
    );
  }
}

enum HomeworkTab { open, archived }

final Color? overscrollColor = Colors.grey[600];

class TeacherHomeworkBody extends StatelessWidget {
  const TeacherHomeworkBody({super.key});

  @override
  Widget build(BuildContext context) {
    // ignore:close_sinks
    final bloc = BlocProvider.of<TeacherAndParentHomeworkPageBloc>(context);
    bloc.add(LoadHomeworks());
    return StreamBuilder<TeacherAndParentHomeworkPageState>(
      stream: bloc.stream,
      initialData: bloc.state,
      builder: (context, snapshot) {
        final state = snapshot.hasData ? snapshot.data : Uninitialized();

        if (state is Uninitialized) {
          return Container();
        } else if (state is Success) {
          final hasOpenHomeworks = state.open.numberOfHomeworks > 0;
          final hasArchivedHomeworks = state.archived.numberOfHomeworks > 0;

          final openHomeworkWidget =
              hasOpenHomeworks
                  ? TeacherAndParentOpenHomeworkList(
                    homeworkListView: state.open,
                    overscrollColor: overscrollColor,
                  )
                  : _NoOpenHomeworkPlaceholder();

          final completedHomeworkWidget =
              hasArchivedHomeworks || !state.archived.loadedAllHomeworks
                  ? TeacherAndParentArchivedHomeworkList(
                    view: state.archived,
                    bloc: bloc,
                  )
                  : _NoArchivedHomeworkPlaceholder();

          return TabBarView(
            children: <Widget>[openHomeworkWidget, completedHomeworkWidget],
          );
        } else {
          throw UnimplementedError("Unimplemented HomeworkListState");
        }
      },
    );
  }
}

class _NoOpenHomeworkPlaceholder extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return PlaceholderWidgetWithAnimation(
      key: ValueKey('no-homework-teacher-placeholder-for-open-homework'),
      iconSize: const Size(175, 175),
      title: context.l10n.homeworkTeacherNoOpenTitle,
      description: const Padding(
        padding: EdgeInsets.only(top: 8),
        child: AddHomeworkCard(),
      ),
      svgPath: 'assets/icons/sleeping.svg',
      animateSVG: true,
    );
  }
}

class _NoArchivedHomeworkPlaceholder extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return PlaceholderWidgetWithAnimation(
      key: ValueKey('no-homework-teacher-placeholder-for-archived-homework'),
      iconSize: const Size(160, 160),
      title: context.l10n.homeworkTeacherNoArchivedTitle,
      description: const Padding(
        padding: EdgeInsets.only(top: 8),
        child: AddHomeworkCard(),
      ),
      svgPath: 'assets/icons/cardboard-package.svg',
      animateSVG: true,
    );
  }
}
