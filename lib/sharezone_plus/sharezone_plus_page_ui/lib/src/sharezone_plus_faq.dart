// Copyright (c) 2024 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:flutter/material.dart';
import 'package:sharezone_widgets/sharezone_widgets.dart';
import 'package:url_launcher/link.dart';

class SharezonePlusFaq extends StatelessWidget {
  const SharezonePlusFaq({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaxWidthConstraintBox(
      maxWidth: 710,
      child: Column(
        children: [
          _WhoIsBehindSharezone(),
          SizedBox(height: 12),
          _IsSharezoneOpenSource(),
          SizedBox(height: 12),
          _DoAlsoGroupMemberGetPlus(),
          SizedBox(height: 12),
          _DoesTheFileStorageLimitAlsoForGroups(),
        ],
      ),
    );
  }
}

class _WhoIsBehindSharezone extends StatelessWidget {
  const _WhoIsBehindSharezone();

  @override
  Widget build(BuildContext context) {
    return ExpansionCard(
      header: const Text('Wer steht hinter Sharezone?'),
      body: const Text(
        'Sharezone wird aktuell von Jonas und Nils entwickelt. Aus unserer '
        'persönlichen Frustration über die Organisation des Schulalltags '
        'während der Schulzeit entstand die Idee für Sharezone. Es ist '
        'unsere Vision, den Schulalltag für alle einfacher und übersichtlicher '
        'zu gestalten.',
      ),
      backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(0.2),
    );
  }
}

class _IsSharezoneOpenSource extends StatelessWidget {
  const _IsSharezoneOpenSource();

  @override
  Widget build(BuildContext context) {
    return ExpansionCard(
      header: const Text('Ist der Quellcode von Sharezone öffentlich?'),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Ja, Sharezone ist Open-Source im Frontend. Du kannst den '
            'Quellcode auf GitHub einsehen:',
          ),
          const SizedBox(height: 12),
          Link(
            uri: Uri.parse('https://sharezone.net/github'),
            builder: (context, followLink) => GestureDetector(
              onTap: followLink,
              child: Text(
                'https://github.com/SharezoneApp/sharezone-app',
                style: TextStyle(
                  color: Theme.of(context).isDarkTheme
                      ? Theme.of(context).colorScheme.primary
                      : darkPrimaryColor,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
          )
        ],
      ),
      backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(0.2),
    );
  }
}

class _DoAlsoGroupMemberGetPlus extends StatelessWidget {
  const _DoAlsoGroupMemberGetPlus();

  @override
  Widget build(BuildContext context) {
    return ExpansionCard(
      header: const Text('Erhalten auch Gruppenmitglieder Sharezone Plus?'),
      body: const Text(
        'Wenn du Sharezone Plus abonnierst, erhält nur dein Account '
        'Sharezone Plus. Deine Gruppenmitglieder erhalten Sharezone Plus '
        'nicht.\n\nJedoch gibt es einzelne Features, von denen auch deine '
        'Gruppenmitglieder profitieren. Solltest du beispielsweise eine '
        'die Kursfarbe von einer Gruppe zu einer Farbe ändern, die nur mit '
        'Sharezone Plus verfügbar ist, so wird diese Farbe auch für deine '
        'Gruppenmitglieder verwendet.',
      ),
      backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(0.2),
    );
  }
}

class _DoesTheFileStorageLimitAlsoForGroups extends StatelessWidget {
  const _DoesTheFileStorageLimitAlsoForGroups();

  @override
  Widget build(BuildContext context) {
    return ExpansionCard(
      header: const Text('Erhält der gesamte Kurs 50 GB Speicherplatz?'),
      body: const Text(
        'Nein, der Speicherplatz von 50 GB mit Sharezone Plus gilt nur für '
        'deinen Account und gilt über alle deine Kurse hinweg.\n\nDu könntest '
        'beispielsweise 20 GB in den Deutsch-Kurs hochladen, 20 GB in den '
        'Mathe-Kurs und hättest noch weitere 10 GB für alle Kurse zur '
        'Verfügung.\n\nDeine Gruppenmitglieder erhalten keinen zusätzlichen '
        'Speicherplatz.',
      ),
      backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(0.2),
    );
  }
}
