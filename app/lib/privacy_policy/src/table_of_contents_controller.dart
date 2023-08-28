// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/foundation.dart';

import 'privacy_policy_src.dart';

class TableOfContentsController extends ChangeNotifier {
  final DocumentController _documentController;
  late TableOfContents _tableOfContents;

  TableOfContentsController({
    required CurrentlyReadingController currentlyReadingController,
    required PrivacyPolicy privacyPolicy,
    required DocumentController documentController,
    required ExpansionBehavior initialExpansionBehavior,
  }) : _documentController = documentController {
    _tableOfContents =
        _createTableOfContents(privacyPolicy, initialExpansionBehavior);

    _updateViews();

    currentlyReadingController.currentlyReadDocumentSectionOrNull
        .addListener(() {
      final currentlyReadSection =
          currentlyReadingController.currentlyReadDocumentSectionOrNull.value;
      _tableOfContents =
          _tableOfContents.changeCurrentlyReadSectionTo(currentlyReadSection!);
      _updateViews();
    });
  }

  TableOfContents _createTableOfContents(
      PrivacyPolicy privacyPolicy, ExpansionBehavior initialExpansionBehavior) {
    final IList<TocSection> sections = privacyPolicy.tableOfContentSections
        .map((e) => TocSection(
              id: e.id,
              title: e.sectionName,
              subsections: e.subsections
                  .map(
                    (sub) => TocSection(
                      id: sub.id,
                      title: sub.sectionName,
                      subsections: IList(const []),
                      expansionStateOrNull: null,
                      isThisCurrentlyRead: false,
                    ),
                  )
                  .toIList(),
              isThisCurrentlyRead: false,
              expansionStateOrNull: e.subsections.isNotEmpty
                  ? TocSectionExpansionState(
                      expansionBehavior: initialExpansionBehavior,
                      expansionMode: ExpansionMode.automatic,
                      isExpanded: false,
                    )
                  : null,
            ))
        .toIList();

    return TableOfContents(sections, initialExpansionBehavior);
  }

  void changeExpansionBehavior(ExpansionBehavior expansionBehavior) {
    _tableOfContents =
        _tableOfContents.changeExpansionBehaviorTo(expansionBehavior);
  }

  Future<void> scrollTo(DocumentSectionId documentSectionId) {
    return _documentController.scrollToDocumentSection(documentSectionId);
  }

  void toggleDocumentSectionExpansion(DocumentSectionId documentSectionId) {
    _tableOfContents =
        _tableOfContents.forceToggleExpansionOf(documentSectionId);

    _updateViews();
  }

  IList<TocDocumentSectionView>? _documentSections;
  IList<TocDocumentSectionView>? get documentSections => _documentSections;

  void _updateViews() {
    _documentSections =
        _tableOfContents.sections.map((section) => _toView(section)).toIList();
    notifyListeners();
  }

  TocDocumentSectionView _toView(TocSection documentSection) {
    return TocDocumentSectionView(
      id: documentSection.id,
      isExpanded: documentSection.isExpanded,
      sectionHeadingText: documentSection.title,
      shouldHighlight: documentSection.isThisOrASubsectionCurrentlyRead,
      subsections: documentSection.subsections
          .map(
            (subsection) => TocDocumentSectionView(
              id: subsection.id,
              isExpanded: subsection.isExpanded,
              sectionHeadingText: subsection.title,
              shouldHighlight: subsection.isThisOrASubsectionCurrentlyRead,
              subsections: const IListConst([]),
            ),
          )
          .toIList(),
    );
  }
}
