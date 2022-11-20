import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:meta/meta.dart';

import '../../new_privacy_policy_page.dart';
import '../privacy_policy_src.dart';
import '../widgets/common.dart';

class PrivacyPolicyPageDependencyFactory {
  final TableOfContentsController tableOfContentsController;
  final CurrentlyReadingSectionController currentlyReadingController;
  final DocumentController documentController;

  factory PrivacyPolicyPageDependencyFactory({
    @required AnchorsController anchorsController,
    @required PrivacyPolicy privacyPolicy,
    @required PrivacyPolicyPageConfig config,
  }) {
    // TODO: See if internal constructors of classes below don't make sense
    // anymore.
    final documentController = DocumentController(
      anchorsController: anchorsController,
      threshold: config.threshold,
    );
    final currentlyReadingController = CurrentlyReadingSectionController(
      config: config,
      privacyPolicy: privacyPolicy,
      documentController: documentController,
    );

    final tableOfContentsController = TableOfContentsController(
      documentController: documentController,
      privacyPolicy: privacyPolicy,
      currentlyReadingController: currentlyReadingController,
      // We always call [TableOfContentsController.changeExpansionBehavior]
      // anyways when building the different layouts anyway so it doesn't really
      // matter what value we use here.
      initialExpansionBehavior:
          ExpansionBehavior.alwaysAutomaticallyCloseSectionsAgain,
    );

    return PrivacyPolicyPageDependencyFactory._(
      tableOfContentsController,
      currentlyReadingController,
      documentController,
    );
  }

  PrivacyPolicyPageDependencyFactory._(
    this.tableOfContentsController,
    this.currentlyReadingController,
    this.documentController,
  );
}
