// Copyright (c) 2023 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:flutter/foundation.dart';

/// Widget keys, used for integration tests.
class K {
  static const goToLoginButton = Key('go-to-login-button-E2E');
  static const emailTextField = Key('email-text-field-E2E');
  static const passwordTextField = Key('password-text-field-E2E');
  static const loginButton = Key('login-button-E2E');
  static const dashboardAppBarTitle = Key('dashboard-appbar-title-E2E');
  static const groupsNavigationItem = Key('nav-item-groups-E2E');
  static const timetableNavigationItem = Key('nav-item-timetable-E2E');
  static const blackboardNavigationItem = Key('nav-item-blackboard-E2E');
}
