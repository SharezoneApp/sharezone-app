import 'package:bloc_provider/bloc_provider.dart';
import 'package:flutter/material.dart';
import 'package:hausaufgabenheft_logik/hausaufgabenheft_logik.dart';
import 'package:provider/provider.dart';
import 'package:sharezone/homework/shared/animated_tab_visibility.dart';
import 'package:sharezone/homework/shared/bottom_of_scrollview_visibility.dart';
import 'package:sharezone/homework/shared/homework_fab.dart';
import 'package:sharezone/homework/shared/shared.dart';
import 'package:sharezone/homework/student/src/homework_bottom_action_bar.dart';
import 'package:sharezone/navigation/logic/navigation_bloc.dart';
import 'package:sharezone/navigation/models/navigation_item.dart';
import 'package:sharezone/navigation/scaffold/app_bar_configuration.dart';
import 'package:sharezone/navigation/scaffold/bottom_bar_configuration.dart';
import 'package:sharezone/navigation/scaffold/sharezone_main_scaffold.dart';
import 'package:sharezone_widgets/theme.dart';

import 'src/completed_homework_list.dart';
import 'src/empty_homework_list_widgets/get_student_empty_homework_list_widgets.dart';
import 'src/empty_homework_list_widgets/homework_status.dart';
import 'src/open_homework_list.dart';

class StudentHomeworkPage extends StatelessWidget {
  const StudentHomeworkPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
                tabs: const [Tab(text: 'OFFEN'), Tab(text: 'ERLEDIGT')],
              ),
              actions: const <Widget>[],
            ),
            body: StudentHomeworkBody(),
            navigationItem: NavigationItem.homework,
            bottomBarConfiguration: BottomBarConfiguration(
              bottomBar: AnimatedTabVisibility(
                child: HomeworkBottomActionBar(
                  backgroundColor: bottomBarBackgroundColor,
                ),
                visibleInTabIndicies: const [0],
                // Else the Sort shown in the button and the current sort
                // could get out of order
                maintainState: true,
                curve: Curves.easeInOut,
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

enum HomeworkTab { open, completed }

final Color overscrollColor = Colors.grey[600];

class StudentHomeworkBody extends StatelessWidget {
  Widget getCenteredPlaceholder(HomeworkTab tab, HomeworkPageStatus status) {
    return Center(
      child: getStudentEmptyHomeworkListWidgetswithStatus(
          forTab: tab, homeworkStatus: status),
    );
  }

  const StudentHomeworkBody({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // ignore:close_sinks
    final bloc = BlocProvider.of<HomeworkPageBloc>(context);
    bloc.add(LoadHomeworks());
    return StreamBuilder<HomeworkPageState>(
      stream: bloc,
      initialData: Uninitialized(),
      builder: (context, snapshot) {
        final state = snapshot.hasData ? snapshot.data : Uninitialized();

        if (state is Uninitialized) {
          return Container();
        } else if (state is Success) {
          final currentStatus = HomeworkPageStatus(
            state.open.numberOfHomeworks,
            state.completed.numberOfHomeworks,
          );

          final openHomeworkWidget = currentStatus.hasOpenHomeworks
              ? OpenHomeworkList(
                  homeworkListView: state.open,
                  overscrollColor: overscrollColor,
                  showCompleteAllOverdueCard:
                      state.open.showCompleteOverdueHomeworkPrompt,
                )
              : getCenteredPlaceholder(HomeworkTab.open, currentStatus);

          final completedHomeworkWidget = currentStatus.hasCompletedHomeworks
              ? CompletedHomeworkList(
                  view: state.completed,
                  bloc: bloc,
                )
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
