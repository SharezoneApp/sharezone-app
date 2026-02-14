// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'dart:developer';

import 'package:authentification_qrcode/authentification_qrcode.dart';
import 'package:bloc_provider/bloc_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_svg/svg.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:sharezone/groups/src/widgets/contact_support.dart';
import 'package:sharezone/main/application_bloc.dart';
import 'package:sharezone/widgets/avatar_card.dart';
import 'package:sharezone_localizations/sharezone_localizations.dart';
import 'package:sharezone_utils/launch_link.dart';
import 'package:sharezone_widgets/sharezone_widgets.dart';

class WebAppSettingsPage extends StatelessWidget {
  static const tag = 'web-app-settings-page';

  const WebAppSettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final sharezoneContext = BlocProvider.of<SharezoneContext>(context);
    return BlocProvider(
      bloc: QrSignInAuthentificationDeviceBloc(
        uID: sharezoneContext.api.uID,
        firestore: sharezoneContext.api.references.firestore,
        appFunctions: sharezoneContext.api.references.functions,
      ),
      child: _InnerWebAppSettingsPage(),
    );
  }
}

class _InnerWebAppSettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.websiteNavWebApp),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: SafeArea(
          child: Column(
            children: <Widget>[
              _Header(),
              const SizedBox(height: 16),
              _ScanQrCode(),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const ContactSupport(),
    );
  }
}

class _Header extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AvatarCard(
      crossAxisAlignment: CrossAxisAlignment.center,
      avatarBackgroundColor: Colors.white,
      icon: Padding(
        padding: const EdgeInsets.only(left: 6),
        child: SizedBox(
          width: 65,
          height: 65,
          child: SvgPicture.asset("assets/icons/desktop.svg"),
        ),
      ),
      children: <Widget>[
        Text(
          context.l10n.webAppSettingsHeadline,
          style: const TextStyle(fontSize: 26),
        ),
        const SizedBox(height: 4),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: MarkdownBody(
            data: context.l10n.webAppSettingsDescription,
            selectable: true,
            styleSheet: MarkdownStyleSheet.fromTheme(
              Theme.of(context),
            ).copyWith(
              a: linkStyle(context, 14),
              p: const TextStyle(fontSize: 14, color: Colors.grey),
              textAlign: WrapAlignment.center,
            ),
            onTapLink: (url, _, _) => launchURL(url, context: context),
          ),
        ),
      ],
    );
  }
}

class _ScanQrCode extends StatelessWidget {
  Future<String?> _scanQRCode(BuildContext context) async {
    return showQrCodeScanner(
      context,
      title: Text(context.l10n.webAppSettingsScanQrCodeTitle),
      description: Text(context.l10n.webAppSettingsScanQrCodeDescription),
      settings: const RouteSettings(name: 'scan-web-login-qr-code-page'),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        CustomCardListTile(
          icon: SvgPicture.asset(
            'assets/icons/qr-code.svg',
            height: 24,
            width: 24,
            colorFilter: ColorFilter.mode(
              Theme.of(context).isDarkTheme ? Colors.white : Colors.black,
              BlendMode.srcIn,
            ),
          ),
          title: context.l10n.webAppSettingsScanQrCodeTitle,
          onTap: () async {
            final qrCode = await _scanQRCode(context);
            if (qrCode != null && context.mounted) {
              final hostBloc =
                  BlocProvider.of<QrSignInAuthentificationDeviceBloc>(context);
              final futureResult = hostBloc.authenticateUserViaQrCodeId(qrCode);
              showSimpleStateDialog(context, futureResult);
              log("qrcode: $qrCode");
            }
          },
        ),
        const SizedBox(height: 6),
        Text(
          context.l10n.webAppSettingsQrCodeHint,
          style: const TextStyle(color: Colors.grey, fontSize: 11.5),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
