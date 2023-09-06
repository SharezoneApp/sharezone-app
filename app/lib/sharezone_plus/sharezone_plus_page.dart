// Copyright (c) 2023 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:sharezone/navigation/models/navigation_item.dart';
import 'package:sharezone/navigation/scaffold/sharezone_main_scaffold.dart';
import 'package:sharezone/privacy_policy/privacy_policy_page.dart';
import 'package:sharezone/util/launch_link.dart';
import 'package:sharezone_widgets/sharezone_widgets.dart';
import 'package:url_launcher/link.dart';

class SharezonePlusPage extends StatelessWidget {
  static String tag = 'sharezone-plus-page';
  const SharezonePlusPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SharezoneMainScaffold(
      navigationItem: NavigationItem.sharezonePlus,
      body: _PageTheme(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: MaxWidthConstraintBox(
              maxWidth: 750,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 18),
                child: SafeArea(
                  child: Column(
                    children: const [
                      _Header(),
                      SizedBox(height: 18),
                      _WhyPlusSharezoneCard(),
                      SizedBox(height: 18),
                      _Advantages(),
                      SizedBox(height: 18),
                      _SubscribeSection(),
                      SizedBox(height: 32),
                      _FaqSection(),
                      SizedBox(height: 18),
                      _SupportNote(),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _PageTheme extends StatelessWidget {
  const _PageTheme({
    required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final baseTheme = Theme.of(context);
    return Theme(
      data: baseTheme.copyWith(
        textTheme: baseTheme.textTheme.copyWith(
          bodyMedium: TextStyle(
            color: Colors.grey[600],
          ),
          headlineSmall: baseTheme.textTheme.headlineSmall?.copyWith(
            fontSize: 18,
          ),
          headlineMedium: baseTheme.textTheme.headlineMedium?.copyWith(
            color: isDarkThemeEnabled(context) ? Colors.white : Colors.black,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      child: child,
    );
  }
}

class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary.withOpacity(0.2),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Icon(
              Icons.star,
              color: darkPrimaryColor,
              size: 30,
            ),
          ),
        ),
        const SizedBox(height: 12),
        Text(
          'Entfalte das gesamte Potential für einen stressfreien Schulalltag.',
          style: Theme.of(context).textTheme.bodyMedium,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

class _WhyPlusSharezoneCard extends StatelessWidget {
  const _WhyPlusSharezoneCard();

  @override
  Widget build(BuildContext context) {
    return MaxWidthConstraintBox(
      maxWidth: 710,
      child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(17.5),
            color: Theme.of(context).colorScheme.primary.withOpacity(0.2),
          ),
          child: Column(
            children: const [
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

class _WhyPlusSharezoneImage extends StatelessWidget {
  const _WhyPlusSharezoneImage();

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(
        maxHeight: 200,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(17.5),
        child: Image.asset(
          'assets/images/jonas-nils.png',
          fit: BoxFit.cover,
          width: double.infinity,
          semanticLabel: 'Ein Bild von Jonas und Nils.',
        ),
      ),
    );
  }
}

class _Advantages extends StatelessWidget {
  const _Advantages();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _AdvantageTile(
          icon: Icon(Icons.favorite),
          title: Text('Unterstützung von Open-Source'),
          description: MarkdownBody(
            data:
                'Sharezone ist Open-Source im Frontend. Das bedeutet, dass jeder den Quellcode von Sharezone einsehen und sogar verbessern kann. Wir glauben, dass Open-Source die Zukunft ist und wollen Sharezone zu einem Vorzeigeprojekt machen.\n\nGitHub: [https://github.com/SharezoneApp/sharezone-app](https://sharezone.net/github)',
            styleSheet: MarkdownStyleSheet(
              a: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    color: Theme.of(context).primaryColor,
                    decoration: TextDecoration.underline,
                  ),
            ),
            onTapLink: (text, href, title) => launchURL(href!),
          ),
        ),
      ],
    );
  }
}

class _AdvantageTile extends StatelessWidget {
  const _AdvantageTile({
    super.key,
    required this.icon,
    required this.title,
    this.subtitle,
    required this.description,
  });

  final Icon icon;
  final Widget title;
  final Widget? subtitle;
  final Widget description;

  @override
  Widget build(BuildContext context) {
    const green = Color(0xFF6FCF97);
    return ExpansionCard(
      header: Row(
        children: [
          Container(
            decoration: BoxDecoration(
              color: green.withOpacity(0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: IconTheme(
                data: IconThemeData(color: green),
                child: icon,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              title,
              if (subtitle != null)
                DefaultTextStyle(
                  style: Theme.of(context).textTheme.bodyMedium!,
                  child: subtitle!,
                ),
            ],
          ),
        ],
      ),
      body: description,
      backgroundColor: Colors.transparent,
    );
  }
}

class _SubscribeSection extends StatelessWidget {
  const _SubscribeSection();

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        _Price(),
        SizedBox(height: 12),
        _SubscribeButton(),
        SizedBox(height: 12),
        _LegalText(),
      ],
    );
  }
}

class _Price extends StatelessWidget {
  const _Price();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          '4,99 €',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        const SizedBox(width: 4),
        Padding(
          padding: const EdgeInsets.only(top: 12),
          child: Text(
            '/Monat',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ),
      ],
    );
  }
}

class _SubscribeButton extends StatelessWidget {
  const _SubscribeButton();

  @override
  Widget build(BuildContext context) {
    return MaxWidthConstraintBox(
      maxWidth: 300,
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: () {},
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            child: Text('Abonnieren'),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: Theme.of(context).primaryColor,
            elevation: 0,
            shadowColor: Colors.transparent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.5),
            ),
            textStyle: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}

class _LegalText extends StatelessWidget {
  const _LegalText();

  @override
  Widget build(BuildContext context) {
    return _MarkdownCenteredText(
      text:
          'Dein ist Abo Monatlich kündbar. Es wird automatisch verlängert, wenn du es nicht mindestens 24 Stunden vor Ablauf der aktuellen Zahlungsperiode über Google Play kündigst. Durch den Kauf bestätigst du, dass du die [Datenschutzerklärung](https://sharezone.net/privacy-policy) un die [AGBs](https://sharezone.net/terms-of-service) gelesen hast.',
    );
  }
}

class _MarkdownCenteredText extends StatelessWidget {
  const _MarkdownCenteredText({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return MarkdownBody(
      data: text,
      styleSheet: MarkdownStyleSheet(
        a: TextStyle(
          color: Theme.of(context).primaryColor,
          decoration: TextDecoration.underline,
        ),
        textAlign: WrapAlignment.center,
      ),
      onTapLink: (text, href, title) {
        if (href == 'https://sharezone.net/privacy-policy') {
          Navigator.pushNamed(context, PrivacyPolicyPage.tag);
          return;
        }
        launchURL(href!);
      },
    );
  }
}

class _FaqSection extends StatelessWidget {
  const _FaqSection();

  @override
  Widget build(BuildContext context) {
    return MaxWidthConstraintBox(
      maxWidth: 710,
      child: Column(
        children: const [
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
      header: Text('Wer steht hinter Sharezone?'),
      body: Text(
          'Sharezone wird aktuell von Jonas und Nils entwickelt. Aus unserer persönlichen Frustration über die Organisation des Schulalltags während der Schulzeit entstand die Idee für Sharezone. Es ist unsere Vision, den Schulalltag für alle einfacher und übersichtlicher zu gestalten.'),
      backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(0.2),
    );
  }
}

class _IsSharezoneOpenSource extends StatelessWidget {
  const _IsSharezoneOpenSource();

  @override
  Widget build(BuildContext context) {
    return ExpansionCard(
      header: Text('Ist der Quellcode von Sharezone öffentlich?'),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Ja, Sharezone ist Open-Source im Frontend. Du kannst den Quellcode auf GitHub einsehen:',
          ),
          const SizedBox(height: 12),
          Link(
            uri: Uri.parse('https://sharezone.net/github'),
            builder: (context, followLink) => GestureDetector(
              onTap: followLink,
              child: Text(
                'https://github.com/SharezoneApp/sharezone-app',
                style: TextStyle(
                  color: isDarkThemeEnabled(context)
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
      header: Text('Erhalten auch Gruppenmitglieder Sharezone Plus?'),
      body: Text(
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
      header: Text('Erhält der gesamte Kurs 50 GB Speicherplatz?'),
      body: Text(
        'Nein, der Speicherplatz von 50 GB mit Sharezone Plus gilt nur für '
        'deinen Account und gilt über alle deine Kurse hinweg.\n\nDu könntest beispielsweise 20 GB in den Deutsch-Kurs hochladen, 20 GB in den Mathe-Kurs und hättest noch weitere 10 GB für alle Kurse zur Verfügung.\n\nDeine Gruppenmitglieder erhalten keinen zusätzlichen Speicherplatz.',
      ),
      backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(0.2),
    );
  }
}

class _SupportNote extends StatelessWidget {
  const _SupportNote();

  @override
  Widget build(BuildContext context) {
    return MaxWidthConstraintBox(
      maxWidth: 710,
      child: _MarkdownCenteredText(
        text:
            'Du hast noch Fragen zu Sharezone Plus? Schreib uns an [plus@sharezone.net](mailto:plus@sharezone.net) eine E-Mail und wir helfen dir gerne weiter.',
      ),
    );
  }
}
