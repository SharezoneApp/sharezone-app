// Copyright (c) 2024 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:flutter/material.dart';
import 'package:sharezone_widgets/sharezone_widgets.dart';

class WhyPlusSharezoneCard extends StatelessWidget {
  const WhyPlusSharezoneCard({super.key});

  @override
  Widget build(BuildContext context) {
    return MaxWidthConstraintBox(
      maxWidth: 710,
      child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(17.5),
            color: Theme.of(context).colorScheme.primary.withOpacity(0.2),
          ),
          child: const Column(
            children: [
              _WhyPlusSharezoneImage(),
              Padding(
                padding: EdgeInsets.all(12),
                child: Column(
                  children: [
                    _WhyPlusSharezoneHeadline(),
                    SizedBox(height: 8),
                    _WhyPlusSharezoneText(),
                  ],
                ),
              ),
            ],
          )),
    );
  }
}

class _WhyPlusSharezoneImage extends StatelessWidget {
  const _WhyPlusSharezoneImage();

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(
        maxHeight: 200,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(17.5),
        child: Image.asset(
          'packages/sharezone_plus_page_ui/assets/jonas-nils.png',
          fit: BoxFit.cover,
          width: double.infinity,
          semanticLabel: 'Ein Bild von Jonas und Nils.',
        ),
      ),
    );
  }
}

class _WhyPlusSharezoneHeadline extends StatelessWidget {
  const _WhyPlusSharezoneHeadline();

  @override
  Widget build(BuildContext context) {
    return Text(
      'Warum kostet Sharezone Plus Geld?',
      style: Theme.of(context).textTheme.headlineSmall,
    );
  }
}

class _WhyPlusSharezoneText extends StatelessWidget {
  const _WhyPlusSharezoneText();

  @override
  Widget build(BuildContext context) {
    return Text(
      'Neben einem Studium können wir, Jonas und Nils, die monatlichen Kosten von 1.000 € für Sharezone nicht selbst tragen. Daher haben wir Sharezone Plus entwickelt - der Schlüssel zur Fortführung und Werbefreiheit unserer App.',
      style: Theme.of(context).textTheme.bodyMedium,
      textAlign: TextAlign.center,
    );
  }
}
