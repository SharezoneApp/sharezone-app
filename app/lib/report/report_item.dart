// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

//@dart=2.12

import 'package:sharezone/comments/comments_gateway.dart';
import 'package:sharezone_common/references.dart';

enum ReportedItemType {
  homework,
  blackboard,
  event,
  lesson,
  file,
  user,
  course,
  schoolClass,
  comment,
}

String reportItemTypeToUiString(ReportedItemType type) {
  switch (type) {
    case ReportedItemType.blackboard:
      return 'Infozettel';
    case ReportedItemType.homework:
      return 'Hausaufgabe';
    case ReportedItemType.event:
      return 'Termin / Prüfung';
    case ReportedItemType.lesson:
      return 'Stunde';
    case ReportedItemType.file:
      return 'Datei';
    case ReportedItemType.user:
      return 'Nutzer';
    case ReportedItemType.course:
      return 'Kurs';
    case ReportedItemType.schoolClass:
      return 'Schulklasse';
    case ReportedItemType.comment:
      return 'Kommentar';
  }
}

class ReportItemReference {
  final String path;

  const ReportItemReference._(this.path);

  factory ReportItemReference.homework(String id) {
    return ReportItemReference._('${CollectionNames.homework}/$id');
  }

  factory ReportItemReference.blackboard(String id) {
    return ReportItemReference._('${CollectionNames.blackboard}/$id');
  }

  factory ReportItemReference.user(String id) {
    return ReportItemReference._('${CollectionNames.user}/$id');
  }

  factory ReportItemReference.file(String id) {
    return ReportItemReference._('${CollectionNames.files}/$id');
  }

  factory ReportItemReference.event(String id) {
    return ReportItemReference._('${CollectionNames.events}/$id');
  }

  factory ReportItemReference.lesson(String id) {
    return ReportItemReference._('${CollectionNames.lessons}/$id');
  }

  factory ReportItemReference.course(String id) {
    return ReportItemReference._('${CollectionNames.courses}/$id');
  }

  factory ReportItemReference.schoolClass(String id) {
    return ReportItemReference._('${CollectionNames.schoolClasses}/$id');
  }

  factory ReportItemReference.comment(CommentLocation location) {
    return ReportItemReference._(
        '${location.baseCollection}/${location.parentDocumentId}/${CollectionNames.comments}/${location.commentId}');
  }
}
