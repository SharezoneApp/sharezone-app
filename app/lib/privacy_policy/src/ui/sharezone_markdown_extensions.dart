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
///
/// It's the exact same algorithm (for now).
///
/// It might break if we e.g. would use one updated algorithm in our backend to
/// generate the anchor ids for the table of contents section list, but our
/// client uses an old algorithm to generate/search for the anchor ids inside
/// the markdown text. This might cause a mismatch which would cause a failure
/// when trying to navigate to a section by pressing an item in the table of
/// contents. It might fail since the client can't find the anchor id from
/// the TOC generated with the new algorithm inside the markdown text (as the
/// client still uses the old algorithm).
/// This assumes that the table of content sections (including anchor ids) are
/// dictated by the backend and only displayed on the client (i.e. TOC is not
/// generated from the markdown text on the client). This might be done to e.g.
/// better control which headers are actually shown in the TOC which is a
/// possiblity of how we might want to implement it in the future.
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
