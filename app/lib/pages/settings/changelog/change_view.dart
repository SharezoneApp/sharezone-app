import 'package:meta/meta.dart';
import 'package:sharezone/pages/settings/changelog/change.dart';

class ChangeView {
  String version;
  List<String> newFeatures;
  List<String> improvements;
  List<String> fixes;
  bool isNewerThanCurrentVersion;

  ChangeView({
    @required this.version,
    this.newFeatures = const [],
    this.improvements = const [],
    this.fixes = const [],
    this.isNewerThanCurrentVersion = false,
  });

  ChangeView.fromModel(Change change, Version currentVersion) {
    version = change.version.name;
    newFeatures = change.newFeatures;
    improvements = change.improvements;
    fixes = change.fixes;
    isNewerThanCurrentVersion = change.version > currentVersion;
  }
}
