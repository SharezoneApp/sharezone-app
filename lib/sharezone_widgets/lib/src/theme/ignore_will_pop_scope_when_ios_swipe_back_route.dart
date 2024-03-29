// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:flutter/material.dart';

class IgnoreWillPopScopeWhenIosSwipeBackRoute<T> extends MaterialPageRoute<T> {
  @override
  @protected
  bool get hasScopedWillPopCallback {
    return false;
  }

  IgnoreWillPopScopeWhenIosSwipeBackRoute({
    required super.builder,
    super.settings,
    super.maintainState,
    super.fullscreenDialog,
  });
}
