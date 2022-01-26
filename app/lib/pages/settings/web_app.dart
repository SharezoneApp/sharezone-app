// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:authentification_qrcode/authentification_qrcode.dart';
import 'package:barcode_scan/barcode_scan.dart';
import 'package:bloc_provider/bloc_provider.dart';
import 'package:crash_analytics/crash_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:sharezone/blocs/application_bloc.dart';
import 'package:sharezone/groups/src/widgets/contact_support.dart';
import 'package:sharezone/util/launch_link.dart';
import 'package:sharezone/widgets/avatar_card.dart';
import 'package:sharezone_widgets/state_sheet.dart';
import 'package:sharezone_widgets/svg.dart';
import 'package:sharezone_widgets/theme.dart';
import 'package:sharezone_widgets/widgets.dart';

class WebAppSettingsPage extends StatelessWidget {
  static const tag = 'web-app-settings-page';
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
      appBar: AppBar(title: const Text("Web-App"), centerTitle: true),
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
      bottomNavigationBar: ContactSupport(),
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
            child: PlatformSvg.asset("assets/icons/desktop.svg")),
      ),
      children: <Widget>[
        const Text("Sharezone für's Web!", style: TextStyle(fontSize: 26)),
        const SizedBox(height: 4),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 12),
          child: MarkdownBody(
            data:
                "Besuche für weitere Informationen einfach https://www.sharezone.net.",
            selectable: true,
            styleSheet: MarkdownStyleSheet.fromTheme(Theme.of(context))
                .copyWith(
                    a: linkStyle(context, 14),
                    p: const TextStyle(fontSize: 14, color: Colors.grey),
                    textAlign: WrapAlignment.center),
            onTapLink: (url, _, __) => launchURL(url, context: context),
          ),
        ),
      ],
    );
  }
}

class _ScanQrCode extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        CustomCardListTile(
          icon: PlatformSvg.asset(
            'assets/icons/qr-code.svg',
            height: 24,
            width: 24,
            color: isDarkThemeEnabled(context) ? Colors.white : Colors.black,
          ),
          title: "QR-Code scannen",
          onTap: () async {
            final qrCode = await _scanQRCode();
            if (qrCode != null) {
              final hostBloc =
                  BlocProvider.of<QrSignInAuthentificationDeviceBloc>(context);
              final futureResult = hostBloc.authenticateUserViaQrCodeId(qrCode);
              showSimpleStateDialog(context, futureResult);
              print("qrcode: $qrCode");
            }
          },
        ),
        const SizedBox(height: 6),
        Text(
          "Mithilfe der Anmeldung über einen QR-Code kannst du dich in der Web-App anmelden, ohne ein Passwort einzugeben. Besonders hilfreich ist das bei der Nutzung eines öffentlichen PCs.",
          style: TextStyle(
            color: Colors.grey,
            fontSize: 11.5,
          ),
          textAlign: TextAlign.center,
        )
      ],
    );
  }

  Future<String> _scanQRCode() async {
    try {
      final scanResult = await BarcodeScanner.scan();
      return scanResult;
    } catch (e) {
      getCrashAnalytics().recordError(e, null);
      return null;
    }
  }
}
