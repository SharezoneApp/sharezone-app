import 'dart:async';
import 'dart:io';

import 'package:args/command_runner.dart';

import 'package:ci_cd_tools/src/common/common.dart';

/// Useful to quickly script something for this repo. Helps by not having to use
/// a bash script or having to create a whole new package with dependencies just
/// to write a dart script.
/// It's sort of a scaffold to quickly write a command.
/// Run from the root of this repo with
/// `dart ./ci_cd/ci_cd_tools/bin/ci_cd_tools.dart do-stuff`
class DoStuffCommand extends Command {
  DoStuffCommand(this.repo);

  final SharezoneRepo repo;

  @override
  String get description =>
      'Command for quick local scripting (used locally for development)';

  @override
  String get name => 'do-stuff';

  @override
  Future<void> run() async {
    print('');
    print(
        'This is used for local development/scripting and does not do anything.');
    print(
        'To find this file look for "do_stuff_command.dart" near ${Platform.script.path}');
    print('<3');
    print('');
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
