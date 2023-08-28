// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

//@dart=2.12

import 'package:analytics/analytics.dart';
import 'package:app_functions/sharezone_app_functions.dart';
import 'package:bloc_base/bloc_base.dart';
import 'package:crash_analytics/crash_analytics.dart';
import 'package:key_value_store/key_value_store.dart';
import 'package:sharezone/activation_code/src/bloc/enter_activation_code_bloc.dart';

import '../../../sharezone_plus/subscription_service/subscription_flag.dart';

class EnterActivationCodeBlocFactory extends BlocBase {
  final CrashAnalytics crashAnalytics;
  final Analytics analytics;
  final SharezoneAppFunctions appFunctions;
  final SubscriptionEnabledFlag subscriptionEnabledFlag;
  final KeyValueStore keyValueStore;

  EnterActivationCodeBlocFactory({
    required this.analytics,
    required this.crashAnalytics,
    required this.appFunctions,
    required this.subscriptionEnabledFlag,
    required this.keyValueStore,
  });

  EnterActivationCodeBloc createBloc() {
    return EnterActivationCodeBloc(
      analytics,
      crashAnalytics,
      appFunctions,
      subscriptionEnabledFlag,
      keyValueStore,
    );
  }

  @override
  void dispose() {}
}
