// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:markdown/markdown.dart';

/// We define our own classes for automatic ID generation as we don't want any
/// chance of breakage if `package:markdown` changes/updates its algorithm.
/// It's the exact same algorithm (for now).
///
/// In this way we can also move the algorithm to a seperate package and access
/// it for e.g. automatic validation of anchors in our documents at the writing
/// stage.

/// Like `package:markdown` [ExtensionSet.gitHubWeb] but:
/// --> [SharezoneHeaderWithIdSyntax] replaces [HeaderWithIdSyntax]
/// --> [SharezoneSetextHeaderWithIdSyntax] replaces [SetextHeaderWithIdSyntax]
final ExtensionSet sharezoneMarkdownExtensionSet = ExtensionSet(
  List<BlockSyntax>.unmodifiable(
    <BlockSyntax>[
      const FencedCodeBlockSyntax(),
      const _SharezoneHeaderWithIdSyntax(),
      const _SharezoneSetextHeaderWithIdSyntax(),
      const TableSyntax(),
    ],
  ),
  List<InlineSyntax>.unmodifiable(
    <InlineSyntax>[
      InlineHtmlSyntax(),
      StrikethroughSyntax(),
      EmojiSyntax(),
      AutolinkExtensionSyntax()
    ],
  ),
);

class _SharezoneHeaderWithIdSyntax extends HeaderWithIdSyntax {
  const _SharezoneHeaderWithIdSyntax();

  @override
  Node parse(BlockParser parser) {
    var element = super.parse(parser) as Element;
    element.generatedId = _generateAnchorHashFromElement(element);
    return element;
  }
}

class _SharezoneSetextHeaderWithIdSyntax extends SetextHeaderWithIdSyntax {
  const _SharezoneSetextHeaderWithIdSyntax();

  @override
  Node parse(BlockParser parser) {
    var element = super.parse(parser) as Element;
    element.generatedId = _generateAnchorHashFromElement(element);
    return element;
  }
}

String _generateAnchorHashFromElement(Element element) =>
    generateAnchorHash(element.children.first.textContent);

/// Generates a valid HTML anchor from the inner text of [element].
String generateAnchorHash(String text) => text
    .toLowerCase()
    .trim()
    .replaceAll(RegExp(r'[^a-z0-9 _-]'), '')
    .replaceAll(RegExp(r'\s'), '-');
