// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:collection/collection.dart';
import 'package:common_domain_models/common_domain_models.dart';
import 'package:meta/meta.dart';

import 'models.dart';

class ErstellerAbgabenModelDto {
  final String abgabeId;
  final String abgegebenUmIsoString;
  final List<HochgeladeneAbgabedateiDto> dateien;

  ErstellerAbgabenModelDto({
    @required this.abgabeId,
    @required this.abgegebenUmIsoString,
    @required this.dateien,
  });

  ErstellerAbgabenModelDto copyWith({
    String abgabeId,
    String abgegebenUmIsoString,
    List<HochgeladeneAbgabedateiDto> dateien,
  }) {
    return ErstellerAbgabenModelDto(
      abgabeId: abgabeId ?? this.abgabeId,
      abgegebenUmIsoString: abgegebenUmIsoString ?? this.abgegebenUmIsoString,
      dateien: dateien ?? this.dateien,
    );
  }

  static ErstellerAbgabenModelDto fromMap(Map<String, dynamic> map) {
    if (map == null) return null;
    return ErstellerAbgabenModelDto(
      abgabeId: map['submissionId'],
      abgegebenUmIsoString: map['submittedOn'],
      dateien: List<HochgeladeneAbgabedateiDto>.from(map['submissionFiles']
              ?.map((x) => HochgeladeneAbgabedateiDto.fromData(x)) ??
          {}),
    );
  }

  ErstellerAbgabeModel toAbgabe() {
    return ErstellerAbgabeModel(
      abgabeId: AbgabeId.fromOrThrow(abgabeId),
      abgegebenUm: abgegebenUmIsoString.toDateTime(),
      abgabedateien: dateien.map((e) => e.toHochgeladeneAbgabedatei()).toList(),
    );
  }

  @override
  String toString() =>
      'ErstellerAbgabenModelDto(abgabeId: $abgabeId, abgegebenUmIsoString: $abgegebenUmIsoString, dateien: $dateien)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    final listEquals = const DeepCollectionEquality().equals;

    return other is ErstellerAbgabenModelDto &&
        other.abgabeId == abgabeId &&
        other.abgegebenUmIsoString == abgegebenUmIsoString &&
        listEquals(other.dateien, dateien);
  }

  @override
  int get hashCode =>
      abgabeId.hashCode ^ abgegebenUmIsoString.hashCode ^ dateien.hashCode;
}

extension ErstellerAbgabeToDto on ErstellerAbgabeModel {
  ErstellerAbgabenModelDto toDto() {
    return ErstellerAbgabenModelDto(
      abgabeId: '$abgabeId',
      abgegebenUmIsoString:
          abgegebenUm.map((val) => val.toUtc().toIso8601String()).orElse(null),
      dateien: abgabedateien.map((e) => e.toDto()).toList(),
    );
  }
}

extension StringToDateTimeExtension on String {
  /// Ruft DateTime.parse für diesen String auf.
  DateTime toDateTime() => this != null ? DateTime.parse(this) : null;
}
