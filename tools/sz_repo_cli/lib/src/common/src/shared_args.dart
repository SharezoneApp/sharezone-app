import 'package:args/args.dart';
import 'package:meta/meta.dart';

const _packageTimeoutName = 'package-timeout-minutes';

extension AddPackageTimeout on ArgParser {
  void addPackageTimeoutOption({@required int defaultInMinutes}) {
    addOption(
      _packageTimeoutName,
      help:
          'How long the analyze command is allowed to run per package in minutes (if exceeded the package will fail analyzation)',
      defaultsTo: '$defaultInMinutes',
    );
  }
}

extension PackageTimeoutArgResult on ArgResults {
  Duration get packageTimeoutDuration {
    final _packageTimeout = this[_packageTimeoutName];
    return Duration(minutes: int.parse(_packageTimeout));
  }
}
