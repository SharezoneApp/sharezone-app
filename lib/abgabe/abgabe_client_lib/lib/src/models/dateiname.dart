// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

class Dateiname {
  final String mitExtension;
  String get nurExtension => mitExtension.substring(
      mitExtension.lastIndexOf('.') + 1, mitExtension.length);
  String get ohneExtension =>
      mitExtension.substring(0, mitExtension.lastIndexOf('.'));

  /// Mindestname: a.b => Punkt darf nicht am Ende und Anfang sein.
  Dateiname(this.mitExtension) {
    final punktIndex = mitExtension.lastIndexOf('.');
    if (punktIndex == -1) {
      throw ArgumentError.value(mitExtension, 'dateinameMitExtension',
          'muss ein Seperator "." im Namen haben.');
    }
    final punktIstAmEnde = punktIndex == mitExtension.length - 1;
    final punktIstAmAnfang = punktIndex == 0;
    if (mitExtension.length < 3 || punktIstAmAnfang || punktIstAmEnde) {
      throw ArgumentError('$mitExtension ist invalid aufgebaut Dateiname');
    }
    if (!RegExp(r'^[^<>:;,?"*|\\/]+$').hasMatch(mitExtension)) {
      throw ArgumentError('$mitExtension ist ein invalider Dateiename');
    }
  }

  Dateiname neuerBasename(String basename) {
    return Dateiname('$basename.$nurExtension');
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        other is Dateiname && other.mitExtension == mitExtension;
  }

  @override
  int get hashCode => mitExtension.hashCode;

  @override
  String toString() {
    return '$mitExtension';
  }
}
