// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'dart:collection';

import 'package:meta/meta.dart';
import 'package:sharezone/dashboard/update_reminder/release.dart';

class Change extends Release {
  Version currentUserVersion;
  bool get isNewerThanCurrentVersion =>
      currentUserVersion != null && version > currentUserVersion;
  List<String> newFeatures;
  List<String> improvements;
  List<String> fixes;

  Change({
    @required Version version,
    @required DateTime releaseDate,
    @required List<String> newFeatures,
    @required List<String> improvements,
    @required List<String> fixes,
  }) : super(version: version, releaseDate: releaseDate) {
    this.newFeatures = LineStringList(newFeatures).toList();
    this.improvements = LineStringList(improvements).toList();
    this.fixes = LineStringList(fixes).toList();
  }
}

class LineStringList with IterableMixin<String> {
  final List<String> _list;

  LineStringList(List<String> items)
      : _list = items.map(_addIndentationMark).toList();

  static String _addIndentationMark(String s) {
    if (s != null && s.isNotEmpty) {
      return '- $s';
    }
    return s;
  }

  @override
  Iterator<String> get iterator => _list.iterator;
}

/// An Object which lets one compare different App-Versions.
/// The Version must be three version number seperated by docs (e.g. "1.3.1").
class Version {
  final String name;
  final versionRegEx = RegExp(r'^(\d+\.)(\d+\.)(\d+)$');

  Version({@required String name})
      : name = name.replaceAll(
            RegExp(r'\W*(-dev)\W*'), ""); // Removing -dev of version

  bool operator >(Version other) {
    return _versionNameToInt(name) > _versionNameToInt(other.name);
  }

  bool operator <(Version other) {
    return _versionNameToInt(name) < _versionNameToInt(other.name);
  }

  bool operator >=(Version other) {
    return this == other || this > other;
  }

  bool operator <=(Version other) {
    return this == other || this < other;
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) || (other is Version && name == other.name);
  }

  @override
  int get hashCode {
    return name.hashCode;
  }

  int _versionNameToInt(String version) {
    if (version == null) return -1;
    assert(versionRegEx.allMatches(version).length == 1,
        "The version string should be in a valid format");
    final List<String> splittedVersion = version.split('.');
    final String versionWithoutPoints =
        '${splittedVersion[0]}${splittedVersion[1]}${splittedVersion[2]}';
    final int versionAsInt = int.parse(versionWithoutPoints);
    return versionAsInt;
  }
}
