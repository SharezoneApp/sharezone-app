// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'dart:async';
import 'dart:io';

import 'package:glob/glob.dart';
import 'package:glob/list_local_fs.dart';
import 'package:path/path.dart' as path;
import 'package:sz_repo_cli/src/common/common.dart';

/// Moves/Renames golden files from codemagic so they can replace the old ones.
///
/// We currently have to generate golden files on a mac. Developers on other
/// platforms will have to upload their wrong golden files and then download the
/// golden files that were generated in the failing Codemagic job.
///
/// The files from Codemagic are named in the following pattern:
/// * foo_testImage.png (The image generated by Codemagic)
/// * foo_masterImage.png (The image that was checked into the repo)
/// * foo_isolatedDiff.png
/// * foo_maskedDiff.png
///
/// This command will pick all the files that end with `_testImage.png`, remove
/// the `_testImage` part and put them in a new folder called `corrected`.
///
/// These images can then be taken by the developer to replace the old golden
/// files with the same name.
class PickCodemagicGoldens extends CommandBase {
  PickCodemagicGoldens(super.context);

  @override
  String get description =>
      'Picks all golden files from codemagic, rename them and put them in a serperate folder.\n'
      'To use this command, drop the golden files from Codemagic somewhere in a folder in this repo.\n'
      'Then run this command. It will pick all the files that end with `_testImage.png`, remove the `_testImage` part and put them in a new folder called `corrected`.\n'
      'These images can then be taken by the developer to replace the old golden files with the same name.';

  @override
  String get name => 'pick-codemagic-goldens';

  @override
  Future<void> run() async {
    final files = Glob('**/**testImage.png')
        .listSync(root: repo.location.path)
        .whereType<File>();
    late Directory newDir;
    for (var file in files) {
      final fileName = path.basename(file.path);
      final newFileName = fileName.replaceAll('_testImage', '');

      if (file == files.first) {
        newDir = Directory(path.join(file.parent.path, 'corrected'))
          ..createSync();
      }
      file.copySync(path.join(newDir.path, newFileName));
    }
  }
}
