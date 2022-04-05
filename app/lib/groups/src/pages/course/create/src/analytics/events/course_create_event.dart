// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:analytics/analytics.dart';
import 'package:meta/meta.dart';
import 'package:sharezone_common/helper_functions.dart';

const groupPage = "group-page";
const schoolClassPage = "school-class-page";

class CourseCreateEvent extends AnalyticsEvent {
  CourseCreateEvent({
    @required this.subject,
    @required String name,
    @required this.type,
    @required this.via,
  })  : assert(isNotEmptyOrNull(subject) && isNotEmptyOrNull(type)),
        super(name);

  final String subject, type, via;

  @override
  Map<String, dynamic> get data => {
        'subject': subject,
        'type': type,
        'via': via,
      };
}
