// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:bloc_provider/bloc_provider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hausaufgabenheft_logik/hausaufgabenheft_logik.dart';
import 'package:platform_check/platform_check.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';
import 'package:sharezone/ads/ad_banner.dart';
import 'package:sharezone/ads/ads_controller.dart';
import 'package:sharezone/homework/shared/shared.dart';
import 'package:sharezone/homework/student/src/homework_bottom_action_bar.dart';
import 'package:sharezone/navigation/logic/navigation_bloc.dart';
import 'package:sharezone/navigation/models/navigation_item.dart';
import 'package:sharezone/navigation/scaffold/app_bar_configuration.dart';
import 'package:sharezone/navigation/scaffold/bottom_bar_configuration.dart';
import 'package:sharezone/navigation/scaffold/sharezone_main_scaffold.dart';
import 'package:sharezone/timetable/timetable_page/school_class_filter/school_class_filter.dart';
import 'package:sharezone_widgets/sharezone_widgets.dart';

import 'src/completed_homework_list.dart';
import 'src/empty_homework_list_widgets/get_student_empty_homework_list_widgets.dart';
import 'src/empty_homework_list_widgets/homework_status.dart';
import 'src/open_homework_list.dart';

class StudentHomeworkPage extends StatelessWidget {
  const StudentHomeworkPage({super.key});

  String getAdUnitId(BuildContext context) {
    if (kDebugMode) {
      return context.read<AdsController>().getTestAdUnitId(AdFormat.banner);
    }

    return switch (PlatformCheck.currentPlatform) {
      // Copied from the AdMob Console
      Platform.android => 'ca-app-pub-7730914075870960/6002721082',
      Platform.iOS => 'ca-app-pub-7730914075870960/5068913364',
      _ => 'N/A',
    };
  }

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<StudentHomeworkPageBloc>(context);

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
            appBarConfiguration: const AppBarConfiguration(
              bottom: HomeworkTabBar(
                tabs: [Tab(text: 'OFFEN'), Tab(text: 'ERLEDIGT')],
              ),
              actions: <Widget>[],
            ),
            body: const StudentHomeworkBody(),
            navigationItem: NavigationItem.homework,
            bottomBarConfiguration: BottomBarConfiguration(
              bottomBar: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  AdBanner(adUnitId: getAdUnitId(context)),
                  SchoolClassFilterBottomBar(
                    backgroundColor: bottomBarBackgroundColor,
                  ),
                  AnimatedTabVisibility(
                    visibleInTabIndicies: const [0],
                    // Else the Sort shown in the button and the current sort
                    // could get out of order
                    maintainState: true,
                    curve: Curves.easeInOut,
                    child: HomeworkBottomActionBar(
                      backgroundColor: bottomBarBackgroundColor,
                      currentHomeworkSortStream: bloc.stream
                          .whereType<Success>()
                          .map((s) => s.open.sorting),
                      showOverflowMenu: true,
                      onCompletedAllOverdue:
                          () => bloc.add(CompletedAllOverdue()),
                      onSortingChanged:
                          (sort) => bloc.add(OpenHwSortingChanged(sort)),
                    ),
                  ),
                ],
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

enum HomeworkTab { open, completed }

final Color? overscrollColor = Colors.grey[600];

class StudentHomeworkBody extends StatelessWidget {
  Widget getCenteredPlaceholder(HomeworkTab tab, HomeworkPageStatus status) {
    return Center(
      child: getStudentEmptyHomeworkListWidgetsWithStatus(
        forTab: tab,
        homeworkStatus: status,
      ),
    );
  }

  const StudentHomeworkBody({super.key});

  @override
  Widget build(BuildContext context) {
    // ignore:close_sinks
    final bloc = BlocProvider.of<StudentHomeworkPageBloc>(context);
    bloc.add(LoadHomeworks());
    return StreamBuilder<StudentHomeworkPageState>(
      stream: bloc.stream,
      initialData: bloc.state,
      builder: (context, snapshot) {
        final state = snapshot.hasData ? snapshot.data : Uninitialized();

        if (state is Uninitialized) {
          return Container();
        } else if (state is Success) {
          final currentStatus = HomeworkPageStatus(
            state.open.numberOfHomeworks,
            state.completed.numberOfHomeworks,
          );

          final openHomeworkWidget =
              currentStatus.hasOpenHomeworks
                  ? OpenHomeworkList(
                    homeworkListView: state.open,
                    overscrollColor: overscrollColor,
                    showCompleteAllOverdueCard:
                        state.open.showCompleteOverdueHomeworkPrompt,
                  )
                  : getCenteredPlaceholder(HomeworkTab.open, currentStatus);

          final completedHomeworkWidget =
              currentStatus.hasCompletedHomeworks
                  ? CompletedHomeworkList(view: state.completed, bloc: bloc)
                  : getCenteredPlaceholder(
                    HomeworkTab.completed,
                    currentStatus,
                  );

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
