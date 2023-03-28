// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:mime/mime.dart';

class MimeType {
  final String _mimeType;

  MimeType(this._mimeType);

  static final any = MimeType('application');

  static MimeType? fromFileNameOrNull(String fileName) {
    final mimetype = lookupMimeType(fileName);
    if (mimetype == null || mimetype == 'null')
      return null;
    else
      return MimeType(mimetype);
  }

  static MimeType? fromPathOrNull(String path) {
    final mimetype = lookupMimeType(path);
    if (mimetype == null || mimetype == 'null')
      return null;
    else
      return MimeType(mimetype);
  }

  static MimeType? fromBlobType(String blobType) {
    final mimetype = lookupMimeType(blobType);
    if (mimetype == null || mimetype == 'null')
      return MimeType(blobType);
    else
      return MimeType(mimetype);
  }

  String toData() {
    return _mimeType;
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        other is MimeType && other.toData() == toData();
  }

  @override
  int get hashCode => toData().hashCode;
}
