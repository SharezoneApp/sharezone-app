// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:bloc_provider/bloc_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:group_domain_models/group_domain_models.dart';
import 'package:sharezone/blocs/application_bloc.dart';
import 'package:sharezone/calendrical_events/models/calendrical_event.dart';
import 'package:sharezone/navigation/logic/navigation_bloc.dart';
import 'package:sharezone/navigation/models/navigation_item.dart';
import 'package:sharezone/navigation/scaffold/app_bar_configuration.dart';
import 'package:sharezone/navigation/scaffold/bottom_bar_configuration.dart';
import 'package:sharezone/navigation/scaffold/sharezone_main_scaffold.dart';
import 'package:sharezone/pages/settings/timetable_settings/timetable_settings_page.dart';
import 'package:sharezone/timetable/src/bloc/timetable_bloc.dart';
import 'package:sharezone/timetable/src/bloc/timetable_selection_bloc.dart';
import 'package:sharezone/timetable/src/logic/timetable_builder.dart';
import 'package:sharezone/timetable/src/logic/timetable_date_helper.dart';
import 'package:sharezone/timetable/src/models/lesson.dart';
import 'package:sharezone/timetable/src/widgets/events/calender_event_card.dart';
import 'package:sharezone/timetable/src/widgets/timetable_week_view.dart';
import 'package:sharezone/timetable/timetable_add/timetable_add_page.dart';
import 'package:sharezone/timetable/timetable_add_event/timetable_add_event_page.dart';
import 'package:sharezone/timetable/timetable_page/timetable_event_details.dart';
import 'package:sharezone/widgets/material/modal_bottom_sheet_big_icon_button.dart';
import 'package:sharezone_widgets/sharezone_widgets.dart';

import 'lesson/timetable_lesson_tile.dart';
import 'school_class_filter/school_class_filter.dart';

part 'timetable_page_fab.dart';
part 'timetable_tile_event.dart';

class TimetablePage extends StatelessWidget {
  static const tag = "timetable-page";
  static const days = 5;

  final today = TimetableDateHelper.dateBeginThisWeek();
  final timetableScale = 1.00;

  @override
  Widget build(BuildContext context) {
    final bottomBarBackgroundColor =
        isDarkThemeEnabled(context) ? Colors.grey[900] : Colors.grey[100];
    final api = BlocProvider.of<SharezoneContext>(context).api;
    final bloc = BlocProvider.of<TimetableBloc>(context);
    return WillPopScope(
      onWillPop: () => popToOverview(context),
      child: BlocProvider(
        bloc: TimetableSelectionBloc(),
        child: SharezoneMainScaffold(
          colorBehindBNB: bottomBarBackgroundColor,
          appBarConfiguration: AppBarConfiguration(
            elevation: 0,
            actions: const [_SettingsIcon()],
          ),
          body: TimetableConfigBuilder(
            builder: (context, config) {
              return StreamBuilder<Map<String, GroupInfo>>(
                stream: api.course.getGroupInfoStream(api.schoolClassGateway),
                builder: (context, snapshot) {
                  final groupInfos = snapshot.data ?? {};
                  return StreamBuilder<List<Lesson>>(
                    initialData: bloc.lessons.valueOrNull,
                    stream: bloc.lessons,
                    builder: (context, snapshot) {
                      final lessons = snapshot.data ?? <Lesson>[];
                      return TimeTableUnit(
                        groupInfos: groupInfos,
                        lessons: lessons,
                        timetableConfig: config,
                      );
                    },
                  );
                },
              );
            },
          ),
          navigationItem: NavigationItem.timetable,
          floatingActionButton: _TimetablePageFAB(),
          bottomBarConfiguration: BottomBarConfiguration(
            bottomBar: SchoolClassFilterBottomBar(
              backgroundColor: bottomBarBackgroundColor,
            ),
          ),
        ),
      ),
    );
  }
}

class _SettingsIcon extends StatelessWidget {
  const _SettingsIcon();

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(themeIconData(Icons.settings,
          cupertinoIcon: CupertinoIcons.settings)),
      tooltip: 'Stundenplan-Einstellungen',
      onPressed: () => Navigator.pushNamed(context, TimetableSettingsPage.tag),
    );
  }
}

class TimeTableUnit extends StatelessWidget {
  TimeTableUnit({Key key, this.groupInfos, this.lessons, this.timetableConfig})
      : super(key: key);

  final Map<String, GroupInfo> groupInfos;
  final List<Lesson> lessons;
  final TimetableConfig timetableConfig;

  final today = TimetableDateHelper.dateBeginThisWeek();

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<TimetableBloc>(context);

    return PageView.builder(
      // Users expect to be able to drag the timetable horizontally to the
      // next/previous week via mouse as this is old behavior.
      //
      // Flutter had this as a default until they made a breaking change (
      // disable dragging as a default for desktops with mice). So this is a
      // workaround to explicitly re-enable this behavior. See:
      // https://docs.flutter.dev/release/breaking-changes/default-scroll-behavior-drag
      //
      // In the future we might add explicit buttons to go forward or backwards
      // a week in the timetable - in this case desktop might remove this
      // behavior.
      scrollBehavior: ScrollConfiguration.of(context).copyWith(dragDevices: {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
      }),
      itemBuilder: (context, index) {
        final startOfWeek = TimetableDateHelper.dateAddWeeks(today, index);
        final endDate = TimetableDateHelper.dateAddDays(startOfWeek, 6);
        final daysList = TimetableDateHelper.generateDaysList(
            startOfWeek, endDate, timetableConfig.getEnabledWeekDays());

        final filteredLessonsList = getFilteredLessonList(
          lessons,
          timetableConfig.getWeekType(daysList.first),
        );
        return StreamBuilder<List<CalendricalEvent>>(
          stream: bloc.events(startOfWeek, endDate: endDate),
          builder: (context, snapshot) {
            final events =
                snapshot.hasData ? snapshot.data : <CalendricalEvent>[];
            final builder = TimetableBuilder(
              filteredLessonsList,
              daysList,
              events,
              groupInfos,
            );
            return TimetableWeekView(
              dates: daysList,
              elements: [
                ...builder.buildElements(),
              ],
              config: timetableConfig,
              periods: timetableConfig.getPeriods(),
            );
          },
        );
      },
    );
  }
}
