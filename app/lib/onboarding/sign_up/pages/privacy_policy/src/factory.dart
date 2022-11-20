import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:meta/meta.dart';

import 'privacy_policy_src.dart';

class PrivacyPolicyPageDependencyFactory {
  final TableOfContentsController tableOfContentsController;
  final CurrentlyReadingController currentlyReadingController;
  final DocumentController documentController;

  factory PrivacyPolicyPageDependencyFactory({
    @required AnchorsController anchorsController,
    @required PrivacyPolicy privacyPolicy,
    @required PrivacyPolicyPageConfig config,
  }) {
    final documentController = DocumentController(
      anchorsController: anchorsController,
      threshold: config.threshold,
    );
    final currentlyReadingController = CurrentlyReadingController(
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
