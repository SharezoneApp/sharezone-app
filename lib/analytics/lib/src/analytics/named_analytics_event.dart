// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:meta/meta.dart';
import 'package:sharezone_common/helper_functions.dart';
import '../../analytics.dart';

class NamedAnalyticsEvent extends AnalyticsEvent {
  NamedAnalyticsEvent({
    @required String name,
    Map<String, dynamic> data,
  })  : assert(isNotEmptyOrNull(name)),
        super(name, data: data);
}
