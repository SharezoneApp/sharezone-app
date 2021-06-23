import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sharezone_website/page.dart';
import 'package:url_launcher/url_launcher.dart';

import 'widgets/avatar_card.dart';
import 'widgets/max_width_constraint_box.dart';
import 'widgets/section.dart';
import 'widgets/shadow_card.dart';
import 'widgets/snackbars.dart';
import 'widgets/svg.dart';

const phoneNumber = '+49 1516 7754541';

class SupportPage extends StatelessWidget {
  static const String tag = 'support-page';

  @override
  Widget build(BuildContext context) {
    return PageTemplate(
      children: [
        Section(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              _Header(),
              _EmailTile(),
              _WhatsAppTile(),
              _TelegramTile(),
              const SizedBox(height: 18),
            ],
          ),
        ),
      ],
    );
  }
}

class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
    return AvatarCard(
      crossAxisAlignment: CrossAxisAlignment.center,
      avatarBackgroundColor: Colors.white,
      icon: Padding(
        padding: const EdgeInsets.only(left: 6),
        child: SizedBox(
            width: 70,
            height: 70,
            child: PlatformSvg.asset('assets/icons/confused.svg')),
      ),
      children: const <Widget>[
        Text(
          'Du brauchst Hilfe?',
          style: TextStyle(fontSize: 26),
        ),
        SizedBox(height: 4),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 12),
          child: Text(
            'Kontaktiere uns einfach über einen Kanal deiner Wahl und wir werden dir sofort weiterhelfen 😉\n\nIn der Regel antworten wir von Mo. - So. innerhalb von wenigen Stunden.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14, color: Colors.grey),
          ),
        ),
      ],
    );
  }
}

class _SupportCard extends StatelessWidget {
  final Widget icon;
  final String title, subtitle;
  final VoidCallback onPressed;

  const _SupportCard(
      {Key key, this.icon, this.title, this.subtitle, this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: CustomCard(
        child: ListTile(
          leading: SizedBox(
            width: 30,
            height: 30,
            child: icon,
          ),
          title: Text(title),
          subtitle: subtitle != null ? Text(subtitle) : null,
          onTap: onPressed,
        ),
      ),
    );
  }
}

class _EmailTile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return _SupportCard(
      icon: PlatformSvg.asset(
        'assets/icons/email.svg',
        color: Theme.of(context).primaryColor,
      ),
      title: 'support@sharezone.net',
      subtitle: 'E-Mail',
      onPressed: () async {
        final url = Uri.encodeFull(
            'mailto:support@sharezone.net?subject=Ich brauche eure Hilfe! 😭');
        if (await canLaunch(url)) {
          launch(url);
        } else {
          showSnackSec(
            context: context,
            text: 'E-Mail: support@sharezone.net',
          );
        }
      },
    );
  }
}

class _WhatsAppTile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    const name = 'WhatsApp';
    return _SupportCard(
      icon: PlatformSvg.asset(
        'assets/icons/whatsapp.svg',
        color: Theme.of(context).primaryColor,
      ),
      title: phoneNumber,
      subtitle: name,
      onPressed: () async {
        final acceptedPrivacyTerms =
            await _showPrivacyWarning(context: context, serviceName: name) ??
                false;
        if (acceptedPrivacyTerms) {
          await _openWhatsAppOtherwiseCopyNumber(context);
        }
      },
    );
  }

  Future<void> _openWhatsAppOtherwiseCopyNumber(BuildContext context) async {
    final url =
        'https://api.whatsapp.com/send?phone=${numberWithoutSpacesAndPlus()}';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      Clipboard.setData(ClipboardData(text: phoneNumber));
      showSnackSec(
        context: context,
        text: 'Telefonnummer wurde in die Zwischenablage kopiert',
      );
    }
  }

  String numberWithoutSpacesAndPlus() {
    return phoneNumber.substring(1, phoneNumber.length).replaceAll(' ', '');
  }
}

class _TelegramTile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    const name = 'Telegram';
    return _SupportCard(
      icon: PlatformSvg.asset('assets/icons/telegram.svg'),
      title: phoneNumber,
      subtitle: name,
      onPressed: () async {
        final acceptedPrivacyTerms =
            await _showPrivacyWarning(context: context, serviceName: name) ??
                false;
        if (acceptedPrivacyTerms) {
          await _openTelegramOtherwiseCopyNumber(context);
        }
      },
    );
  }

  Future<void> _openTelegramOtherwiseCopyNumber(BuildContext context) async {
    const url = 'http://t.me/SharezoneApp';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      Clipboard.setData(ClipboardData(text: phoneNumber));
      showSnack(
        context: context,
        text: 'Telefonnummer wurde in die Zwischenablage kopiert',
      );
    }
  }
}

Future<bool> _showPrivacyWarning(
    {@required BuildContext context, @required String serviceName}) {
  return showDialog<bool>(
    context: context,
    builder: (context) => MaxWidthConstraintBox(
      child: AlertDialog(
        title: const Text("Datenschutz"),
        content: Text(
            "Um uns über $serviceName zu kontaktieren, musst du min. 16 Jahre alt sein (hat datenschutzrechtliche Gründe) und die Datenschutzbestimmungen von $serviceName akzeptieren. Alternativ kannst du uns eine E-Mail schreiben."),
        actions: [
          FlatButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text("Abbrechen".toUpperCase()),
            textColor: Theme.of(context).primaryColor,
          ),
          FlatButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text("Zustimmen".toUpperCase()),
            textColor: Theme.of(context).primaryColor,
          ),
        ],
      ),
    ),
  );
}
