// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'dart:io';

import 'package:files_basics/files_models.dart';
import 'package:path/path.dart' as path;

import 'package:files_basics/local_file.dart';
import 'package:files_basics/local_file_io.dart';
import 'package:files_usecases/src/file_downloader/file_downloader.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:sharezone_utils/platform.dart';

class MobileFileDownloader extends FileDownloader {
  @override
  Future<LocalFile> downloadFileFromURL(
      String url, String filename, String id) async {
    File fileWithID = await DefaultCacheManager().getSingleFile(url);
    final filePath =
        '${path.dirname(fileWithID.path)}/$id.${FileUtils.getExtension(filename)}';

    // Da unsere Dateien die ID als Namen haben, müssen diese umbenannt werden.
    // Deswegen muss erst geprüft werden, ob der Pfad, welcher vom [DefaulCacheManger]
    // zurückgegeben wurde, existiert. Existiert dieser Pfad, wurde die Datei gerade
    // heruntergeladen und muss noch umbenannt werden. Die ID wird dann durch den
    // richtigen Namen ersetzt. Wird dann beim nächsten Mal die Datei aufgerufen,
    // befindet sich bei dem Path, welchen der [DefaultCacheManger] zurückgegeben hat,
    // keine Datei. Das liegt daran, weil wir vorher die Datei mit dem richtigen Namen
    // benannt haben. Wir müssen dann auch an diesem Ort suchen, also nach dem [filePath].
    fileWithID = await fileWithID.exists()
        ? await fileWithID.rename(filePath)
        : File(filePath);

    if (PlatformCheck.isMacOS) {
      filename = filename.replaceAll(RegExp(r"""[();:"` <>&']"""), '');

      // Falls der Dateiname vor der Extention leer ist, soll ein _ hinzufügen werden.
      if (filename.lastIndexOf('.') == 0) {
        filename = '_$filename';
      }
    }

    final fileWithNamePath = '${path.dirname(fileWithID.path)}/$filename';
    final fileWithName = await fileWithID.copy(fileWithNamePath);

    return LocalFileIo.fromFile(fileWithName);
  }
}

FileDownloader getFileDownloader() {
  return MobileFileDownloader();
}
