// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:flutter/material.dart';
import 'package:flutter_sfsymbols/flutter_sfsymbols.dart';
import 'package:sharezone/account/account_page.dart';
import 'package:sharezone/blackboard/blackboard_page.dart';
import 'package:sharezone/calendrical_events/page/calendrical_events_page.dart';
import 'package:sharezone/dashboard/dashboard_page.dart';
import 'package:sharezone/feedback/feedback_box_page.dart';
import 'package:sharezone/filesharing/file_sharing_page.dart';
import 'package:sharezone/groups/src/pages/course/group_page.dart';
import 'package:sharezone/pages/homework_page.dart';
import 'package:sharezone/pages/settings_page.dart';
import 'package:sharezone/sharezone_plus/page/sharezone_plus_page.dart';
import 'package:sharezone/timetable/timetable_page/timetable_page.dart';
import 'package:sharezone_widgets/sharezone_widgets.dart';

enum NavigationItem {
  overview,
  group,
  homework,
  timetable,
  blackboard,
  filesharing,
  events,
  sharezonePlus,
  feedbackBox,
  settings,
  accountPage,
  more,
}

extension NavigationItemExtension on NavigationItem {
  /// Why not simply call "analytics.log(navigationItem.toString())"? There are
  /// two problems with this:\
  /// First of all there all ready logged events with a spefic name, e. g.
  /// "file_sharing". [NavigationItem.fileSharing.toString()] would be
  /// "fileSharing" (a different analytics event --> the old analytics data
  /// would be lost).\
  /// Second problem: you couldn't rename the [NavigationItem]s anymore, because
  /// it would genereate a new analytics event, e. g. renaming
  /// [NavigationItem.fileSharing] in [NavigationItem.files] --> "files"
  /// (diffrent event --> the old analytics data would be lost).
  ///
  /// Important: Firebase Analytics doesn't allow "-" in a analytics event!
  String getAnalyticsName() {
    switch (this) {
      case NavigationItem.overview:
        return 'overview';
      case NavigationItem.homework:
        return 'homework';
      case NavigationItem.group:
        return 'group';
      case NavigationItem.timetable:
        return 'timetable';
      case NavigationItem.events:
        return 'events';
      case NavigationItem.blackboard:
        return 'blackboard';
      case NavigationItem.filesharing:
        return 'file_sharing';
      case NavigationItem.sharezonePlus:
        return 'sharezone_plus';
      case NavigationItem.settings:
        return 'settings';
      case NavigationItem.feedbackBox:
        return 'feedback';
      case NavigationItem.accountPage:
        return 'profile';
      case NavigationItem.more:
        return 'more';
    }
  }

  Widget getIcon() {
    switch (this) {
      case NavigationItem.overview:
        return Icon(
            themeIconData(Icons.home, cupertinoIcon: SFSymbols.house_fill));
      case NavigationItem.homework:
        return Icon(themeIconData(Icons.book,
            cupertinoIcon: SFSymbols.checkmark_square_fill));
      case NavigationItem.group:
        return Icon(
            themeIconData(Icons.group, cupertinoIcon: SFSymbols.person_2_fill));
      case NavigationItem.timetable:
        return Icon(
            themeIconData(Icons.event, cupertinoIcon: SFSymbols.calendar));
      case NavigationItem.events:
        return Icon(themeIconData(Icons.event_note,
            cupertinoIcon: SFSymbols.clock_fill));
      case NavigationItem.blackboard:
        return Icon(themeIconData(Icons.new_releases,
            cupertinoIcon: SFSymbols.info_circle_fill));
      case NavigationItem.filesharing:
        return Icon(themeIconData(Icons.insert_drive_file,
            cupertinoIcon: SFSymbols.folder_fill));
      case NavigationItem.sharezonePlus:
        return Icon(
            themeIconData(Icons.star, cupertinoIcon: SFSymbols.star_fill));
      case NavigationItem.settings:
        return Icon(themeIconData(Icons.settings,
            cupertinoIcon: SFSymbols.gear_alt_fill));
      case NavigationItem.feedbackBox:
        return Icon(themeIconData(Icons.message,
            cupertinoIcon: SFSymbols.exclamationmark_bubble_fill));
      case NavigationItem.accountPage:
        return Icon(
            themeIconData(Icons.person, cupertinoIcon: SFSymbols.person_fill));
      case NavigationItem.more:
        return Icon(
            themeIconData(Icons.more_horiz, cupertinoIcon: SFSymbols.ellipsis));
    }
  }

  String getName() {
    switch (this) {
      case NavigationItem.overview:
        return 'Übersicht';
      case NavigationItem.homework:
        return 'Hausaufgaben';
      case NavigationItem.group:
        return 'Gruppen';
      case NavigationItem.timetable:
        return 'Stundenplan';
      case NavigationItem.events:
        return 'Termine';
      case NavigationItem.blackboard:
        return 'Infozettel';
      case NavigationItem.filesharing:
        return 'Dateien';
      case NavigationItem.sharezonePlus:
        return 'Sharezone Plus';
      case NavigationItem.settings:
        return 'Einstellungen';
      case NavigationItem.feedbackBox:
        return 'Feedback';
      case NavigationItem.accountPage:
        return 'Profil';
      case NavigationItem.more:
        return 'Mehr';
    }
  }

  Widget getPageWidget() {
    switch (this) {
      case NavigationItem.overview:
        return const DashboardPage();
      case NavigationItem.group:
        return const GroupPage();
      case NavigationItem.homework:
        return const HomeworkPage();
      case NavigationItem.timetable:
        return TimetablePage();
      case NavigationItem.blackboard:
        return const BlackboardPage();
      case NavigationItem.filesharing:
        return const FileSharingPage();
      case NavigationItem.events:
        return const CalendricalEventsPage();
      case NavigationItem.sharezonePlus:
        return const SharezonePlusPage();
      case NavigationItem.settings:
        return const SettingsPage();
      case NavigationItem.feedbackBox:
        return const FeedbackPage();
      case NavigationItem.accountPage:
        return const AccountPage();
      case NavigationItem.more:
        // [NavigationItem.more] is not a spefic page. It's a navigation element
        // in the [ExtendableBottomNavigationBar]
        throw UnimplementedError('There is no widget for $this');
    }
  }

  String getPageTag() {
    switch (this) {
      case NavigationItem.overview:
        return DashboardPage.tag;
      case NavigationItem.homework:
        return HomeworkPage.tag;
      case NavigationItem.group:
        return GroupPage.tag;
      case NavigationItem.timetable:
        return TimetablePage.tag;
      case NavigationItem.events:
        return CalendricalEventsPage.tag;
      case NavigationItem.blackboard:
        return BlackboardPage.tag;
      case NavigationItem.filesharing:
        return FileSharingPage.tag;
      case NavigationItem.sharezonePlus:
        return SharezonePlusPage.tag;
      case NavigationItem.settings:
        return SettingsPage.tag;
      case NavigationItem.feedbackBox:
        return FeedbackPage.tag;
      case NavigationItem.accountPage:
        return AccountPage.tag;
      case NavigationItem.more:
        // [NavigationItem.more] is not a spefic page. It's a navigation element
        // in the [ExtendableBottomNavigationBar]
        throw UnimplementedError('There is no page tag for $this');
    }
  }
}
