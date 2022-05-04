// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:analytics/analytics.dart';
import 'package:bloc_provider/bloc_provider.dart';
import 'package:feature_discovery/feature_discovery.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sharezone/blocs/application_bloc.dart';
import 'package:sharezone/blocs/dashbord_widgets_blocs/holiday_bloc.dart';
import 'package:sharezone/dashboard/analytics/dashboard_analytics.dart';
import 'package:sharezone/dashboard/bloc/dashboard_bloc.dart';
import 'package:sharezone/dashboard/models/homework_view.dart';
import 'package:sharezone/dashboard/timetable/lesson_view.dart';
import 'package:sharezone/dashboard/tips/dashboard_tip_system.dart';
import 'package:sharezone/dashboard/update_reminder/update_reminder_bloc.dart';
import 'package:sharezone/dashboard/widgets/blackboard_card_dashboard.dart';
import 'package:sharezone/download_app_tip/widgets/download_app_tip_card.dart';
import 'package:sharezone/models/extern_apis/holiday.dart';
import 'package:sharezone/navigation/logic/navigation_bloc.dart';
import 'package:sharezone/navigation/models/navigation_item.dart';
import 'package:sharezone/navigation/scaffold/app_bar_configuration.dart';
import 'package:sharezone/navigation/scaffold/sharezone_custom_scaffold.dart';
import 'package:sharezone/overview/cache/profile_page_hint_cache.dart';
import 'package:sharezone/pages/blackboard/details/blackboard_details.dart';
import 'package:sharezone/pages/blackboard_page.dart';
import 'package:sharezone/pages/homework_page.dart';
import 'package:sharezone/pages/settings/changelog_page.dart';
import 'package:sharezone/pages/settings/my_profile/change_state.dart';
import 'package:sharezone/timetable/src/widgets/events/calender_event_card.dart';
import 'package:sharezone/timetable/src/widgets/events/event_view.dart';
import 'package:sharezone/timetable/timetable_page/lesson/timetable_lesson_sheet.dart';
import 'package:sharezone/timetable/timetable_page/school_class_filter/school_class_filter.dart';
import 'package:sharezone/timetable/timetable_page/timetable_page.dart';
import 'package:sharezone/util/cache/key_value_store.dart';
import 'package:sharezone/util/cache/streaming_key_value_store.dart';
import 'package:sharezone/util/navigation_service.dart';
import 'package:sharezone/widgets/animated_stream_list.dart';
import 'package:sharezone/widgets/blackboard/blackboard_view.dart';
import 'package:sharezone/widgets/homework/homework_card.dart';
import 'package:sharezone/widgets/machting_type_of_user_stream_builder.dart';
import 'package:sharezone/widgets/material/modal_bottom_sheet_big_icon_button.dart';
import 'package:sharezone_common/helper_functions.dart';
import 'package:sharezone_utils/dimensions.dart';
import 'package:sharezone_utils/platform.dart';
import 'package:sharezone_widgets/announcement_card.dart';
import 'package:sharezone_widgets/snackbars.dart';
import 'package:sharezone_widgets/theme.dart';
import 'package:sharezone_widgets/widgets.dart';
import 'package:user/user.dart';

import 'tips/models/dashboard_tip.dart';

part './sections/blackboard_section.dart';
part './sections/calendrical_events_section.dart';
part './sections/dashboard_tip.dart';
part './sections/holiday_countdown_section.dart';
part './sections/homework_section.dart';
part './timetable/lesson_card.dart';
part './timetable/lesson_row.dart';
part './update_reminder/update_reminder.dart';
part './widgets/dashboard_fab.dart';
part './widgets/profile_avatar.dart';
part './widgets/section.dart';

class DashboardPage extends StatefulWidget {
  static const tag = 'overview-page';

  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  @override
  void initState() {
    super.initState();
    showTipCardIfIsAvailable(context);
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Dimensions.fromMediaQuery(context).isDesktopModus
          ? Theme.of(context)
          : Theme.of(context).copyWith(primaryColorBrightness: Brightness.dark),
      child: SharezoneCustomScaffold(
        appBarConfiguration: SliverAppBarConfiguration(
          title: _AppBarTitle(),
          backgroundColor:
              isDarkThemeEnabled(context) ? ElevationColors.dp8 : blueColor,
          expandedHeight: 210,
          elevation: 1,
          pinned: true,
          actions: const <Widget>[_ProfileAvatar()],
          flexibleSpace: _AppBarBottom(),
          drawerIconColor: Colors.white,
        ),
        navigationItem: NavigationItem.overview,
        body: DashboardPageBody(),
        floatingActionButton: _DashboardPageFAB(),
      ),
    );
  }
}

// Wird nur fürs Testing benutzt, weil die Page oben durch unser Scaffold auch
// den Navigation-Stuff per Provider bräuchte, der momentan noch sehr schwer
// testbar zu machen ist, da überall in dem Navigation Flutter-Code 100
// verschiedene Dependencies erstellt werden.
class DashboardPageBody extends StatelessWidget {
  @visibleForTesting
  const DashboardPageBody({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration:
          BoxDecoration(color: Theme.of(context).scaffoldBackgroundColor),
      child: AnimationLimiter(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: AnimationConfiguration.toStaggeredList(
            duration: const Duration(milliseconds: 250),
            childAnimationBuilder: (widget) => SlideAnimation(
              horizontalOffset: 20,
              child: FadeInAnimation(child: widget),
            ),
            children: [
              // Does not make sense on web because a user cant update on web
              // and will just have to wait till we push out the new version
              if (!PlatformCheck.isWeb) _UpdateReminder(),
              _DashboardTipSection(),
              const _HomeworkSection(),
              _EventsSection(),
              _BlackboardSection(),
              _HolidayCountdownSection(),
              const SizedBox(height: 32)
            ],
          ),
        ),
      ),
    );
  }
}

class _AppBarBottom extends StatelessWidget implements PreferredSizeWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: true,
      child: FlexibleSpaceBar(background: _LessonRow()),
    );
  }

  @override
  Size get preferredSize => const Size(0, 0);
}

class _AppBarTitle extends StatelessWidget {
  const _AppBarTitle({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      NavigationItem.overview.getName(),
      style:
          Theme.of(context).textTheme.headline6.copyWith(color: Colors.white),
      key: const ValueKey('dashboard-appbar-title-E2E'),
    );
  }
}
