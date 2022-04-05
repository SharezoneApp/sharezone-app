// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:files_basics/local_file.dart';
import 'package:optional/optional.dart';

final Map<String, LocalFile> _files = {};

/// Behält die Dateien auch wenn eine neue Instanz erstellt wird.
class SingletonLocalFileSaver {
  void saveFile(String id, LocalFile file) {
    _files[id] = file;
  }

  Optional<LocalFile> getFile(String id) {
    return Optional.ofNullable(_files[id]);
  }
}
