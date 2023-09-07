import 'package:sz_repo_cli/src/common/common.dart';

/// Returns the build name for the app and adds the stage.
///
/// Example:
///  * Stage is `beta`: `1.0.0-beta` -> `1.0.0-beta`
String getBuildNameWithStage(Package package, String stage) {
  final versionWithoutBuildNumber = package.version.split('+').first;
  return '$versionWithoutBuildNumber-$stage';
}
