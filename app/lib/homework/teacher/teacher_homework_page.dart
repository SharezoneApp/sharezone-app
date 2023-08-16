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
import 'package:sharezone/homework/shared/shared.dart';
import 'package:sharezone/navigation/logic/navigation_bloc.dart';
import 'package:sharezone/navigation/models/navigation_item.dart';
import 'package:sharezone/navigation/scaffold/app_bar_configuration.dart';
import 'package:sharezone/navigation/scaffold/bottom_bar_configuration.dart';
import 'package:sharezone/navigation/scaffold/sharezone_main_scaffold.dart';
import 'package:sharezone_widgets/sharezone_widgets.dart';

import 'src/teacher_archived_homework_list.dart';
import 'src/teacher_homework_bottom_action_bar.dart';
import 'src/teacher_open_homework_list.dart';

class TeacherHomeworkPage extends StatelessWidget {
  const TeacherHomeworkPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ///
    /// !!ACHTUNG!!
    ///
    /// Falls hier was geändert wird, dann sollte dies auch im
    /// app/test/homework/teacher/teacher_homework_page_widget_test.dart
    /// geändert werden.
    /// Dort musste die Seite aufgrund des nicht mockbaren, hier verwendeten
    /// [SharezoneMainScaffold] nachgebaut werden.
    ///
    /// https://gitlab.com/codingbrain/sharezone/sharezone-app/-/issues/1459
    /// https://gitlab.com/codingbrain/sharezone/sharezone-app/-/issues/1458
    ///
    /// !!ACHTUNG!!
    ///
    final bottomBarBackgroundColor =
        isDarkThemeEnabled(context) ? Colors.grey[900] : Colors.grey[100];
    return ChangeNotifierProvider<BottomOfScrollViewInvisibilityController>(
      create: (_) => BottomOfScrollViewInvisibilityController(),
      child: WillPopScope(
        onWillPop: () => popToOverview(context),
        child: DefaultTabController(
          length: 2,
          child: SharezoneMainScaffold(
            colorBehindBNB: bottomBarBackgroundColor,
            appBarConfiguration: AppBarConfiguration(
              bottom: HomeworkTabBar(
                tabs: const [Tab(text: 'OFFEN'), Tab(text: 'ARCHIVIERT')],
              ),
              actions: const <Widget>[],
            ),
            body: TeacherHomeworkBody(),
            navigationItem: NavigationItem.homework,
            bottomBarConfiguration: BottomBarConfiguration(
              bottomBar: AnimatedTabVisibility(
                child: TeacherHomeworkBottomActionBar(
                  backgroundColor: bottomBarBackgroundColor,
                ),
                visibleInTabIndicies: const [0],
                // Else the Sort shown in the button and the current sort
                // could get out of order
                maintainState: true,
              ),
            ),
            floatingActionButton:
                BottomOfScrollViewInvisibility(child: HomeworkFab()),
          ),
        ),
      ),
    );
  }
}

final Color overscrollColor = Colors.grey[600];

class TeacherHomeworkBody extends StatelessWidget {
  const TeacherHomeworkBody({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // ignore:close_sinks
    final bloc = BlocProvider.of<TeacherHomeworkPageBloc>(context);
    bloc.add(LoadHomeworks());
    return StreamBuilder<TeacherHomeworkPageState>(
      stream: bloc.stream,
      initialData: Uninitialized(),
      builder: (context, snapshot) {
        final state = snapshot.hasData ? snapshot.data : Uninitialized();

        if (state is Uninitialized) {
          return Container();
        } else if (state is Success) {
          final hasOpenHomeworks = state.open.numberOfHomeworks > 0;
          final hasArchivedHomeworks = state.archived.numberOfHomeworks > 0;

          final openHomeworkWidget = hasOpenHomeworks
              ? TeacherOpenHomeworkList(
                  homeworkListView: state.open,
                  overscrollColor: overscrollColor,
                )
              : _NoOpenHomeworkPlaceholder();

          final completedHomeworkWidget =
              hasArchivedHomeworks || !state.archived.loadedAllArchivedHomeworks
                  ? TeacherArchivedHomeworkList(
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
      key: const ValueKey('no-homework-teacher-placeholder-for-open-homework'),
      iconSize: const Size(175, 175),
      title: "Keine Hausaufgaben für die Schüler:innen? 😮😍",
      description: Padding(
        padding: const EdgeInsets.only(top: 8),
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
      title:
          "Hier werden alle Hausaufgaben angezeigt, deren Fälligkeitsdatum in der Vergangenheit liegt.",
      description: Padding(
        padding: const EdgeInsets.only(top: 8),
        child: AddHomeworkCard(),
      ),
      svgPath: 'assets/icons/cardboard-package.svg',
      animateSVG: true,
    );
  }
}
