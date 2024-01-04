// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:analytics/analytics.dart';
import 'package:authentification_base/authentification_analytics.dart';
import 'package:bloc_provider/bloc_provider.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sharezone/account/use_account_on_multiple_devices_instruction.dart';
import 'package:sharezone/auth/email_and_password_link_page.dart';
import 'package:sharezone/main/application_bloc.dart';
import 'package:sharezone/util/navigation_service.dart';
import 'package:sharezone_widgets/sharezone_widgets.dart';
import 'package:user/user.dart';

import 'account_page_bloc.dart';

class RegisterAccountSection extends StatelessWidget {
  const RegisterAccountSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 0, 12, 0),
      child: Column(
        children: <Widget>[
          const Divider(height: 32),
          Container(
            padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
            decoration: BoxDecoration(
              color: Colors.orange.withOpacity(0.15),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Text("Du bist nur anonym angemeldet!",
                style: TextStyle(color: Colors.orange, fontSize: 18)),
          ),
          const SizedBox(height: 12),
          const Text(
            "Übertrage jetzt deinen Account auf ein richtiges Konto, um von folgenden Vorteilen zu profitieren:",
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey, fontSize: 12),
          ),
          const SizedBox(height: 12),
          const ListTile(
            contentPadding: EdgeInsets.only(left: 12),
            leading: Icon(Icons.check, color: Color(0xFF41d876)),
            title: Text("Automatisches Backup"),
            subtitle: Text(
                "Weiterhin Zugriff auf die Daten bei Verlust des Smartphones"),
          ),
          const SizedBox(height: 6),
          const ListTile(
            contentPadding: EdgeInsets.only(left: 12),
            leading: Icon(Icons.check, color: Color(0xFF41d876)),
            title: Text("Nutzung auf mehreren Geräten"),
            subtitle:
                Text("Daten werden zwischen mehreren Geräten synchronisiert"),
          ),
          const SizedBox(height: 16),
          _SignInMethods(),
          const SizedBox(height: 8),
          Text(
            "Melde dich jetzt an und übertrage deine Daten! Die Anmeldung ist aus datenschutzrechtlichen Gründen erst ab 16 Jahren erlaubt.",
            style: TextStyle(
                color: Theme.of(context).isDarkTheme
                    ? Colors.grey
                    : Colors.grey[600],
                fontSize: 10),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _SignInMethods extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width < 550) {
      return Column(
        children: <Widget>[
          _AppleButton.long(),
          const SizedBox(height: 8),
          _GoogleButton.long(),
          const SizedBox(height: 8),
          _EmailButton.long(),
        ],
      );
    }

    return Row(
      children: <Widget>[
        Expanded(child: _EmailButton.short()),
        const SizedBox(width: 8),
        Expanded(child: _AppleButton.short()),
        const SizedBox(width: 8),
        Expanded(child: _GoogleButton.short()),
      ],
    );
  }
}

class _GoogleButton extends StatelessWidget {
  const _GoogleButton._(this.title);
  factory _GoogleButton.short() => const _GoogleButton._('Google');
  factory _GoogleButton.long() => const _GoogleButton._('Mit Google anmelden');

  final String title;

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<AccountPageBloc>(context);
    return _SignUpButton(
      icon: Image.asset(
        "assets/logo/google-favicon.png",
        width: 24,
        height: 24,
      ),
      name: title,
      onTap: () async {
        final result = await bloc.linkWithGoogleAndHandleExceptions();
        if (result == LinkAction.credentialAlreadyInUse && context.mounted) {
          showCredentialAlreadyInUseDialog(context);
        }
      },
    );
  }
}

class _AppleButton extends StatelessWidget {
  const _AppleButton._(this.title);

  factory _AppleButton.short() => const _AppleButton._('Apple');
  factory _AppleButton.long() => const _AppleButton._('Mit Apple anmelden');

  final String title;

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<AccountPageBloc>(context);
    return _SignUpButton(
      icon: Icon(FontAwesomeIcons.apple, color: Colors.grey[700]),
      name: title,
      onTap: () async {
        final result = await bloc.linkWithAppleAndHandleExceptions();
        if (result == LinkAction.credentialAlreadyInUse && context.mounted) {
          showCredentialAlreadyInUseDialog(context);
        }
      },
    );
  }
}

class _EmailButton extends StatelessWidget {
  const _EmailButton._(this.title);
  factory _EmailButton.short() => const _EmailButton._('E-Mail');
  factory _EmailButton.long() => const _EmailButton._('Mit E-Mail anmelden');

  final String title;

  @override
  Widget build(BuildContext context) {
    final userGateway = BlocProvider.of<SharezoneContext>(context).api.user;
    return StreamBuilder<AppUser?>(
      stream: userGateway.userStream,
      builder: (context, snapshot) {
        final user = snapshot.data;
        return _SignUpButton(
          icon: Icon(Icons.email, color: Colors.grey[700]),
          name: title,
          onTap: () async {
            if (user != null) {
              final confirmed = await pushWithDefault<bool>(
                context,
                EmailAndPasswordLinkPage(user: user),
                defaultValue: false,
                name: EmailAndPasswordLinkPage.tag,
              );
              if (confirmed && context.mounted) {
                _showConfirmationSnackBar(context);
              }
            }
          },
        );
      },
    );
  }

  void _showConfirmationSnackBar(BuildContext context) {
    showSnackSec(
      context: context,
      text: "Dein Account mit einer E-Mail Konto verknüpft.",
    );
  }
}

class _SignUpButton extends StatelessWidget {
  const _SignUpButton({
    required this.name,
    required this.icon,
    required this.onTap,
  });

  final String name;
  final Widget icon;
  final VoidCallback onTap;

  static final _borderRadius = BorderRadius.circular(7.5);

  @override
  Widget build(BuildContext context) {
    final color =
        Theme.of(context).isDarkTheme ? Colors.grey[400] : Colors.grey[800];
    return InkWell(
      borderRadius: _borderRadius,
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
        decoration: BoxDecoration(
          color: color!.withOpacity(0.10),
          borderRadius: _borderRadius,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            icon,
            const SizedBox(width: 8),
            Text(
              name,
              style: TextStyle(fontSize: 16, color: color),
            ),
            const SizedBox(width: 8),
          ],
        ),
      ),
    );
  }
}

Future<void> showCredentialAlreadyInUseDialog(BuildContext context) async {
  final showInstruction = await showLeftRightAdaptiveDialog<bool>(
      context: context,
      left: const AdaptiveDialogAction<bool>(
        popResult: false,
        title: "Schließen",
      ),
      right: const AdaptiveDialogAction<bool>(
        popResult: true,
        title: "Anleitung zeigen",
      ),
      title: "Diese E-Mail wird schon verwendet!",
      content: const Text(
          "So wie es aussieht, hast du versehentlich einen zweiten Sharezone-Account erstellt. Lösche einfach diesen Account und melde dich mit deinem richtigen Account an.\n\nFür den Fall, dass du nicht genau weißt, wie das funktioniert, haben wir für dich eine Anleitung vorbereitet :)"));

  if (showInstruction != null && showInstruction && context.mounted) {
    final LinkProviderAnalytics analytics =
        LinkProviderAnalytics(Analytics(getBackend()));
    analytics.logShowedUseMultipleDevicesInstruction();
    Navigator.pushNamed(context, UseAccountOnMultipleDevicesInstructions.tag);
  }
}
