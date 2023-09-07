// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'dart:collection';

import 'package:sharezone/dashboard/update_reminder/release.dart';

class Change extends Release {
  Version? currentUserVersion;
  bool get isNewerThanCurrentVersion =>
      currentUserVersion != null && version > currentUserVersion!;
  late List<String> newFeatures;
  late List<String> improvements;
  late List<String> fixes;

  Change({
    required Version version,
    required DateTime releaseDate,
    required List<String> newFeatures,
    required List<String> improvements,
    required List<String> fixes,
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
    return '- $s';
  }

  @override
  Iterator<String> get iterator => _list.iterator;
}

/// An Object which lets one compare different App-Versions.
///
/// The Version must be three version number separated by docs (e.g. "1.3.1").
class Version implements Comparable<Version> {
  final String name;
  static final _versionRegEx = RegExp(r'^(\d+\.)(\d+\.)(\d+)');

  final int major;
  final int minor;
  final int patch;

  factory Version.parse({required String name}) {
    final match = _versionRegEx.firstMatch(name);
    if (match == null) {
      throw ArgumentError.value(name, "name", "Invalid version format");
    }

    final major = int.parse(match.group(1)!.replaceAll(".", ""));
    final minor = int.parse(match.group(2)!.replaceAll(".", ""));
    final patch = int.parse(match.group(3)!.replaceAll(".", ""));

    return Version._(
      name: name,
      major: major,
      minor: minor,
      patch: patch,
    );
  }

  Version._({
    required this.name,
    required this.major,
    required this.minor,
    required this.patch,
  });

  bool operator >(Version other) {
    return compareTo(other) > 0;
  }

  bool operator <(Version other) {
    return compareTo(other) < 0;
  }

  bool operator >=(Version other) {
    return this == other || this > other;
  }

  bool operator <=(Version other) {
    return this == other || this < other;
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) || (other is Version && name == other.name);
  }

  @override
  int get hashCode {
    return name.hashCode;
  }

  /// Compares this version to another [Version].
  ///
  /// Returns a negative value if this version is older than [other], a positive
  /// value if it's newer, and 0 if they're identical.
  @override
  int compareTo(Version other) {
    if (major != other.major) return major.compareTo(other.major);
    if (minor != other.minor) return minor.compareTo(other.minor);
    return patch.compareTo(other.patch);
  }
}
