// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:authentification_base/authentification.dart';

class DemoUser extends AuthUser {
  @override
  String get uid => "testUser";

  @override
  String get email => "test@sharezone.net";

  @override
  bool get isAnonymous => true;
}
