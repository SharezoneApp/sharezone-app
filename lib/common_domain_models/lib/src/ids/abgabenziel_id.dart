// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'src/id.dart';
import 'homework_id.dart';

enum AbgabenzielTyp { hausaufgabe }

/// Extra kurz, damit die [AbgabezielId] nicht viel zu Lang wird
const _homework = 'hw';

String abgabenzielTypToDtoString(AbgabenzielTyp typ) {
  switch (typ) {
    case AbgabenzielTyp.hausaufgabe:
      return _homework;
    default:
      throw UnimplementedError();
  }
}

AbgabenzielTyp abgabenzielFromDtoString(String type) {
  switch (type) {
    case _homework:
      return AbgabenzielTyp.hausaufgabe;
    default:
      throw UnimplementedError();
  }
}

/// Soll gleich dem DocumentReference-Pfad des Abgabensziels (z.B. HA) sein
class AbgabezielId extends Id {
  static const informationSeperator = '.';

  // Hier wäre eigentlich eine Union wie in Typescript perfekt
  final AbgabenzielTyp zielTyp;
  final Id zielId;

  AbgabezielId._(
    this.zielTyp,
    this.zielId,
  ) : super('${abgabenzielTypToDtoString(zielTyp)}$informationSeperator$zielId',
            'AbgabenzielId');

  factory AbgabezielId.homework(HomeworkId id) {
    ArgumentError.checkNotNull(id, 'HomeworkId');
    return AbgabezielId._(AbgabenzielTyp.hausaufgabe, id);
  }

  factory AbgabezielId.fromOrThrow(String id) {
    final seperatorIndexMatches =
        RegExp('\\$informationSeperator').allMatches(id);
    if (seperatorIndexMatches.length != 1) {
      throw _argumentError(id,
          'Eine AbgabenzielId muss genau ein "$informationSeperator" haben');
    }
    final seperatorMatch = seperatorIndexMatches.single;
    final typeString = id.substring(0, seperatorMatch.start);
    final type = abgabenzielFromDtoString(typeString);

    final contentIdString = id.substring(seperatorMatch.start + 1);
    Id _id;
    // Da die einzelnen Ids selbst eigene Regeln haben könnten, muss man diese
    // erst einmal erstellen um sicher zu gehen.
    switch (type) {
      case AbgabenzielTyp.hausaufgabe:
        _id = HomeworkId(contentIdString);
        break;
      default:
        throw Exception('Unknown AbgabenzielTyp: $type');
    }

    return AbgabezielId._(type, _id);
  }
}

ArgumentError _argumentError(String value, String message) =>
    throw ArgumentError.value(value, 'AbgabenzielId', message);
