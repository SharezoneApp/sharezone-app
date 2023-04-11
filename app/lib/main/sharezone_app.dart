// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'dart:async';

import 'package:analytics/analytics.dart';
import 'package:bloc_provider/bloc_provider.dart';
import 'package:common_domain_models/common_domain_models.dart';
import 'package:crash_analytics/crash_analytics.dart';
import 'package:flutter/material.dart';
import 'package:last_online_reporting/last_online_reporting.dart';
import 'package:sharezone/account/account_page.dart';
import 'package:sharezone/account/use_account_on_multiple_devices_instruction.dart';
import 'package:sharezone/blackboard/blackboard_picture.dart';
import 'package:sharezone/blocs/bloc_dependencies.dart';
import 'package:sharezone/blocs/sharezone_bloc_providers.dart';
import 'package:sharezone/calendrical_events/page/calendrical_events_page.dart';
import 'package:sharezone/dynamic_links/beitrittsversuch.dart';
import 'package:sharezone/feedback/feedback_box_page.dart';
import 'package:sharezone/filesharing/file_sharing_page.dart';
import 'package:sharezone/groups/group_join/bloc/group_join_function.dart';
import 'package:sharezone/groups/src/pages/course/create/course_template_page.dart';
import 'package:sharezone/groups/src/pages/course/group_help.dart';
import 'package:sharezone/logging/logging.dart';
import 'package:sharezone/main/course_join_listener.dart';
import 'package:sharezone/main/sharezone_material_app.dart';
import 'package:sharezone/navigation/logic/navigation_bloc.dart';
import 'package:sharezone/navigation/navigation_controller.dart';
import 'package:sharezone/notifications/firebase_messaging_callback_configurator.dart';
import 'package:sharezone/onboarding/sign_up/pages/privacy_policy/privacy_policy_page.dart';
import 'package:sharezone/pages/homework/homework_archived.dart';
import 'package:sharezone/pages/settings/changelog_page.dart';
import 'package:sharezone/pages/settings/my_profile/change_email.dart';
import 'package:sharezone/pages/settings/my_profile/change_password.dart';
import 'package:sharezone/pages/settings/my_profile/change_state.dart';
import 'package:sharezone/pages/settings/my_profile/my_profile_page.dart';
import 'package:sharezone/pages/settings/notification.dart';
import 'package:sharezone/pages/settings/src/subpages/about/about_page.dart';
import 'package:sharezone/pages/settings/src/subpages/imprint/page/imprint_page.dart';
import 'package:sharezone/pages/settings/src/subpages/theme/theme_page.dart';
import 'package:sharezone/pages/settings/support_page.dart';
import 'package:sharezone/pages/settings/timetable_settings/timetable_settings_page.dart';
import 'package:sharezone/pages/settings/web_app.dart';
import 'package:sharezone/pages/settings_page.dart';
import 'package:sharezone/timetable/timetable_add/timetable_add_page.dart';
import 'package:sharezone/util/api.dart';
import 'package:sharezone/util/navigation_service.dart';
import 'package:sharezone_common/references.dart';
import 'package:showcaseview/showcaseview.dart';

import 'missing_account_information_guard/missing_account_information_guard.dart';
import 'onboarding/onboarding_listener.dart';

class SharezoneApp extends StatefulWidget {
  const SharezoneApp(
      this.blocDependencies, this.analytics, this.beitrittsversuche);

  final BlocDependencies blocDependencies;
  final Analytics analytics;
  final Stream<Beitrittsversuch> beitrittsversuche;

  @override
  _SharezoneAppState createState() => _SharezoneAppState();
}

class _SharezoneAppState extends State<SharezoneApp>
    with WidgetsBindingObserver {
  final navigationService = NavigationService();
  SharezoneGateway _sharezoneGateway;
  FirebaseMessagingCallbackConfigurator fbMessagingConfigurator;
  final disposeCallbacks = <VoidCallback>[];

  @override
  void initState() {
    super.initState();

    fbMessagingConfigurator = FirebaseMessagingCallbackConfigurator(
      navigationBloc: navigationBloc,
      navigationService: navigationService,
    );

    _sharezoneGateway = SharezoneGateway(
      authUser: widget.blocDependencies.authUser,
      memberID:
          MemberIDUtils.getMemberID(uid: widget.blocDependencies.authUser.uid),
      references: widget.blocDependencies.references,
    );

    final crashAnalytics = getCrashAnalytics();
    startLoggingRecording(crashAnalytics);

    _startLastOnlineReporting();
  }

  void _startLastOnlineReporting() {
    final userId = UserId(widget.blocDependencies.authUser.uid);
    final reporter = LastOnlineReporter.startReporting(
      widget.blocDependencies.firestore,
      userId,
      getCrashAnalytics(),
      minimumDurationBetweenReports: Duration(minutes: 5),
    );
    disposeCallbacks.add(reporter.dispose);
  }

  @override
  void dispose() {
    for (var disposeCallback in disposeCallbacks) {
      disposeCallback();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SharezoneBlocProviders(
      blocDependencies: widget.blocDependencies,
      navigationService: navigationService,
      beitrittsversuche: widget.beitrittsversuche,
      child: ShowCaseWidget(
        builder: Builder(builder: (context) {
          final navigationBloc = BlocProvider.of<NavigationBloc>(context);
          return CourseJoinListener(
            beitrittsversuche: widget.beitrittsversuche,
            groupJoinFunction: GroupJoinFunction(
                _sharezoneGateway.connectionsGateway, getCrashAnalytics()),
            child: SharezoneMaterialApp(
              blocDependencies: widget.blocDependencies,
              home: MissingAccountInformationGuard(
                userCollection: widget.blocDependencies.references.users,
                child: OnboardingListener(
                  child: NavigationController(
                    fbMessagingConfigurator: fbMessagingConfigurator,
                    key: navigationBloc.controllerKey,
                  ),
                ),
              ),
              analytics: widget.analytics,
              onUnknownRouteWidget: NavigationController(
                fbMessagingConfigurator: fbMessagingConfigurator,
                key: navigationBloc.controllerKey,
              ),
              routes: {
                HomeworkArchivedPage.tag: (context) => HomeworkArchivedPage(),
                AccountPage.tag: (context) => AccountPage(),
                AboutPage.tag: (context) => AboutPage(),
                FeedbackPage.tag: (context) => FeedbackPage(),
                ChangelogPage.tag: (context) => ChangelogPage(),
                CourseHelpPage.tag: (context) => CourseHelpPage(),
                SettingsPage.tag: (context) => SettingsPage(),
                NotificationPage.tag: (context) => NotificationPage(),
                SupportPage.tag: (context) => SupportPage(),
                ChangeEmailPage.tag: (context) => ChangeEmailPage(),
                ChangePasswordPage.tag: (context) => ChangePasswordPage(),
                ChangeStatePage.tag: (context) => ChangeStatePage(),
                FileSharingPage.tag: (context) => FileSharingPage(),
                ThemePage.tag: (context) => ThemePage(),
                TimetableSettingsPage.tag: (context) => TimetableSettingsPage(),
                CourseTemplatePage.tag: (context) => CourseTemplatePage(),
                CalendricalEventsPage.tag: (context) => CalendricalEventsPage(),
                PrivacyPolicyPage.tag: (context) => PrivacyPolicyPage(),
                UseAccountOnMultipleDevicesIntruction.tag: (context) =>
                    UseAccountOnMultipleDevicesIntruction(),
                MyProfilePage.tag: (context) => MyProfilePage(),
                BlackboardDialogChoosePicture.tag: (context) =>
                    BlackboardDialogChoosePicture(),
                TimetableAddPage.tag: (context) => TimetableAddPage(),
                WebAppSettingsPage.tag: (context) => WebAppSettingsPage(),
                ImprintPage.tag: (context) => ImprintPage(),
              },
              navigatorKey: navigationService.navigatorKey,
            ),
          );
        }),
      ),
    );
  }
}
