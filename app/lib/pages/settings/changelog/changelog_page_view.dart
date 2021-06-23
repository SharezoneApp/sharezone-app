import 'package:meta/meta.dart';
import 'package:sharezone/pages/settings/changelog/change_view.dart';

class ChangelogPageView {
  final List<ChangeView> changes;
  final bool userHasNewestVersion;
  final bool allChangesLoaded;
  bool get hasChanges => changes?.isNotEmpty ?? false;

  const ChangelogPageView({
    @required this.changes,
    this.userHasNewestVersion = true,
    this.allChangesLoaded = false,
  });

  const ChangelogPageView.placeholder() : changes = const [], userHasNewestVersion = true, allChangesLoaded = false;
}