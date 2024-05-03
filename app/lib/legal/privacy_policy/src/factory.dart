// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:flutter_markdown/flutter_markdown.dart';

import 'privacy_policy_src.dart';

class PrivacyPolicyPageDependencyFactory {
  final TableOfContentsController tableOfContentsController;
  final CurrentlyReadingController currentlyReadingController;
  final DocumentController documentController;

  factory PrivacyPolicyPageDependencyFactory({
    required AnchorController anchorController,
    required PrivacyPolicy privacyPolicy,
    required PrivacyPolicyPageConfig config,
  }) {
    final documentController = DocumentController(
      anchorController: anchorController,
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
