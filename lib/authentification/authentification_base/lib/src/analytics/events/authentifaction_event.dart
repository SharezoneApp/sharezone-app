// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:meta/meta.dart';
import 'package:analytics/analytics.dart';
import 'package:sharezone_common/helper_functions.dart';

class AuthentifactionEvent extends AnalyticsEvent {
  AuthentifactionEvent({@required this.provider, @required String name})
      : assert(isNotEmptyOrNull(provider)),
        super(name);

  final String provider;

  @override
  Map<String, dynamic> get data => {"${name}With": provider};
}
