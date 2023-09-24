// Copyright (c) 2023 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:flutter/material.dart';
import 'package:sharezone_website/widgets/translate_on_hover.dart';

extension HoverExtensions on Widget {
  Widget get moveLeftOnHover {
    return MoveLeftOnHover(child: this);
  }
}
