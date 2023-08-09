// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:flutter/material.dart';

class LongPress<T> {
  final String title;
  final T popResult;
  final Widget? icon;

  const LongPress({
    required this.title,
    required this.popResult,
    this.icon,
  });
}
