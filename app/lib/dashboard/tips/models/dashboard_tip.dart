// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'action.dart';

abstract class DashboardTip {
  final String title;
  final String text;
  final Action action;

  DashboardTip(this.title, this.text, this.action);

  Stream<bool> shouldShown();
  void markAsShown();
}
