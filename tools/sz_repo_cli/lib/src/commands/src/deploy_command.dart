import 'package:args/command_runner.dart';

class DeployCommand extends Command {
  @override
  String get description =>
      'Deploy Sharezone or parts of Sharezone (e.g. web app)';

  @override
  String get name => 'deploy';
}
