// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:group_domain_models/group_domain_models.dart';

class CourseTemplate {
  final String subject;
  final String abbreviation;

  Course toCourse() {
    return Course.create()
        .copyWith(subject: subject, abbreviation: abbreviation);
  }

  const CourseTemplate(this.subject, this.abbreviation);
}
