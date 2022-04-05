// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:analytics/analytics.dart';
import 'package:app_functions/sharezone_app_functions.dart';
import 'package:bloc_base/bloc_base.dart';
import 'package:crash_analytics/crash_analytics.dart';
import 'package:meta/meta.dart';
import 'package:sharezone/activation_code/src/bloc/enter_activation_code_bloc.dart';

class EnterActivationCodeBlocFactory extends BlocBase {
  final CrashAnalytics crashAnalytics;
  final Analytics analytics;
  final SharezoneAppFunctions appFunctions;

  EnterActivationCodeBlocFactory({
    @required this.analytics,
    @required this.crashAnalytics,
    @required this.appFunctions,
  });

  EnterActivationCodeBloc createBloc() {
    return EnterActivationCodeBloc(analytics, crashAnalytics, appFunctions);
  }

  @override
  void dispose() {}
}
