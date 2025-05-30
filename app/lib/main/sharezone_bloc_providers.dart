// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:abgabe_client_lib/abgabe_client_lib.dart';
import 'package:abgabe_http_api/api.dart';
import 'package:analytics/analytics.dart';
import 'package:analytics/null_analytics_backend.dart'
    show NullAnalyticsBackend;
import 'package:authentification_base/authentification.dart' as auth;
import 'package:bloc_base/bloc_base.dart';
import 'package:bloc_provider/bloc_provider.dart';
import 'package:bloc_provider/multi_bloc_provider.dart';
import 'package:clock/clock.dart';
import 'package:common_domain_models/common_domain_models.dart';
import 'package:crash_analytics/crash_analytics.dart';
import 'package:dio/dio.dart';
import 'package:feedback_shared_implementation/feedback_shared_implementation.dart';
import 'package:filesharing_logic/file_uploader.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:group_domain_implementation/group_domain_accessors_implementation.dart';
import 'package:group_domain_models/group_domain_models.dart';
import 'package:hausaufgabenheft_logik/hausaufgabenheft_logik_lehrer.dart';
import 'package:hausaufgabenheft_logik/hausaufgabenheft_logik_setup.dart';
import 'package:holidays/holidays.dart' hide State;
import 'package:http/http.dart' as http;
import 'package:key_value_store/in_memory_key_value_store.dart';
import 'package:key_value_store/key_value_store.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:sharezone/account/account_page_bloc_factory.dart';
import 'package:sharezone/account/change_data_bloc.dart';
import 'package:sharezone/account/type_of_user_bloc.dart';
import 'package:sharezone/activation_code/src/bloc/enter_activation_code_bloc_factory.dart';
import 'package:sharezone/ads/ads_controller.dart';
import 'package:sharezone/blackboard/analytics/blackboard_analytics.dart';
import 'package:sharezone/blackboard/blocs/blackboard_page_bloc.dart';
import 'package:sharezone/calendrical_events/analytics/calendrical_events_page_analytics.dart';
import 'package:sharezone/calendrical_events/analytics/past_calendrical_events_page_analytics.dart';
import 'package:sharezone/calendrical_events/bloc/calendrical_events_page_bloc_factory.dart';
import 'package:sharezone/calendrical_events/bloc/calendrical_events_page_cache.dart';
import 'package:sharezone/calendrical_events/provider/past_calendrical_events_page_controller_factory.dart';
import 'package:sharezone/changelog/changelog_gateway.dart';
import 'package:sharezone/comments/comment_view_factory.dart';
import 'package:sharezone/comments/comments_analytics.dart';
import 'package:sharezone/comments/comments_bloc_factory.dart';
import 'package:sharezone/comments/comments_gateway.dart';
import 'package:sharezone/dashboard/bloc/dashboard_bloc.dart';
import 'package:sharezone/dashboard/gateway/dashboard_gateway.dart';
import 'package:sharezone/dashboard/tips/cache/dashboard_tip_cache.dart';
import 'package:sharezone/dashboard/tips/dashboard_tip_system.dart';
import 'package:sharezone/dashboard/update_reminder/update_reminder_bloc.dart';
import 'package:sharezone/download_app_tip/analytics/download_app_tip_analytics.dart';
import 'package:sharezone/download_app_tip/bloc/download_app_tip_bloc.dart';
import 'package:sharezone/download_app_tip/cache/download_app_tip_cache.dart';
import 'package:sharezone/dynamic_links/beitrittsversuch.dart';
import 'package:sharezone/feedback/history/feedback_history_page_analytics.dart';
import 'package:sharezone/feedback/history/feedback_history_page_controller.dart';
import 'package:sharezone/feedback/src/analytics/feedback_analytics.dart';
import 'package:sharezone/feedback/src/bloc/feedback_bloc.dart';
import 'package:sharezone/feedback/src/cache/feedback_cache.dart';
import 'package:sharezone/feedback/unread_messages/has_unread_feedback_messages_provider.dart';
import 'package:sharezone/grades/grades_service/grades_service.dart';
import 'package:sharezone/grades/pages/grades_details_page/grade_details_page_controller_factory.dart';
import 'package:sharezone/grades/pages/grades_dialog/grades_dialog_controller_factory.dart';
import 'package:sharezone/grades/pages/grades_page/grades_page_controller.dart';
import 'package:sharezone/grades/pages/term_details_page/term_details_page_controller_factory.dart';
import 'package:sharezone/grades/pages/term_settings_page/term_settings_page_controller_factory.dart';
import 'package:sharezone/groups/analytics/group_analytics.dart';
import 'package:sharezone/groups/src/pages/course/create/analytics/course_create_analytics.dart';
import 'package:sharezone/groups/src/pages/course/create/bloc/course_create_bloc_factory.dart';
import 'package:sharezone/groups/src/pages/course/create/gateway/course_create_gateway.dart';
import 'package:sharezone/homework/analytics/homework_analytics.dart';
import 'package:sharezone/homework/homework_details/homework_details_view_factory.dart';
import 'package:sharezone/homework/student/src/mark_overdue_homework_prompt.dart';
import 'package:sharezone/homework/teacher_and_parent/homework_done_by_users_list/homework_completion_user_list_bloc_factory.dart';
import 'package:sharezone/ical_links/dialog/ical_links_dialog_controller_factory.dart';
import 'package:sharezone/ical_links/list/ical_links_page_controller.dart';
import 'package:sharezone/ical_links/shared/ical_link_analytics.dart';
import 'package:sharezone/ical_links/shared/ical_links_gateway.dart';
import 'package:sharezone/l10n/feature_flag_l10n.dart';
import 'package:sharezone/main/application_bloc.dart';
import 'package:sharezone/main/bloc_dependencies.dart';
import 'package:sharezone/main/onboarding/onboarding_navigator.dart';
import 'package:sharezone/main/plugin_initializations.dart';
import 'package:sharezone/markdown/markdown_analytics.dart';
import 'package:sharezone/navigation/analytics/navigation_analytics.dart';
import 'package:sharezone/navigation/logic/navigation_bloc.dart';
import 'package:sharezone/navigation/scaffold/portable/bottom_navigation_bar/navigation_experiment/navigation_experiment_cache.dart';
import 'package:sharezone/navigation/scaffold/portable/bottom_navigation_bar/tutorial/bnb_tutorial_analytics.dart';
import 'package:sharezone/navigation/scaffold/portable/bottom_navigation_bar/tutorial/bnb_tutorial_bloc.dart';
import 'package:sharezone/navigation/scaffold/portable/bottom_navigation_bar/tutorial/bnb_tutorial_cache.dart';
import 'package:sharezone/notifications/notifications_bloc_factory.dart';
import 'package:sharezone/onboarding/bloc/registration_bloc.dart';
import 'package:sharezone/onboarding/group_onboarding/analytics/group_onboarding_analytics.dart';
import 'package:sharezone/onboarding/group_onboarding/logic/group_onboarding_bloc.dart';
import 'package:sharezone/onboarding/group_onboarding/logic/signed_up_bloc.dart';
import 'package:sharezone/report/report_factory.dart';
import 'package:sharezone/report/report_gateway.dart';
import 'package:sharezone/settings/src/bloc/user_settings_bloc.dart';
import 'package:sharezone/settings/src/bloc/user_tips_bloc.dart';
import 'package:sharezone/settings/src/subpages/imprint/analytics/imprint_analytics.dart';
import 'package:sharezone/settings/src/subpages/my_profile/change_type_of_user/change_type_of_user_analytics.dart';
import 'package:sharezone/settings/src/subpages/my_profile/change_type_of_user/change_type_of_user_controller.dart';
import 'package:sharezone/settings/src/subpages/my_profile/change_type_of_user/change_type_of_user_service.dart';
import 'package:sharezone/settings/src/subpages/timetable/bloc/timetable_settings_bloc_factory.dart';
import 'package:sharezone/settings/src/subpages/timetable/time_picker_settings_cache.dart';
import 'package:sharezone/sharezone_plus/page/sharezone_plus_page_analytics.dart';
import 'package:sharezone/sharezone_plus/page/sharezone_plus_page_controller.dart';
import 'package:sharezone/sharezone_plus/subscription_service/is_buying_enabled.dart';
import 'package:sharezone/sharezone_plus/subscription_service/revenue_cat_sharezone_plus_service.dart';
import 'package:sharezone/sharezone_plus/subscription_service/subscription_service.dart';
import 'package:sharezone/support/support_page_controller.dart';
import 'package:sharezone/timetable/src/bloc/timetable_bloc.dart';
import 'package:sharezone/timetable/src/models/lesson_length/lesson_length_cache.dart';
import 'package:sharezone/timetable/timetable_add/bloc/timetable_add_bloc_dependencies.dart';
import 'package:sharezone/timetable/timetable_add/bloc/timetable_add_bloc_factory.dart';
import 'package:sharezone/timetable/timetable_page/lesson/substitution_controller.dart';
import 'package:sharezone/timetable/timetable_page/school_class_filter/school_class_filter_analytics.dart';
import 'package:sharezone/util/api.dart';
import 'package:sharezone/util/api/connections_gateway.dart';
import 'package:sharezone/util/cache/key_value_store.dart';
import 'package:sharezone/util/cache/streaming_key_value_store.dart';
import 'package:sharezone/util/firebase_auth_token_retreiver_impl.dart';
import 'package:sharezone/util/navigation_service.dart';
import 'package:sharezone/util/notification_token_adder.dart';
import 'package:sharezone/util/platform_information_manager/flutter_platform_information_retreiver.dart';
import 'package:sharezone/util/platform_information_manager/get_platform_information_retreiver.dart';
import 'package:sharezone_common/references.dart';
import 'package:stripe_checkout_session/stripe_checkout_session.dart';
import 'package:url_launcher_extended/url_launcher_extended.dart';
import 'package:user/user.dart';

import '../holidays/holiday_bloc.dart';
import '../notifications/is_firebase_messaging_supported.dart';

final navigationBloc = NavigationBloc();

class SharezoneBlocProviders extends StatefulWidget {
  final Widget child;
  final BlocDependencies blocDependencies;
  final NavigationService? navigationService;
  final Stream<Beitrittsversuch?>? beitrittsversuche;

  const SharezoneBlocProviders({
    super.key,
    required this.child,
    required this.blocDependencies,
    this.navigationService,
    this.beitrittsversuche,
  });

  @override
  State createState() => _SharezoneBlocProvidersState();
}

class _SharezoneBlocProvidersState extends State<SharezoneBlocProviders> {
  late FeedbackBloc feedbackBloc;
  late Analytics analytics;
  late List<SingleChildStatelessWidget> providers;
  late List<BlocProvider<BlocBase>> mainBlocProviders;
  late List<BlocProvider<BlocBase>> timetableProviders;

  @override
  void initState() {
    super.initState();

    final analyticsBackend =
        kDebugMode
            ?
            // LoggingAnalyticsBackend()
            NullAnalyticsBackend()
            : getBackend();
    analytics = Analytics(analyticsBackend);

    // Muss in die initState, weil ansonsten der Bloc die Daten resettet,
    // wenn das Handy gedreht wird und dadurch die build Methode dieses Widgets
    // neu ausgeführt wird, wodurch der Bloc neu initialisiert wird.
    feedbackBloc = FeedbackBloc(
      FirebaseFeedbackApi(widget.blocDependencies.firestore),
      FeedbackCache(
        FlutterKeyValueStore(widget.blocDependencies.sharedPreferences),
      ),
      getPlatformInformationRetriever(),
      widget.blocDependencies.authUser!.uid,
      FeedbackAnalytics(analytics),
    );

    PluginInitializations.tryInitializeRevenueCat(
      androidApiKey: widget.blocDependencies.remoteConfiguration.getString(
        'revenuecat_api_android_key',
      ),
      appleApiKey: widget.blocDependencies.remoteConfiguration.getString(
        'revenuecat_api_apple_key',
      ),
      uid: widget.blocDependencies.authUser!.uid,
    );

    final api = SharezoneGateway(
      authUser: widget.blocDependencies.authUser!,
      memberID: MemberIDUtils.getMemberID(
        uid: widget.blocDependencies.authUser!.uid,
      ),
      references: widget.blocDependencies.references,
    );
    _disposeCallbacks.add(api.dispose);

    var streamingKeyValueStore = FlutterStreamingKeyValueStore(
      widget.blocDependencies.streamingSharedPreferences,
    );

    final lessonLengthCache = LessonLengthCache(streamingKeyValueStore);
    final timePickerSettingsCache = TimePickerSettingsCache(
      streamingKeyValueStore,
    );

    if (isFirebaseMessagingSupported()) {
      NotificationTokenAdder(
        NotificationTokenAdderApi(
          api.user,
          FirebaseMessaging.instance,
          widget.blocDependencies.remoteConfiguration.getString(
            'firebase_messaging_vapid_key',
          ),
        ),
      ).addTokenToUserIfNotExisting();
    }
    final firestore = api.references.firestore;
    final firebaseAuth = api.references.firebaseAuth!;
    final homeworkCollection = firestore.collection("Homework");
    final uid = api.uID;
    final crashAnalytics = getCrashAnalytics();
    final homeworkApi = createDefaultFirestoreRepositories(
      homeworkCollection,
      uid,
      (courseId) => getCourseData(api, courseId.value),
    );

    final config = HausaufgabenheftConfig(
      // ignore: deprecated_member_use
      defaultCourseColorValue: Colors.lightBlue.value,
      nrOfInitialCompletedHomeworksToLoad:
          // Falls zu wenig Hausaufgaben am Anfang geladen werden, sodass die
          // Erledigte-HA-Seite durch zu wenig ursprünglich geladenen HAs nicht
          // scrollbar ist, dann werden keine weiteren erldigten HAs
          // nachgeladen. Da auf Tablets/Desktop/Web mehr Platz ist, sollte man
          // da am Anfang mehr Hausaufgaben laden. Tablets kann man allerdings
          // nur schlecht von mobile unterscheiden (bei Apple beides iOS) und
          // über die HA-Karten-Größe (muss ich dann hard-coden) will ich die
          // Anzahl nicht berechnen, damit es nicht bei einem Redesign zu
          // Verwirrung kommt. Da die erledigten HAs eh nur geladen werden, wenn
          // man wirklich auf den Tab switched, hard-code ich jetzt erstmal den
          // Wert.
          // Das ist nur ein Workaround und der Fehler sollte mit
          // https://gitlab.com/codingbrain/sharezone/sharezone-app/-/issues/1069
          // richtig gefixt werden.
          20,
    );
    final dependencies = HausaufgabenheftDependencies(
      api: homeworkApi,
      keyValueStore: widget.blocDependencies.keyValueStore,
    );
    final homeworkPageBloc = createStudentHomeworkPageBloc(
      dependencies,
      config,
    );
    // Not sure if we need to call both, but without .close the linter complains
    _disposeCallbacks.add(homeworkPageBloc.dispose);
    _disposeCallbacks.add(homeworkPageBloc.close);
    final teacherHomeworkBloc = createTeacherAndParentHomeworkPageBloc(
      dependencies,
      config,
    );
    // Not sure if we need to call both, but without .close the linter complains
    _disposeCallbacks.add(teacherHomeworkBloc.dispose);
    _disposeCallbacks.add(teacherHomeworkBloc.close);

    final timetableBloc = TimetableBloc(
      api.schoolClassGateway,
      api.user,
      api.timetable,
      api.course,
      SchoolClassFilterAnalytics(analytics),
    );

    final markdownAnalytics = MarkdownAnalytics(Analytics(getBackend()));

    var abgabenGateway = FirestoreAbgabeGateway(
      firestore: firestore,
      submissionReviewCollection: firestore.collection(
        'Submissions/review/submissions',
      ),
      submissionCreationCollection: firestore.collection(
        'Submissions/create/submissions',
      ),
      courseCollection: firestore.collection('Courses'),
      homeworkCollection: firestore.collection('Homework'),
      userId: UserId(uid),
    );

    final remoteConfig = widget.blocDependencies.remoteConfiguration;
    final abgabenServiceBaseUrl = remoteConfig.getString(
      'abgaben_service_base_url',
    );
    // Im Web muss die Url zum lokalen Testen manuell gesetzt werden, weil Remote Config noch nicht geht
    // 'https://dev.api.sharezone.net';
    // 'http://localhost:8080';
    // Url für lokales Debuggen mit Android-Emulator (10.0.2.2 entspricht localhost des emulator hosts)
    // 'http://10.0.2.2:8080';
    final abgabenBucketName = remoteConfig.getString('abgaben_bucket_name');
    // Im Web muss der Bucket-Name zum lokalen Testen manuell gesetzt werden, weil Remote Config noch nicht geht
    // 'sharezone-debug-submissions';
    final abgabeHttpApi = AbgabeHttpApi();
    var baseOptions = BaseOptions(
      baseUrl: abgabenServiceBaseUrl,

      /// Cold-Start kann manchmal dauern
      connectTimeout: const Duration(seconds: 45),
    );
    abgabeHttpApi.dio = Dio(baseOptions);
    var firebaseAuthTokenRetriever = FirebaseAuthTokenRetrieverImpl(
      widget.blocDependencies.authUser!.firebaseUser,
    );

    final signUpBloc = BlocProvider.of<SignUpBloc>(context);

    final typeOfUserStream = api.user.userStream.map(
      (user) => user!.typeOfUser,
    );
    final onboardingNavigator = OnboardingNavigator(
      signUpBloc,
      widget.beitrittsversuche!,
    );

    final holidayApiClient = CloudFunctionHolidayApiClient(
      api.references.functions,
    );

    const clock = Clock();
    final subscriptionService = SubscriptionService(
      user: api.user.userStream,
      functions: widget.blocDependencies.functions,
    );
    trySetSharezonePlusAnalyticsUserProperties(
      analytics,
      crashAnalytics,
      subscriptionService,
    );

    final feedbackApi = FirebaseFeedbackApi(firestore);

    final userDocRef = api.references.users.doc(api.uID);
    final gradesService = GradesService(
      repository: FirestoreGradesStateRepository(userDocumentRef: userDocRef),
    );

    final iCalLinksGateway = ICalLinksGateway(
      firestore: widget.blocDependencies.firestore,
      functions: widget.blocDependencies.functions,
    );

    final keyValueStore = FlutterKeyValueStore(
      widget.blocDependencies.sharedPreferences,
    );

    // In the past we used BlocProvider for everything (even non-bloc classes).
    // This forced us to use BlocProvider wrapper classes for non-bloc entities,
    // Provider allows us to skip using these wrapper classes.
    providers = [
      Provider<Analytics>(create: (context) => analytics),
      Provider<CrashAnalytics>(create: (context) => crashAnalytics),
      Provider<SubscriptionService>(create: (context) => subscriptionService),
      StreamProvider<auth.AuthUser?>(
        create: (context) => api.user.authUserStream,
        initialData: null,
      ),
      ChangeNotifierProvider(
        create:
            (context) => SharezonePlusPageController(
              buyingFlagApi: BuyingEnabledApi(client: http.Client()),
              userId: UserId(api.uID),
              purchaseService: RevenueCatPurchaseService(),
              subscriptionService: subscriptionService,
              crashAnalytics: crashAnalytics,
              analytics: SharezonePlusPageAnalytics(analytics),
              stripeCheckoutSession: StripeCheckoutSession(
                createCheckoutSessionFunctionUrl: widget
                    .blocDependencies
                    .remoteConfiguration
                    .getString('stripe_checkout_session_function_url'),
                client: http.Client(),
              ),
            ),
      ),
      ChangeNotifierProvider(
        create:
            (context) => SupportPageController(
              userNameStream: api.user.userStream.map((user) => user?.name),
              userIdStream: api.user.authUserStream.map(
                (user) => user == null ? null : UserId(user.uid),
              ),
              userEmailStream: api.user.authUserStream.map(
                (user) => user?.email,
              ),
              hasPlusSupportUnlockedStream: subscriptionService
                  .hasFeatureUnlockedStream(SharezonePlusFeature.plusSupport),
              isUserInGroupOnboardingStream: signUpBloc.signedUp,
              typeOfUserStream: typeOfUserStream,
              urlLauncher: UrlLauncherExtended(),
            ),
      ),
      StreamProvider<TypeOfUser?>.value(
        value: typeOfUserStream,
        initialData: null,
      ),
      ChangeNotifierProvider(
        create:
            (context) => ChangeTypeOfUserController(
              service: ChangeTypeOfUserService(
                functions: widget.blocDependencies.functions,
              ),
              typeOfUserStream: typeOfUserStream,
              analytics: ChangeTypeOfUserAnalytics(analytics),
              userId: UserId(api.uID),
            ),
      ),
      Provider(
        create:
            (context) => PastCalendricalEventsPageControllerFactory(
              clock: clock,
              subscriptionService: subscriptionService,
              timetableGateway: api.timetable,
              courseGateway: api.course,
              schoolClassGateway: api.schoolClassGateway,
              analytics: PastCalendricalEventsPageAnalytics(analytics),
            ),
      ),
      ChangeNotifierProvider(
        create:
            (context) => FeedbackHistoryPageController(
              analytics: FeedbackHistoryPageAnalytics(analytics),
              api: feedbackApi,
              userId: api.userId,
              crashAnalytics: crashAnalytics,
            ),
      ),
      Provider(
        create:
            (context) => FeedbackDetailsPageControllerFactory(
              userId: api.userId,
              feedbackApi: feedbackApi,
              crashAnalytics: crashAnalytics,
            ),
      ),
      Provider(
        create:
            (context) => ICalLinksDialogControllerFactory(
              gateway: iCalLinksGateway,
              analytics: ICalLinksAnalytics(analytics),
              userId: api.userId,
            ),
      ),
      ChangeNotifierProvider(
        create:
            (context) => HasUnreadFeedbackMessagesProvider(
              feedbackApi: feedbackApi,
              userId: api.userId,
            ),
      ),
      Provider<GradesService>(create: (context) => gradesService),
      ChangeNotifierProvider(
        create: (context) => GradesPageController(gradesService: gradesService),
      ),
      StreamProvider<TypeOfUser>(
        create: (context) => typeOfUserStream,
        initialData: TypeOfUser.unknown,
      ),
      Provider(
        create:
            (context) => TermDetailsPageControllerFactory(
              gradesService: gradesService,
              crashAnalytics: crashAnalytics,
              analytics: analytics,
            ),
      ),
      Provider(
        create:
            (context) => GradeDetailsPageControllerFactory(
              gradesService: gradesService,
              crashAnalytics: crashAnalytics,
              analytics: analytics,
            ),
      ),
      Provider(
        create:
            (context) => GradesDialogControllerFactory(
              crashAnalytics: crashAnalytics,
              gradesService: gradesService,
              coursesStream: () => api.course.streamCourses(),
              analytics: analytics,
            ),
      ),
      ChangeNotifierProvider(
        create:
            (context) => IcalLinksPageController(
              gateway: iCalLinksGateway,
              userId: api.userId,
            ),
      ),
      Provider(
        create:
            (context) => TermSettingsPageControllerFactory(
              gradesService: gradesService,
              coursesStream: () => api.course.streamCourses(),
            ),
      ),
      Provider(
        create:
            (context) => SubstitutionController(
              gateway: api.timetable,
              analytics: analytics,
              userId: api.userId,
              courseMemberAccessor: FirestoreCourseMemberAccessor(
                api.references.firestore,
              ),
            ),
      ),
      ChangeNotifierProvider(
        create:
            (context) => AdsController(
              subscriptionService: subscriptionService,
              remoteConfiguration: widget.blocDependencies.remoteConfiguration,
              keyValueStore: keyValueStore,
            ),
        lazy: false,
      ),
      Provider<KeyValueStore>.value(value: keyValueStore),
    ];

    mainBlocProviders = <BlocProvider>[
      BlocProvider<SharezoneContext>(
        bloc: SharezoneContext(
          api,
          widget.blocDependencies.streamingSharedPreferences,
          widget.blocDependencies.sharedPreferences,
          widget.navigationService!,
          analytics,
        ),
      ),
      BlocProvider<TypeOfUserBloc>(bloc: TypeOfUserBloc(typeOfUserStream)),
      BlocProvider<BlackboardPageBloc>(
        bloc: BlackboardPageBloc(
          gateway: api.blackboard,
          courseGateway: api.course,
          uid: api.uID,
        ),
      ),
      BlocProvider<DashboardBloc>(
        bloc: DashboardBloc(
          api.uID,
          DashboardGateway(
            api.homework,
            api.blackboard,
            api.timetable,
            api.course,
            api.schoolClassGateway,
            api.user,
          ),
          timetableBloc,
        ),
      ),
      BlocProvider<UpdateReminderBloc>(
        bloc: UpdateReminderBloc(
          platformInformationRetriever: FlutterPlatformInformationRetriever(),
          changelogGateway: ChangelogGateway(firestore: firestore),
          crashAnalytics: getCrashAnalytics(),
          updateGracePeriod: const Duration(days: 3),
        ),
      ),
      BlocProvider<DashboardTipSystem>(
        bloc: DashboardTipSystem(
          cache: DashboardTipCache(streamingKeyValueStore),
          navigationBloc: navigationBloc,
          userTipsBloc: UserTipsBloc(api.user),
        ),
      ),
      BlocProvider<CalendricalEventsPageBlocFactory>(
        bloc: CalendricalEventsPageBlocFactory(
          api.timetable,
          api.course,
          api.schoolClassGateway,
          CalendricalEventsPageCache(
            FlutterKeyValueStore(widget.blocDependencies.sharedPreferences),
          ),
          CalendricalEventsPageAnalytics(analytics),
        ),
      ),
      BlocProvider<AccountPageBlocFactory>(
        bloc: AccountPageBlocFactory(api.user),
      ),
      BlocProvider<BlackboardAnalytics>(bloc: BlackboardAnalytics(analytics)),
      BlocProvider<NavigationExperimentCache>(
        bloc: NavigationExperimentCache(
          FlutterStreamingKeyValueStore(
            widget.blocDependencies.streamingSharedPreferences,
          ),
        ),
      ),
      BlocProvider<OverdueHomeworkDialogDismissedCache>(
        bloc: OverdueHomeworkDialogDismissedCache(InMemoryKeyValueStore()),
      ),
      BlocProvider<ViewSubmissionsPageBlocFactory>(
        bloc: ViewSubmissionsPageBlocFactory(
          gateway: abgabenGateway,
          nutzerId: UserId(uid),
        ),
      ),
      BlocProvider<BnbTutorialBloc>(
        bloc: BnbTutorialBloc(
          BnbTutorialCache(
            FlutterKeyValueStore(widget.blocDependencies.sharedPreferences),
          ),
          BnbTutorialAnalytics(analytics),
          onboardingNavigator.showOnboarding.map((shouldShown) => !shouldShown),
        ),
      ),
      BlocProvider<HomeworkUserCreateSubmissionsBlocFactory>(
        bloc: HomeworkUserCreateSubmissionsBlocFactory(
          uploader: CloudStorageAbgabedateiUploader(
            getFileUploader(),
            abgabeHttpApi.getAbgabedateiApi(),
            crashAnalytics,
            CloudStorageBucket(abgabenBucketName),
            HttpAbgabedateiHinzufueger(
              abgabeHttpApi.getAbgabedateiApi(),
              FirebaseAuthHeaderRetriever(firebaseAuthTokenRetriever),
            ),
          ),
          authTokenRetriever: firebaseAuthTokenRetriever,
          saver: SingletonLocalFileSaver(),
          recordError: crashAnalytics.recordError,
          userId: api.uID,
          gateway: abgabenGateway,
          abgabeHttpApi: abgabeHttpApi,
        ),
      ),
      BlocProvider<GroupAnalytics>(bloc: GroupAnalytics(analytics)),
      BlocProvider<EnterActivationCodeBlocFactory>(
        bloc: EnterActivationCodeBlocFactory(
          crashAnalytics: crashAnalytics,
          analytics: analytics,
          appFunctions: api.references.functions,
          keyValueStore: widget.blocDependencies.keyValueStore,
          featureFlagl10n: context.read<FeatureFlagl10n>(),
        ),
      ),
      BlocProvider<NotificationsBlocFactory>(
        bloc: NotificationsBlocFactory(api.user),
      ),
      BlocProvider<DownloadAppTipBloc>(
        bloc: DownloadAppTipBloc(
          DownloadAppTipCache(
            FlutterStreamingKeyValueStore(
              widget.blocDependencies.streamingSharedPreferences,
            ),
          ),
          DownloadAppTipAnalytics(analytics),
        ),
      ),
      BlocProvider<NavigationAnalytics>(bloc: NavigationAnalytics(analytics)),
      BlocProvider<TeacherAndParentHomeworkPageBloc>(bloc: teacherHomeworkBloc),
      BlocProvider<StudentHomeworkPageBloc>(bloc: homeworkPageBloc),
      BlocProvider<NavigationService>(bloc: widget.navigationService!),
      BlocProvider<UserTipsBloc>(bloc: UserTipsBloc(api.user)),
      BlocProvider<LessonLengthCache>(bloc: lessonLengthCache),
      BlocProvider<HomeworkCompletionUserListBlocFactory>(
        bloc: HomeworkCompletionUserListBlocFactory(
          api.homework,
          api.references.courses,
          HomeworkAnalytics(analytics),
        ),
      ),
      BlocProvider<UserSettingsBloc>(bloc: UserSettingsBloc(api.user)),
      BlocProvider<ImprintAnalytics>(bloc: ImprintAnalytics(analytics)),
      BlocProvider<OnboardingNavigator>(bloc: onboardingNavigator),
      BlocProvider<GroupOnboardingBloc>(
        bloc: GroupOnboardingBloc(
          api.course,
          api.schoolClassGateway,
          signUpBloc,
          GroupOnboardingAnalytics(analytics),
          widget.beitrittsversuche as Stream<Beitrittsversuch?>,
        ),
      ),
      BlocProvider<RegistrationBloc>(
        bloc: RegistrationBloc(
          widget.blocDependencies.registrationGateway,
          signUpBloc,
        ),
      ),
      BlocProvider<ReportFactory>(
        bloc: ReportFactory(
          uid: api.uID,
          firestore: widget.blocDependencies.firestore,
        ),
      ),
      BlocProvider<ReportGateway>(
        bloc: ReportGateway(widget.blocDependencies.firestore),
      ),
      BlocProvider<FeedbackBloc>(bloc: feedbackBloc),
      BlocProvider<MarkdownAnalytics>(bloc: markdownAnalytics),
      BlocProvider<CommentsBlocFactory>(
        bloc: CommentsBlocFactory(
          CommentsGateway(api.references.firestore),
          api.user.userStream,
          CommentViewFactory(courseGateway: api.course, uid: api.uID),
          CommentsAnalytics(Analytics(getBackend())),
        ),
      ),
      BlocProvider<HomeworkDetailsViewFactory>(
        bloc: HomeworkDetailsViewFactory(
          uid: api.uID,
          courseGateway: api.course,
          fileSharingGateway: api.fileSharing,
          typeOfUserStream: typeOfUserStream,
          subscriptionService: subscriptionService,
        ),
      ),
      BlocProvider<ChangeDataBloc>(
        bloc: ChangeDataBloc(
          userAPI: api.user,
          currentEmail: api.user.authUser!.email,
          firebaseAuth: firebaseAuth,
        ),
      ),
      BlocProvider<HolidayBloc>(
        bloc: HolidayBloc(
          stateGateway: HolidayStateGateway.fromUserGateway(api.user),
          holidayManager: HolidayService(
            HolidayApi(holidayApiClient, getCurrentTime: () => clock.now()),
            HolidayCache(
              FlutterKeyValueStore(widget.blocDependencies.sharedPreferences),
            ),
          ),
        ),
      ),
      BlocProvider<CourseCreateBlocFactory>(
        bloc: CourseCreateBlocFactory(
          CourseCreateGateway(
            api.course,
            api.user,
            api.schoolClassGateway,
            api.connectionsGateway,
          ),
          CourseCreateAnalytics(Analytics(getBackend())),
        ),
      ),
    ];

    timetableProviders = [
      BlocProvider<TimetableBloc>(bloc: timetableBloc),
      BlocProvider<TimetableAddBlocFactory>(
        bloc: TimetableAddBlocFactory(
          TimetableAddBlocDependencies(
            gateway: api.timetable,
            lessonLengthCache: lessonLengthCache,
          ),
        ),
      ),
      BlocProvider<TimetableSettingsBlocFactory>(
        bloc: TimetableSettingsBlocFactory(
          lessonLengthCache,
          timePickerSettingsCache,
        ),
      ),
      BlocProvider<TimePickerSettingsCache>(bloc: timePickerSettingsCache),
    ];
  }

  final _disposeCallbacks = <void Function()>[];

  @override
  void dispose() {
    for (final disposeCallback in _disposeCallbacks) {
      disposeCallback();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: providers,
      child: MultiBlocProvider(
        key: const ValueKey("MultiBlocProvider"),
        blocProviders: [...mainBlocProviders, ...timetableProviders],
        child:
            (context) => AnalyticsProvider(
              analytics: analytics,
              child: Builder(builder: (context) => widget.child),
            ),
      ),
    );
  }

  Future<({int colorHexValue, bool isAdmin})> getCourseData(
    SharezoneGateway api,
    String courseId,
  ) async {
    final course = api.course.getCourse(courseId)!;
    final role = _getMemberRole(api.connectionsGateway, courseId);
    final isAdmin = role == MemberRole.admin || role == MemberRole.owner;
    // ignore: deprecated_member_use
    return (colorHexValue: course.getDesign().color.value, isAdmin: isAdmin);
  }

  MemberRole? _getMemberRole(ConnectionsGateway gateway, String courseID) {
    final connectionsData = gateway.current();
    if (connectionsData != null) {
      final courses = connectionsData.courses;
      return courses[courseID]?.myRole;
    }
    return MemberRole.none;
  }
}
