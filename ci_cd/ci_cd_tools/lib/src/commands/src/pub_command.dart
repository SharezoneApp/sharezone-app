import 'package:args/command_runner.dart';

class PubCommand extends Command {
  @override
  String get description =>
      'Runs a pub command for all files under /lib and maybe /app (depends on command)';

  @override
  String get name => 'pub';
}
