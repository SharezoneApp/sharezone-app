// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'dart:convert';

import 'package:abgabe_client_lib/src/erstellung/string_to_datetime_extension.dart';
import 'package:common_domain_models/common_domain_models.dart';

import 'models.dart';

extension ToAuthorModel on AuthorDto {
  Author toAuthor() {
    return Author(
      UserId(uid),
      Nutzername(name, abbreviation),
    );
  }
}

extension ToAuthorDto on Author {
  AuthorDto toDto() {
    return AuthorDto(
      abbreviation: name.abbreviation,
      name: name.ausgeschrieben,
      uid: '$id',
    );
  }
}

extension ToHochgeladeneAbgabedateiDto on HochgeladeneAbgabedatei {
  HochgeladeneAbgabedateiDto toDto() {
    return HochgeladeneAbgabedateiDto.fromHochgeladeneAbgabedatei(this);
  }
}

class HochgeladeneAbgabedateiDto {
  final String id;
  final String fileNameWithExtension;
  final String downloadUrl;
  final int sizeInBytes;
  final String createdOnIsoString;
  final String? lastEditedIsoString;

  HochgeladeneAbgabedateiDto({
    required this.id,
    required this.fileNameWithExtension,
    required this.downloadUrl,
    required this.sizeInBytes,
    required this.createdOnIsoString,
    this.lastEditedIsoString,
  });

  // Achtung: Mögliche Extension-Methoden für Server-Firestore Code benutzen
  // die Id-Namen unten. Diese dort dann auch ändern
  factory HochgeladeneAbgabedateiDto.fromData(Map<String, dynamic> data) {
    return HochgeladeneAbgabedateiDto(
      id: data['id'],
      fileNameWithExtension: data['fileName'],
      downloadUrl: data['downloadURL'],
      sizeInBytes: data['sizeBytes'],
      createdOnIsoString: data['createdOn'],
      lastEditedIsoString: data['lastEdited'],
    );
  }

  factory HochgeladeneAbgabedateiDto.fromHochgeladeneAbgabedatei(
      HochgeladeneAbgabedatei datei) {
    return HochgeladeneAbgabedateiDto(
      id: '${datei.id}',
      fileNameWithExtension: datei.name.mitExtension,
      createdOnIsoString: datei.erstellungsdatum.toUtcIso8601String(),
      downloadUrl: datei.downloadUrl.toString(),
      sizeInBytes: datei.dateigroesse.inBytes,
      lastEditedIsoString: datei.zuletztBearbeitet?.toUtcIso8601String(),
    );
  }

  HochgeladeneAbgabedatei toHochgeladeneAbgabedatei() {
    return HochgeladeneAbgabedatei(
      id: AbgabedateiId(id),
      name: Dateiname(fileNameWithExtension),
      groesse: Dateigroesse(sizeInBytes),
      downloadUrl: DateiDownloadUrl(downloadUrl),
      erstellungsdatum: createdOnIsoString.toDateTime(),
      zuletztBearbeitet: lastEditedIsoString?.toDateTime(),
    );
  }

  @override
  String toString() {
    return 'HochgeladeneAbgabedateiDto(id: $id, fileNameWithExtension: $fileNameWithExtension, downloadUrl: $downloadUrl, sizeInBytes: $sizeInBytes, createdOnIsoString: $createdOnIsoString, lastEditedIsoString: $lastEditedIsoString)';
  }
}

class AuthorDto {
  final String abbreviation;
  final String name;
  final String uid;

  const AuthorDto({
    required this.abbreviation,
    required this.name,
    required this.uid,
  });

  factory AuthorDto.fromData(Map<String, dynamic> data) {
    return AuthorDto(
      abbreviation: data['abbreviation'],
      name: data['name'],
      uid: data['id'],
    );
  }
}

class AbgabezielReferenz {
  String id;
  String type;

  AbgabezielReferenz({
    required this.id,
    required this.type,
  });

  AbgabezielReferenz copyWith({
    String? id,
    String? type,
  }) {
    return AbgabezielReferenz(
      id: id ?? this.id,
      type: type ?? this.type,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'type': type,
    };
  }

  factory AbgabezielReferenz.fromMap(Map<String, dynamic> map) {
    return AbgabezielReferenz(
      id: map['id'],
      type: map['type'],
    );
  }

  String toJson() => json.encode(toMap());

  factory AbgabezielReferenz.fromJson(String source) =>
      AbgabezielReferenz.fromMap(json.decode(source));

  @override
  String toString() => 'AbgabezielReferenz(id: $id, type: $type)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is AbgabezielReferenz && other.id == id && other.type == type;
  }

  @override
  int get hashCode => id.hashCode ^ type.hashCode;
}

enum ReferenceType { homework, blackboard }

typedef ObjectListBuilder<T> = T Function(dynamic decodedMapValue);

List<T> decodeList<T>(dynamic data, ObjectListBuilder<T> builder) {
  List<dynamic>? originaldata = data;
  if (originaldata == null) return [];
  return originaldata.map((dynamic value) => builder(value)).toList();
}

extension DateTimeToUtcIso8601StringExtension on DateTime {
  /// Damit alle Iso-Strings auf dem Server das selbe Format haben und somit
  /// als String einfach vergleichbar sind
  String toUtcIso8601String() {
    if (!isUtc) {
      return toUtc().toIso8601String();
    }
    return toIso8601String();
  }
}
