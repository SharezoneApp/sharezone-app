// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:sharezone/timetable/timetable_page/school_class_filter/school_class_filter_analytics.dart';

class MockSchoolClassFilterAnalytics implements SchoolClassFilterAnalytics {
  bool loggedSelectedASpecificSchoolClass = false;
  bool loggedSelectedToShowAllGroups = false;

  @override
  void logFilterBySchoolClass() {
    loggedSelectedASpecificSchoolClass = true;
  }

  @override
  void logShowAllGroups() {
    loggedSelectedToShowAllGroups = true;
  }
}
