// Copyright (c) 2024 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:sharezone/report/report_item.dart';
import 'package:sharezone/report/report_reason.dart';
import 'package:sharezone_localizations/sharezone_localizations.dart';

extension ReportLocalizations on SharezoneLocalizations {
  String reportReasonLabel(ReportReason reason) {
    return switch (reason) {
      ReportReason.spam => reportReasonSpam,
      ReportReason.bullying => reportReasonBullying,
      ReportReason.pornographicContent => reportReasonPornographicContent,
      ReportReason.violentContent => reportReasonViolentContent,
      ReportReason.illegalContent => reportReasonIllegalContent,
      ReportReason.other => reportReasonOther,
    };
  }

  String reportItemTypeLabel(ReportedItemType type) {
    return switch (type) {
      ReportedItemType.blackboard => reportItemTypeBlackboard,
      ReportedItemType.homework => reportItemTypeHomework,
      ReportedItemType.event => reportItemTypeEvent,
      ReportedItemType.lesson => reportItemTypeLesson,
      ReportedItemType.file => reportItemTypeFile,
      ReportedItemType.user => reportItemTypeUser,
      ReportedItemType.course => reportItemTypeCourse,
      ReportedItemType.schoolClass => reportItemTypeSchoolClass,
      ReportedItemType.comment => reportItemTypeComment,
    };
  }
}
