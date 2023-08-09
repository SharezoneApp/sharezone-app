// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'dart:async';
import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:glob/glob.dart';
import 'package:glob/list_local_fs.dart';
import 'package:path/path.dart';
import 'package:sz_repo_cli/src/common/common.dart';

final Glob pubspecGlob = Glob('**pubspec.yaml');

class LocateSharezoneAppFlutterDirectoryCommand extends Command {
  LocateSharezoneAppFlutterDirectoryCommand() {
    argParser.addOption(pathType,
        defaultsTo: absolute,
        allowed: <String>[relative, absolute],
        help: 'What kind of path should be given back',
        abbr: 'p');
  }

  static const String pathType = 'pathType';
  static const String relative = 'relative';
  static const String absolute = 'absolute';

  @override
  String get description =>
      "Gives back the path of the flutter directory where the sharezone app is located.\nIt is determined by searching for a pubspec.yaml with 'name: sharezone'";

  @override
  String get name => 'locate-app';

  @override
  FutureOr<void> run() async {
    switch (argResults![pathType]) {
      case relative:
        print(await findSharezoneFlutterAppRelativeDirectoryPath());
        break;
      case absolute:
        print(await findSharezoneFlutterAppAbsoluteDirectoryPath());
        break;
    }
  }
}

Future<String> findSharezoneFlutterAppAbsoluteDirectoryPath() async {
  final dir = await findSharezoneFlutterDirectory(
    root: await getProjectRootDirectory(),
  );

  // normalize is used as the default given back is e.g.
  // /Users/maxmustermann/development/projects/sharezone-app/./app instead of
  // /Users/maxmustermann/development/projects/sharezone-app/app
  // which is not wrong but not pretty ;)
  return normalize(dir.absolute.path);
}

Future<String> findSharezoneFlutterAppRelativeDirectoryPath() async {
  final dir = await findSharezoneFlutterDirectory(
    root: await getProjectRootDirectory(),
  );
  if (dir.isAbsolute) {
    return relative(dir.path, from: Directory.current.path);
  }
  return dir.path;
}

Future<Directory> findSharezoneFlutterDirectory(
    {required Directory root}) async {
  await for (FileSystemEntity entity in pubspecGlob.list(root: root.path)) {
    if (entity is File) {
      final pubspecContent = await entity.readAsString();

      final isSharezone =
          pubspecContent.contains(RegExp(r'(?:^|\W)name: sharezone(?:$|\W)'));
      if (isSharezone) {
        return entity.parent;
      }
    }
  }
  throw SharezoneDirectoryNotFoundError(root.path);
}

class SharezoneDirectoryNotFoundError extends Error {
  SharezoneDirectoryNotFoundError([this.currentDirPath]);

  final String? currentDirPath;

  @override
  String toString() {
    return 'Could not find Sharezone under current path ($currentDirPath)';
  }
}
