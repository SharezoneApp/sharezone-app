// Copyright (c) 2024 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:flutter/material.dart';
import 'package:sharezone_plus_page_ui/src/markdown_centered_text.dart';
import 'package:sharezone_widgets/sharezone_widgets.dart';

class SharezonePlusSupportNote extends StatelessWidget {
  const SharezonePlusSupportNote({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const MaxWidthConstraintBox(
      maxWidth: 710,
      child: MarkdownCenteredText(
        text: 'Du hast noch Fragen zu Sharezone Plus? Schreib uns an '
            '[plus@sharezone.net](mailto:plus@sharezone.net) eine E-Mail und '
            'wir helfen dir gerne weiter.',
      ),
    );
  }
}
