// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

//@dart=2.12

import 'package:sharezone/report/report_item.dart';
import 'package:sharezone/report/report_reason.dart';
import 'package:sharezone_common/references.dart';

class Report {
  final String creatorID;
  final DateTime createdOn;

  final ReportItem item;
  final ReportReason reason;
  final String description;

  Report({
    required this.creatorID,
    required this.createdOn,
    required this.item,
    required this.reason,
    required this.description,
  });
}

class ReportItem {
  final String path;

  ReportItem(this.path)
      : assert(
          !path.endsWith('/'),
          '''Der Pfad sollte nicht mit einem Slash ("/") enden.
        Falls es doch so ist, heißt dass, dass die ID bzw der Pfad des zu meldenden Items
        nicht richtig gebaut werden konnte.
        
        Der übergeben Pfad ist: $path

        Momentan wird in der App bei Stream-Builder manchmal eine Klasse mit leeren Daten,
        also beispielsweise einer leeren Id ("") zum Anfang benutzt wird.
        
        Ein Workaround ist, dass man die leere ID mit einer temporären "Fake"-ID ersetzt.''',
        );

  ReportedItemType get type {
    final pathParts = path.split('/');
    final parentCollectionName = pathParts[pathParts.length - 2];
    return _reportItemTypeFromString(parentCollectionName);
  }

  ReportedItemType _reportItemTypeFromString(String typeString) {
    switch (typeString) {
      case CollectionNames.blackboard:
        return ReportedItemType.blackboard;
      case CollectionNames.homework:
        return ReportedItemType.homework;
      case CollectionNames.events:
        return ReportedItemType.event;
      case CollectionNames.lessons:
        return ReportedItemType.lesson;
      case CollectionNames.files:
        return ReportedItemType.file;
      case CollectionNames.user:
        return ReportedItemType.user;
      case CollectionNames.courses:
        return ReportedItemType.course;
      case CollectionNames.schoolClasses:
        return ReportedItemType.schoolClass;
      case CollectionNames.comments:
        return ReportedItemType.comment;
    }
    throw ArgumentError('Unknown report type: $typeString');
  }
}
