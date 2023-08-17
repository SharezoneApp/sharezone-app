// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'mime_type.dart';

/// LocalFile ist ein Wrapper für Files auf verschiedenen Platformen
/// Da dart:io bzw. dart:hml abstrahiert werden muss, sind getFile und getData
/// dynamic. [LocalFileIo] ist für Mobile/Desktop, [LocalFileData] ist für
/// Web und besitzt die Daten ausschließlich als UInt8List.
abstract class LocalFile {
  /// Returns the File as Dart:io File if [LocalFile] is [LocalFileIo].
  ///
  /// Otherwise returns null.
  dynamic getFile();
  dynamic getData();

  String? getPath();

  String getName();

  MimeType? getType();

  int getSizeBytes();

  /// getFile() und getData() können aktuell nicht verglichen werden,
  /// weil die je nach Plattform einen Error werfen können.
  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        other is LocalFile &&
            other.getName() == getName() &&
            other.getPath() == getPath() &&
            other.getType() == getType() &&
            other.getSizeBytes() == getSizeBytes();
  }

  /// getFile() und getData() können aktuell nicht verglichen werden,
  /// weil die je nach Plattform einen Error werfen können.
  @override
  int get hashCode =>
      getName().hashCode ^
      getPath().hashCode ^
      getType().hashCode ^
      getSizeBytes().hashCode;

  @override
  String toString() {
    return 'LocaFile(name: ${getName()}, path: ${getPath()}, getType: ${getType()}, getSizeBytes: ${getSizeBytes()})';
  }
}
