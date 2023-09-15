// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:analytics/analytics.dart';
import 'package:bloc_provider/bloc_provider.dart';
import 'package:bloc_provider/multi_bloc_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sharezone/auth/login_page.dart';
import 'package:sharezone/auth/sign_in_with_qr_code_page.dart';
import 'package:sharezone/blocs/bloc_dependencies.dart';
import 'package:sharezone/download_app_tip/analytics/download_app_tip_analytics.dart';
import 'package:sharezone/download_app_tip/bloc/download_app_tip_bloc.dart';
import 'package:sharezone/download_app_tip/cache/download_app_tip_cache.dart';
import 'package:sharezone/main/sharezone_material_app.dart';
import 'package:sharezone/onboarding/bloc/registration_bloc.dart';
import 'package:sharezone/onboarding/group_onboarding/logic/signed_up_bloc.dart';
import 'package:sharezone/onboarding/sign_up/sign_up_page.dart';
import 'package:sharezone/onboarding/welcome_page.dart';
import 'package:sharezone/pages/settings/src/subpages/imprint/analytics/imprint_analytics.dart';
import 'package:sharezone/pages/settings/src/subpages/imprint/bloc/imprint_bloc_factory.dart';
import 'package:sharezone/pages/settings/src/subpages/imprint/gateway/imprint_gateway.dart';
import 'package:sharezone/pages/settings/src/subpages/imprint/page/imprint_page.dart';
import 'package:sharezone/support/support_page.dart';
import 'package:sharezone/privacy_policy/privacy_policy_page.dart';
import 'package:sharezone/support/support_page_controller.dart';
import 'package:sharezone/util/cache/streaming_key_value_store.dart';

class AuthApp extends StatefulWidget {
  final Analytics analytics;
  final BlocDependencies blocDependencies;

  const AuthApp({
    Key? key,
    required this.analytics,
    required this.blocDependencies,
  }) : super(key: key);

  @override
  State createState() => _AuthAppState();
}

class _AuthAppState extends State<AuthApp> {
  late RegistrationBloc bloc;

  @override
  void initState() {
    super.initState();
    final controller = BlocProvider.of<SignUpBloc>(context);
    bloc = RegistrationBloc(
        widget.blocDependencies.registrationGateway, controller);
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => SupportPageController(
            // Inside the [AuthApp] the user can't be signed in and can't have
            // Sharezone Plus.
            isUserSignedInStream: Stream.value(false),
            hasPlusSupportUnlockedStream: Stream.value(false),
          ),
        ),
      ],
      child: MultiBlocProvider(
        blocProviders: [
          BlocProvider<DownloadAppTipBloc>(
            bloc: DownloadAppTipBloc(
              DownloadAppTipCache(
                FlutterStreamingKeyValueStore(
                    widget.blocDependencies.streamingSharedPreferences),
              ),
              DownloadAppTipAnalytics(widget.analytics),
            ),
          ),
          BlocProvider<RegistrationBloc>(bloc: bloc),
          BlocProvider<ImprintBlocFactory>(
            bloc: ImprintBlocFactory(
              ImprintGateway(widget.blocDependencies.firestore),
            ),
          ),
          BlocProvider<ImprintAnalytics>(
              bloc: ImprintAnalytics(widget.analytics)),
        ],
        child: (context) => SharezoneMaterialApp(
          blocDependencies: widget.blocDependencies,
          home: const WelcomePage(),
          onUnknownRouteWidget: const WelcomePage(),
          analytics: widget.analytics,
          navigatorKey: null,
          routes: {
            SignUpPage.tag: (context) => const SignUpPage(),
            LoginPage.tag: (context) => const LoginPage(),
            PrivacyPolicyPage.tag: (context) => PrivacyPolicyPage(),
            SignInWithQrCodePage.tag: (context) => const SignInWithQrCodePage(),
            ImprintPage.tag: (context) => const ImprintPage(),
          },
        ),
      ),
    );
  }
}
