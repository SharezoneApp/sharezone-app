// Copyright (c) 2024 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:flutter/widgets.dart';
import 'package:sharezone_plus_page_ui/src/markdown_centered_text.dart';

class SharezonePlusLegalText extends StatelessWidget {
  const SharezonePlusLegalText({super.key});

  @override
  Widget build(BuildContext context) {
    return const MarkdownCenteredText(
      text:
          'Dein Abo ist monatlich kündbar. Es wird automatisch verlängert, wenn du es nicht mindestens 24 Stunden vor Ablauf der aktuellen Zahlungsperiode über Google Play kündigst. Durch den Kauf bestätigst du, dass du die [AGBs](https://sharezone.net/terms-of-service) gelesen hast.',
    );
  }
}
