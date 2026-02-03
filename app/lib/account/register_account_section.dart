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
import 'package:sharezone_localizations/sharezone_localizations.dart';

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
              color: Colors.orange.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              context.l10n.registerAccountAnonymousInfoTitle,
              style: const TextStyle(color: Colors.orange, fontSize: 18),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            context.l10n.registerAccountBenefitsIntro,
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.grey, fontSize: 12),
          ),
          const SizedBox(height: 12),
          ListTile(
            contentPadding: const EdgeInsets.only(left: 12),
            leading: const Icon(Icons.check, color: Color(0xFF41d876)),
            title: Text(context.l10n.registerAccountBenefitBackupTitle),
            subtitle: Text(context.l10n.registerAccountBenefitBackupSubtitle),
          ),
          const SizedBox(height: 6),
          ListTile(
            contentPadding: const EdgeInsets.only(left: 12),
            leading: const Icon(Icons.check, color: Color(0xFF41d876)),
            title: Text(context.l10n.registerAccountBenefitMultiDeviceTitle),
            subtitle: Text(
              context.l10n.registerAccountBenefitMultiDeviceSubtitle,
            ),
          ),
          const SizedBox(height: 16),
          _SignInMethods(),
          const SizedBox(height: 8),
          Text(
            context.l10n.registerAccountAgeNoticeText,
            style: TextStyle(
              color:
                  Theme.of(context).isDarkTheme
                      ? Colors.grey
                      : Colors.grey[600],
              fontSize: 10,
            ),
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
  const _GoogleButton._({required this.isLong});
  factory _GoogleButton.short() => const _GoogleButton._(isLong: false);
  factory _GoogleButton.long() => const _GoogleButton._(isLong: true);

  final bool isLong;

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<AccountPageBloc>(context);
    final title =
        isLong
            ? context.l10n.registerAccountGoogleButtonLong
            : context.l10n.registerAccountGoogleButtonShort;
    return _SignUpButton(
      icon: Image.asset(
        "assets/logo/google-favicon.png",
        width: 24,
        height: 24,
      ),
      name: title,
      onTap: () async {
        final result = await bloc.linkWithGoogleAndHandleExceptions();
        if (!context.mounted) return;
        if (result == LinkAction.credentialAlreadyInUse) {
          await showCredentialAlreadyInUseDialog(context);
        } else if (result == LinkAction.finished) {
          showSnackSec(
            context: context,
            text: context.l10n.accountLinkGoogleConfirmation,
          );
        }
      },
    );
  }
}

class _AppleButton extends StatelessWidget {
  const _AppleButton._({required this.isLong});

  factory _AppleButton.short() => const _AppleButton._(isLong: false);
  factory _AppleButton.long() => const _AppleButton._(isLong: true);

  final bool isLong;

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<AccountPageBloc>(context);
    final title =
        isLong
            ? context.l10n.registerAccountAppleButtonLong
            : context.l10n.registerAccountAppleButtonShort;
    return _SignUpButton(
      icon: Icon(FontAwesomeIcons.apple, color: Colors.grey[700]),
      name: title,
      onTap: () async {
        final result = await bloc.linkWithAppleAndHandleExceptions();
        if (!context.mounted) return;
        if (result == LinkAction.credentialAlreadyInUse) {
          await showCredentialAlreadyInUseDialog(context);
        } else if (result == LinkAction.finished) {
          showSnackSec(
            context: context,
            text: context.l10n.accountLinkAppleConfirmation,
          );
        }
      },
    );
  }
}

class _EmailButton extends StatelessWidget {
  const _EmailButton._({required this.isLong});

  factory _EmailButton.short() => const _EmailButton._(isLong: false);
  factory _EmailButton.long() => const _EmailButton._(isLong: true);

  final bool isLong;

  @override
  Widget build(BuildContext context) {
    final userGateway = BlocProvider.of<SharezoneContext>(context).api.user;
    final title =
        isLong
            ? context.l10n.registerAccountEmailButtonLong
            : context.l10n.registerAccountEmailButtonShort;
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
      text: context.l10n.registerAccountEmailLinkConfirmation,
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
          color: color!.withValues(alpha: 0.10),
          borderRadius: _borderRadius,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            icon,
            const SizedBox(width: 8),
            Text(name, style: TextStyle(fontSize: 16, color: color)),
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
    left: AdaptiveDialogAction<bool>(
      popResult: false,
      title: context.l10n.commonActionsClose,
    ),
    right: AdaptiveDialogAction<bool>(
      popResult: true,
      title: context.l10n.registerAccountShowInstructionAction,
    ),
    title: context.l10n.registerAccountEmailAlreadyUsedTitle,
    content: Text(context.l10n.registerAccountEmailAlreadyUsedContent),
  );

  if (showInstruction != null && showInstruction && context.mounted) {
    final LinkProviderAnalytics analytics = LinkProviderAnalytics(
      AnalyticsProvider.ofOrNullObject(context),
    );
    analytics.logShowedUseMultipleDevicesInstruction();
    Navigator.pushNamed(context, UseAccountOnMultipleDevicesInstructions.tag);
  }
}
