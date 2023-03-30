// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

class DateiDownloadUrl {
  final String _url;

  /// Momentan wird nur darauf geprüft, dass die Url nicht leer ist.
  /// In Zukunft könnte man noch prüfen, dass es eine wirklich valide URL ist
  DateiDownloadUrl(this._url) {
    ArgumentError.checkNotNull(_url, 'downloadUrl');
    if (_url.isEmpty) {
      throw ArgumentError('Die Download-Url darf nicht leer sein');
    }
  }

  @override
  String toString() {
    return _url;
  }
}
