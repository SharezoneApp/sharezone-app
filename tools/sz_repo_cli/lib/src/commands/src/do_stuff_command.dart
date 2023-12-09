// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'dart:async';
import 'dart:io';

import 'package:sz_repo_cli/src/common/common.dart';

/// Useful to quickly script something for this repo. Helps by not having to use
/// a bash script or having to create a whole new package with dependencies just
/// to write a dart script.
/// It's sort of a scaffold to quickly write a command.
/// Run from the root of this repo with
/// `dart ./tools/sz_repo_cli/bin/sz_repo_cli.dart do-stuff`
class DoStuffCommand extends CommandBase {
  DoStuffCommand(super.context);

  @override
  String get description =>
      'Command for quick local scripting (used locally for development)';

  @override
  String get name => 'do-stuff';

  @override
  Future<void> run() async {
    stdout.writeln('');
    stdout.writeln(
        'This is used for local development/scripting and does not do anything.');
    stdout.writeln(
        'To find this file look for "do_stuff_command.dart" near ${Platform.script.path}');
    stdout.writeln('<3');
    stdout.writeln('');
    // Example usage:
    // final pubspecs = Glob('**/pubspec.yaml')
    //     .listSync(root: repo.location.path)
    //     .whereType<File>();
    // for (var pubspecFile in pubspecs) {
    //   final content = pubspecFile.readAsStringSync();
    //   if (!content.contains('foo')) {
    //     return;
    //   }
    //   pubspecFile.writeAsStringSync('abc');
    // }
  }
}
