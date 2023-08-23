// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:collection/collection.dart';
import 'package:common_domain_models/common_domain_models.dart';
import 'package:optional/optional.dart';

import 'models.dart';

class ErstellerAbgabeModelSnapshot {
  ErstellerAbgabeModelSnapshot(ErstellerAbgabeModel abgabe)
      : abgabe = Optional.ofNullable(abgabe);

  ErstellerAbgabeModelSnapshot.nichtExistent()
      : abgabe = const Optional.empty();

  bool get existiertAbgabe => abgabe.isPresent;
  final Optional<ErstellerAbgabeModel> abgabe;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ErstellerAbgabeModelSnapshot && other.abgabe == abgabe;
  }

  @override
  int get hashCode => abgabe.hashCode;

  @override
  String toString() => 'ErstellerAbgabenModelSnapshot(abgabe: $abgabe)';
}

class ErstellerAbgabeModel {
  final AbgabeId abgabeId;
  final Optional<DateTime> abgegebenUm;
  bool get abgegeben => abgegebenUm.isPresent;
  final List<HochgeladeneAbgabedatei> abgabedateien;

  ErstellerAbgabeModel({
    required this.abgabeId,
    required DateTime? abgegebenUm,
    required this.abgabedateien,
  }) : abgegebenUm = Optional.ofNullable(abgegebenUm);

  ErstellerAbgabeModelSnapshot toSnapshot() =>
      ErstellerAbgabeModelSnapshot(this);

  @override
  String toString() =>
      'ErstellerAbgabenModel(abgabeId: $abgabeId, abgegebenUm: $abgegebenUm, abgabedateien: $abgabedateien)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    final listEquals = const DeepCollectionEquality().equals;

    return other is ErstellerAbgabeModel &&
        other.abgabeId == abgabeId &&
        other.abgegebenUm == abgegebenUm &&
        listEquals(other.abgabedateien, abgabedateien);
  }

  @override
  int get hashCode =>
      abgabeId.hashCode ^ abgegebenUm.hashCode ^ abgabedateien.hashCode;
}
