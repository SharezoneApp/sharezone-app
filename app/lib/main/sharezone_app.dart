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
import 'package:provider/provider.dart';
import 'package:sharezone/account/account_page.dart';
import 'package:sharezone/account/use_account_on_multiple_devices_instruction.dart';
import 'package:sharezone/blackboard/blackboard_picture.dart';
import 'package:sharezone/calendrical_events/page/calendrical_events_page.dart';
import 'package:sharezone/calendrical_events/page/past_calendrical_events_page.dart';
import 'package:sharezone/dynamic_links/beitrittsversuch.dart';
import 'package:sharezone/feedback/feedback_box_page.dart';
import 'package:sharezone/feedback/history/feedback_history_page.dart';
import 'package:sharezone/filesharing/file_sharing_page.dart';
import 'package:sharezone/grades/pages/create_term_page/create_term_page.dart';
import 'package:sharezone/grades/pages/grades_dialog/grades_dialog.dart';
import 'package:sharezone/groups/group_join/bloc/group_join_function.dart';
import 'package:sharezone/groups/src/pages/course/create/pages/course_template_page.dart';
import 'package:sharezone/groups/src/pages/course/group_help.dart';
import 'package:sharezone/ical_links/dialog/ical_links_dialog.dart';
import 'package:sharezone/ical_links/list/ical_links_page.dart';
import 'package:sharezone/legal/privacy_policy/privacy_policy_page.dart';
import 'package:sharezone/legal/terms_of_service/terms_of_service_page.dart';
import 'package:sharezone/logging/logging.dart';
import 'package:sharezone/main/bloc_dependencies.dart';
import 'package:sharezone/main/course_join_listener.dart';
import 'package:sharezone/main/sharezone_bloc_providers.dart';
import 'package:sharezone/main/sharezone_material_app.dart';
import 'package:sharezone/navigation/logic/navigation_bloc.dart';
import 'package:sharezone/navigation/navigation_controller.dart';
import 'package:sharezone/notifications/firebase_messaging_callback_configurator.dart';
import 'package:sharezone/notifications/notifications_permission.dart';
import 'package:sharezone/settings/settings_page.dart';
import 'package:sharezone/settings/src/subpages/about/about_page.dart';
import 'package:sharezone/settings/src/subpages/changelog_page.dart';
import 'package:sharezone/settings/src/subpages/imprint/page/imprint_page.dart';
import 'package:sharezone/settings/src/subpages/language/language_page.dart';
import 'package:sharezone/settings/src/subpages/my_profile/change_email.dart';
import 'package:sharezone/settings/src/subpages/my_profile/change_password.dart';
import 'package:sharezone/settings/src/subpages/my_profile/change_state.dart';
import 'package:sharezone/settings/src/subpages/my_profile/change_type_of_user/change_type_of_user_page.dart';
import 'package:sharezone/settings/src/subpages/my_profile/my_profile_page.dart';
import 'package:sharezone/settings/src/subpages/notification.dart';
import 'package:sharezone/settings/src/subpages/theme/theme_page.dart';
import 'package:sharezone/settings/src/subpages/timetable/timetable_settings_page.dart';
import 'package:sharezone/settings/src/subpages/web_app.dart';
import 'package:sharezone/sharezone_v2/sz_v2_announcement_dialog.dart';
import 'package:sharezone/support/support_page.dart';
import 'package:sharezone/timetable/timetable_add/timetable_add_page.dart';
import 'package:sharezone/util/api.dart';
import 'package:sharezone/util/navigation_service.dart';
import 'package:sharezone_common/references.dart';
import 'package:showcaseview/showcaseview.dart';

import '../grades/grades_service/grades_service.dart';
import 'missing_account_information_guard/missing_account_information_guard.dart';
import 'onboarding/onboarding_listener.dart';

class SharezoneApp extends StatefulWidget {
  const SharezoneApp(
    this.blocDependencies,
    this.analytics,
    this.beitrittsversuche, {
    super.key,
  });

  final BlocDependencies blocDependencies;
  final Analytics analytics;
  final Stream<Beitrittsversuch?> beitrittsversuche;

  @override
  State createState() => _SharezoneAppState();
}

class _SharezoneAppState extends State<SharezoneApp>
    with WidgetsBindingObserver {
  final navigationService = NavigationService();
  late SharezoneGateway _sharezoneGateway;
  FirebaseMessagingCallbackConfigurator? fbMessagingConfigurator;
  final disposeCallbacks = <VoidCallback>[];

  @override
  void initState() {
    super.initState();

    fbMessagingConfigurator = FirebaseMessagingCallbackConfigurator(
      navigationBloc: navigationBloc,
      navigationService: navigationService,
      notificationsPermission: context.read<NotificationsPermission>(),
      vapidKey: widget.blocDependencies.remoteConfiguration.getString(
        'firebase_messaging_vapid_key',
      ),
    );

    _sharezoneGateway = SharezoneGateway(
      authUser: widget.blocDependencies.authUser!,
      memberID: MemberIDUtils.getMemberID(
        uid: widget.blocDependencies.authUser!.uid,
      ),
      references: widget.blocDependencies.references,
    );
    disposeCallbacks.add(_sharezoneGateway.dispose);

    final crashAnalytics = getCrashAnalytics();
    startLoggingRecording(crashAnalytics);

    _startLastOnlineReporting();
  }

  void _startLastOnlineReporting() {
    final userId = UserId(widget.blocDependencies.authUser!.uid);
    final reporter = LastOnlineReporter.startReporting(
      widget.blocDependencies.firestore,
      userId,
      getCrashAnalytics(),
      minimumDurationBetweenReports: const Duration(minutes: 5),
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
        builder: (context) {
          final navigationBloc = BlocProvider.of<NavigationBloc>(context);
          return CourseJoinListener(
            beitrittsversuche: widget.beitrittsversuche,
            groupJoinFunction: GroupJoinFunction(
              _sharezoneGateway.connectionsGateway,
              getCrashAnalytics(),
            ),
            child: SharezoneMaterialApp(
              blocDependencies: widget.blocDependencies,
              home: MissingAccountInformationGuard(
                userCollection: widget.blocDependencies.references.users,
                child: SharezoneV2AnnoucementDialogGuard(
                  child: OnboardingListener(
                    child: NavigationController(
                      fbMessagingConfigurator: fbMessagingConfigurator,
                      key: navigationBloc.controllerKey,
                    ),
                  ),
                ),
              ),
              analytics: widget.analytics,
              onUnknownRouteWidget: NavigationController(
                fbMessagingConfigurator: fbMessagingConfigurator,
                key: navigationBloc.controllerKey,
              ),
              routes: {
                AccountPage.tag: (context) => const AccountPage(),
                AboutPage.tag: (context) => const AboutPage(),
                FeedbackPage.tag: (context) => const FeedbackPage(),
                ChangelogPage.tag: (context) => const ChangelogPage(),
                CourseHelpPage.tag: (context) => const CourseHelpPage(),
                SettingsPage.tag: (context) => const SettingsPage(),
                NotificationPage.tag: (context) => const NotificationPage(),
                SupportPage.tag: (context) => const SupportPage(),
                ChangeEmailPage.tag: (context) => const ChangeEmailPage(),
                ChangePasswordPage.tag: (context) => const ChangePasswordPage(),
                ChangeStatePage.tag: (context) => const ChangeStatePage(),
                FileSharingPage.tag: (context) => const FileSharingPage(),
                ThemePage.tag: (context) => const ThemePage(),
                TimetableSettingsPage.tag:
                    (context) => const TimetableSettingsPage(),
                CourseTemplatePage.tag: (context) => const CourseTemplatePage(),
                CalendricalEventsPage.tag:
                    (context) => const CalendricalEventsPage(),
                PrivacyPolicyPage.tag: (context) => PrivacyPolicyPage(),
                TermsOfServicePage.tag: (context) => const TermsOfServicePage(),
                UseAccountOnMultipleDevicesInstructions.tag:
                    (context) =>
                        const UseAccountOnMultipleDevicesInstructions(),
                MyProfilePage.tag: (context) => const MyProfilePage(),
                BlackboardDialogChoosePicture.tag:
                    (context) => const BlackboardDialogChoosePicture(),
                TimetableAddPage.tag: (context) => const TimetableAddPage(),
                WebAppSettingsPage.tag: (context) => const WebAppSettingsPage(),
                ImprintPage.tag: (context) => const ImprintPage(),
                PastCalendricalEventsPage.tag:
                    (context) => const PastCalendricalEventsPage(),
                ChangeTypeOfUserPage.tag:
                    (context) => const ChangeTypeOfUserPage(),
                FeedbackHistoryPage.tag:
                    (context) => const FeedbackHistoryPage(),
                ICalLinksPage.tag: (context) => const ICalLinksPage(),
                ICalLinksDialog.tag: (context) => const ICalLinksDialog(),
                CreateTermPage.tag: (context) => const CreateTermPage(),
                GradesDialog.tag: (context) {
                  if (ModalRoute.of(context)!.settings.arguments case {
                    'gradeId': String id,
                  }) {
                    return GradesDialog(gradeId: GradeId(id));
                  }
                  return const GradesDialog();
                },
                LanguagePage.tag: (context) => const LanguagePage(),
              },
              navigatorKey: navigationService.navigatorKey,
            ),
          );
        },
      ),
    );
  }
}
