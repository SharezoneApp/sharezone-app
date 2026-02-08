// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'dart:async';
import 'dart:math';

import 'package:bloc_provider/bloc_provider.dart';
import 'package:date/date.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:group_domain_models/group_domain_models.dart';
import 'package:platform_check/platform_check.dart';
import 'package:provider/provider.dart';
import 'package:sharezone/ads/ad_banner.dart';
import 'package:sharezone/ads/ads_controller.dart';
import 'package:sharezone/calendrical_events/models/calendrical_event.dart';
import 'package:sharezone/main/application_bloc.dart';
import 'package:sharezone/navigation/logic/navigation_bloc.dart';
import 'package:sharezone/navigation/models/navigation_item.dart';
import 'package:sharezone/navigation/scaffold/app_bar_configuration.dart';
import 'package:sharezone/navigation/scaffold/bottom_bar_configuration.dart';
import 'package:sharezone/navigation/scaffold/sharezone_main_scaffold.dart';
import 'package:sharezone/settings/src/subpages/timetable/timetable_settings_page.dart';
import 'package:sharezone/timetable/src/bloc/timetable_bloc.dart';
import 'package:sharezone/timetable/src/bloc/timetable_selection_bloc.dart';
import 'package:sharezone/timetable/src/logic/timetable_builder.dart';
import 'package:sharezone/timetable/src/logic/timetable_date_helper.dart';
import 'package:sharezone/timetable/src/models/lesson.dart';
import 'package:sharezone/timetable/src/widgets/events/calender_event_card.dart';
import 'package:sharezone/timetable/src/widgets/timetable_week_view.dart';
import 'package:sharezone/timetable/timetable_add/timetable_add_page.dart';
import 'package:sharezone/timetable/timetable_page/timetable_event_details.dart';
import 'package:sharezone/widgets/tutorial_video_player.dart';
import 'package:sharezone_widgets/sharezone_widgets.dart';

import '../timetable_add_event/timetable_add_event_dialog.dart';
import 'lesson/timetable_lesson_tile.dart';
import 'school_class_filter/school_class_filter.dart';

part 'timetable_page_fab.dart';
part 'timetable_tile_event.dart';

class TimetablePage extends StatelessWidget {
  static const tag = "timetable-page";
  static const days = 5;

  static const timetableScale = 1.00;

  const TimetablePage({super.key});

  String getAdUnitId(BuildContext context) {
    if (kDebugMode) {
      return context.read<AdsController>().getTestAdUnitId(AdFormat.banner);
    }

    return switch (PlatformCheck.currentPlatform) {
      // Copied from the AdMob Console
      Platform.android => 'ca-app-pub-7730914075870960/7645268953',
      Platform.iOS => 'ca-app-pub-7730914075870960/6326053086',
      _ => 'N/A',
    };
  }

  @override
  Widget build(BuildContext context) {
    final bottomBarBackgroundColor =
        Theme.of(context).isDarkTheme ? Colors.grey[900] : Colors.grey[100];
    final api = BlocProvider.of<SharezoneContext>(context).api;
    final bloc = BlocProvider.of<TimetableBloc>(context);
    return PopScope<Object?>(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (didPop) return;
        popToOverview(context);
      },
      child: BlocProvider(
        bloc: TimetableSelectionBloc(),
        child: SharezoneMainScaffold(
          colorBehindBNB: bottomBarBackgroundColor,
          appBarConfiguration: const AppBarConfiguration(
            elevation: 0,
            actions: [_SettingsIcon()],
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
            bottomBar: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                AdBanner(adUnitId: getAdUnitId(context)),
                SchoolClassFilterBottomBar(
                  backgroundColor: bottomBarBackgroundColor,
                ),
              ],
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
      icon: Icon(
        themeIconData(Icons.settings, cupertinoIcon: CupertinoIcons.settings),
      ),
      tooltip: 'Stundenplan-Einstellungen',
      onPressed: () => Navigator.pushNamed(context, TimetableSettingsPage.tag),
    );
  }
}

class TimeTableUnit extends StatefulWidget {
  const TimeTableUnit({
    super.key,
    required this.groupInfos,
    required this.lessons,
    required this.timetableConfig,
  });

  final Map<String, GroupInfo> groupInfos;
  final List<Lesson> lessons;
  final TimetableConfig timetableConfig;

  @override
  State<TimeTableUnit> createState() => _TimeTableUnitState();
}

class _TimeTableUnitState extends State<TimeTableUnit> {
  late final Date _today = Date.today();
  late final Date _startOfCurrentWeek = TimetableDateHelper.dateBeginThisWeek(
    today: _today,
  );
  late final Date _endOfCurrentWeek = TimetableDateHelper.dateAddDays(
    _startOfCurrentWeek,
    6,
  );
  final PageController _pageController = PageController();
  late StreamSubscription<List<CalendricalEvent>>? _initialWeekSub;

  void _maybeJumpToUpcomingWeek(Iterable<CalendricalEvent> events) {
    final shouldOpenUpcomingWeek = TimetableDateHelper.shouldOpenUpcomingWeek(
      today: _today,
      enabledWeekDays: widget.timetableConfig.getEnabledWeekDays(),
      isFeatureEnabled:
          widget.timetableConfig.openUpcomingWeekOnNonSchoolDays(),
      eventDatesInCurrentWeek: events.map((e) => e.date),
    );

    if (!shouldOpenUpcomingWeek || !mounted) return;
    _pageController.jumpToPage(1);
  }

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;

      final bloc = BlocProvider.of<TimetableBloc>(context);
      _initialWeekSub = bloc
          .events(_startOfCurrentWeek, endDate: _endOfCurrentWeek)
          .where((events) => events.isNotEmpty || true)
          .take(1)
          .listen(_maybeJumpToUpcomingWeek);
    });
  }

  @override
  void dispose() {
    _initialWeekSub?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      // Users expect to be able to drag the timetable horizontally to the
      // next/previous week via mouse as this is old behavior.
      //
      // Flutter had this as a default until they made a breaking change (
      // disable dragging as a default for desktops with mice). So this is a
      // workaround to explicitly re-enable this behavior. See:
      // https://docs.flutter.dev/release/breaking-changes/default-scroll-behavior-drag
      //
      // In the future we might add explicit buttons to go forward or
      // backwards a week in the timetable - in this case desktop might
      // remove this behavior.
      scrollBehavior: ScrollConfiguration.of(context).copyWith(
        dragDevices: {PointerDeviceKind.touch, PointerDeviceKind.mouse},
      ),
      controller: _pageController,
      itemBuilder: (context, index) {
        final startOfWeek = TimetableDateHelper.dateAddWeeks(
          _startOfCurrentWeek,
          index,
        );
        final endDate = TimetableDateHelper.dateAddDays(startOfWeek, 6);
        final daysList = TimetableDateHelper.generateDaysList(
          startOfWeek,
          endDate,
          widget.timetableConfig.getEnabledWeekDays(),
        );

        final filteredLessonsList = getFilteredLessonList(
          widget.lessons,
          widget.timetableConfig.getWeekType(daysList.first),
        );

        final bloc = BlocProvider.of<TimetableBloc>(context);
        return StreamBuilder<List<CalendricalEvent>>(
          stream: bloc.events(startOfWeek, endDate: endDate),
          builder: (context, snapshot) {
            final events = snapshot.data ?? <CalendricalEvent>[];
            final builder = TimetableBuilder(
              filteredLessonsList,
              daysList,
              events,
              widget.groupInfos,
            );
            return TimetableWeekView(
              dates: daysList,
              elements: [...builder.buildElements()],
              config: widget.timetableConfig,
              periods: widget.timetableConfig.getPeriods(),
            );
          },
        );
      },
    );
  }
}
