// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'dart:async';

import 'package:analytics/analytics.dart';
import 'package:authentification_base/authentification.dart' hide Provider;
import 'package:authentification_base/authentification_base.dart' hide Provider;
import 'package:bloc_provider/bloc_provider.dart';
import 'package:bloc_provider/multi_bloc_provider.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:platform_check/platform_check.dart';
import 'package:provider/provider.dart';
import 'package:sharezone/dynamic_links/beitrittsversuch.dart';
import 'package:sharezone/dynamic_links/dynamic_link_bloc.dart';
import 'package:sharezone/dynamic_links/dynamic_links.dart';
import 'package:sharezone/l10n/feature_flag_l10n.dart';
import 'package:sharezone/l10n/flutter_app_local_gateway.dart';
import 'package:sharezone/main/auth_app.dart';
import 'package:sharezone/main/bloc_dependencies.dart';
import 'package:sharezone/main/sharezone_app.dart';
import 'package:sharezone/main/sharezone_bloc_providers.dart';
import 'package:sharezone/navigation/logic/navigation_bloc.dart';
import 'package:sharezone/notifications/notifications_permission.dart';
import 'package:sharezone/onboarding/group_onboarding/logic/signed_up_bloc.dart';
import 'package:sharezone/util/cache/streaming_key_value_store.dart';
import 'package:sharezone/util/flavor.dart';
import 'package:sharezone/widgets/animation/color_fade_in.dart';
import 'package:sharezone/widgets/development_stage_banner.dart';
import 'package:sharezone_localizations/sharezone_localizations.dart';
import 'package:sharezone_utils/device_information_manager.dart';
import 'package:sharezone_widgets/sharezone_widgets.dart';

/// Defines if the app is running in integration test mode.
///
/// This is used to disable some features, which are not working for integration
/// tests. These features are:
/// * Firebase Messaging (throws SERVICE_NOT_AVAILABLE or AUTHENTICATION_FAILED
///   when running on device farm devices, see
///   https://github.com/SharezoneApp/sharezone-app/issues/420)
/// * Ignore Remote Config fetch failures on Android
bool isIntegrationTest = false;

/// StreamBuilder "above" the Auth and SharezoneApp.
/// Reasoning is that if the user logged out,
/// he will always be in the log in screen.
class Sharezone extends StatefulWidget {
  final BlocDependencies blocDependencies;
  final DynamicLinkBloc dynamicLinkBloc;
  final Stream<Beitrittsversuch?> beitrittsversuche;
  final Flavor flavor;
  final bool isIntegrationTest;

  const Sharezone({
    super.key,
    required this.blocDependencies,
    required this.dynamicLinkBloc,
    required this.beitrittsversuche,
    required this.flavor,
    this.isIntegrationTest = false,
  });

  static Analytics analytics = Analytics(getBackend());

  @override
  State createState() => _SharezoneState();
}

class _SharezoneState extends State<Sharezone> with WidgetsBindingObserver {
  late SignUpBloc signUpBloc;
  late StreamSubscription<AuthUser?> authSubscription;
  late StreamingKeyValueStore streamingKeyValueStore;
  late FeatureFlagl10n featureFlagl10n;

  @override
  void initState() {
    super.initState();

    isIntegrationTest = widget.isIntegrationTest;
    signUpBloc = SignUpBloc();

    // You have to wait a little moment (1000 milliseconds), to
    // catch a dynmaic link from cold apps start on ios.
    // widget.dynamicLinkBloc.initialisere();
    WidgetsBinding.instance.addObserver(this);
    Future.delayed(const Duration(milliseconds: 1000)).then((_) {
      widget.dynamicLinkBloc.initialisere();
    });

    logAppOpen();

    authSubscription = listenToAuthStateChanged().listen((user) {
      authUserSubject.sink.add(user);
    });

    streamingKeyValueStore = FlutterStreamingKeyValueStore(
      widget.blocDependencies.streamingSharedPreferences,
    );
    featureFlagl10n = FeatureFlagl10n(streamingKeyValueStore);
  }

  void logAppOpen() {
    Sharezone.analytics.log(NamedAnalyticsEvent(name: 'app_open'));
  }

  @override
  void dispose() {
    authSubscription.cancel();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return OverlaySupport(
      child: DynamicLinkOverlay(
        einkommendeLinks: widget.dynamicLinkBloc.einkommendeLinks,
        child: ColorFadeIn(
          color: PlatformCheck.isWeb ? Colors.white : primaryColor,
          child: Directionality(
            textDirection: TextDirection.ltr,
            child: _ThemeSettingsProvider(
              blocDependencies: widget.blocDependencies,
              child: DevelopmentStageBanner(
                child: Stack(
                  children: [
                    MultiProvider(
                      providers: [
                        Provider<NotificationsPermission>(
                          create:
                              (_) => NotificationsPermission(
                                firebaseMessaging: FirebaseMessaging.instance,
                                mobileDeviceInformationRetriever:
                                    MobileDeviceInformationRetriever(),
                              ),
                        ),
                        ChangeNotifierProvider.value(value: featureFlagl10n),
                        ChangeNotifierProvider(
                          create:
                              (context) => AppLocaleProvider(
                                gateway: FlutterAppLocaleProviderGateway(
                                  keyValueStore: streamingKeyValueStore,
                                  featureFlagl10n: featureFlagl10n,
                                ),
                              ),
                        ),
                      ],
                      child: MultiBlocProvider(
                        blocProviders: [
                          BlocProvider<SignUpBloc>(bloc: signUpBloc),
                          // We need to provide the navigation bloc above the
                          // [SharezoneApp] widget to prevent disposing the
                          // navigation bloc when signing out.
                          //
                          // See
                          // https://github.com/SharezoneApp/sharezone-app/issues/117.
                          BlocProvider<NavigationBloc>(bloc: navigationBloc),
                        ],
                        child:
                            (context) => MultiProvider(
                              providers: [
                                Provider<Flavor>(
                                  create: (context) => widget.flavor,
                                ),
                              ],
                              child: StreamBuilder<AuthUser?>(
                                stream: authUserStream,
                                builder: (context, snapshot) {
                                  if (snapshot.hasData) {
                                    widget.blocDependencies.authUser =
                                        snapshot.data;
                                    return SharezoneApp(
                                      widget.blocDependencies,
                                      Sharezone.analytics,
                                      widget.beitrittsversuche,
                                    );
                                  }
                                  return AuthApp(
                                    blocDependencies: widget.blocDependencies,
                                    analytics: Sharezone.analytics,
                                  );
                                },
                              ),
                            ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ThemeSettingsProvider extends StatelessWidget {
  const _ThemeSettingsProvider({this.child, this.blocDependencies});

  final Widget? child;
  final BlocDependencies? blocDependencies;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create:
          (context) => ThemeSettings(
            analytics: blocDependencies!.analytics,
            defaultTextScalingFactor: 1.0,
            defaultThemeBrightness: ThemeBrightness.system,
            // We don't use VisualDensitySetting.adaptivePlatformDensity() because
            // we don't like the button densities on the desktop.
            defaultVisualDensity: VisualDensitySetting.standard(),
            keyValueStore: blocDependencies!.keyValueStore,
          ),
      child: Consumer<ThemeSettings>(
        builder: (context, themeSettings, _) {
          /// If we didn't use MediaQuery.fromWindow and just provide a new
          /// MediaQuery with our custom textScalingFactor the UI breaks in
          /// several different weird ways.
          /// Thus we use MediaQuery.fromWindow which is the method that Flutter
          /// uses internally inside MaterialApp etc to create a new MediaQuery.
          return MediaQuery.fromView(
            view: View.of(context),
            child: Builder(
              builder: (context) {
                return MediaQuery(
                  data: MediaQuery.of(context).copyWith(
                    textScaler: TextScaler.linear(
                      themeSettings.textScalingFactor,
                    ),
                  ),
                  child: Theme(
                    data: Theme.of(context).copyWith(
                      visualDensity:
                          themeSettings.visualDensitySetting.visualDensity,
                    ),
                    child: child!,
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
