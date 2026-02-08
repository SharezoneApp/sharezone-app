// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:bloc_provider/bloc_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:group_domain_models/group_domain_models.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:sharezone/onboarding/group_onboarding/logic/group_onboarding_bloc.dart';
import 'package:sharezone/onboarding/group_onboarding/logic/signed_up_bloc.dart';
import 'package:sharezone_localizations/sharezone_localizations.dart';
import 'package:sharezone_widgets/sharezone_widgets.dart';

class GroupQrCode extends StatelessWidget {
  final GroupInfo groupInfo;

  const GroupQrCode({super.key, required this.groupInfo});
  @override
  Widget build(BuildContext context) {
    return QrImageView(
      backgroundColor: Colors.white,
      data: groupInfo.joinLink ?? groupInfo.sharecode ?? "",
      // See https://www.qrcode.com/en/about/version.html for more information
      // about QR code versions.
      version: 5, // 37x37 modules
      errorCorrectionLevel: QrErrorCorrectLevel.M, // ~15% error correction
    );
  }
}

class QRCodeButton extends StatelessWidget {
  const QRCodeButton(this.groupInfo, {super.key, required this.closeDialog});

  final bool closeDialog;
  final GroupInfo groupInfo;
  final Color color = const Color(0xFF3a8df1);

  Future<void> showQRCode(BuildContext context) async {
    if (closeDialog) {
      Navigator.pop(context); // Closing dialog
      await Future.delayed(
        const Duration(milliseconds: 100),
      ); // Waiting for closing
    }
    if (!context.mounted) return;

    showModalBottomSheet<void>(
      context: context,
      builder: (context) => _QRCodeBottomSheet(groupInfo),
    );

    final signUpBloc = BlocProvider.of<SignUpBloc>(context);
    if (await signUpBloc.signedUp.first && context.mounted) {
      _logOnboardingAnalytics(context);
    }
  }

  Future<void> _logOnboardingAnalytics(BuildContext context) async {
    final groupOnboardingBloc = BlocProvider.of<GroupOnboardingBloc>(context);
    groupOnboardingBloc.logShareQrCode();
  }

  @override
  Widget build(BuildContext context) {
    final joinLinkIsEmpty =
        groupInfo.joinLink == null || groupInfo.joinLink!.isEmpty;
    final publicKeyIsEmpty =
        groupInfo.sharecode == null || groupInfo.sharecode!.isEmpty;
    final isEnabled = !(joinLinkIsEmpty && publicKeyIsEmpty);
    return Expanded(
      child: GrayShimmer(
        enabled: !isEnabled,
        child: CircularButton(
          icon: SvgPicture.asset(
            "assets/icons/qr-code.svg",
            colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
            width: 23.5,
            height: 23.5,
          ),
          title: context.l10n.groupsQrCodeTitle,
          subtitle: context.l10n.groupsQrCodeSubtitle,
          color: color,
          onTap: isEnabled ? () => showQRCode(context) : null,
        ),
      ),
    );
  }
}

class _QRCodeBottomSheet extends StatelessWidget {
  const _QRCodeBottomSheet(this.groupInfo);

  final GroupInfo groupInfo;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          const Align(alignment: Alignment.centerRight, child: CloseButton()),
          const SizedBox(height: 2),
          SizedBox(
            height: 200,
            width: 200,
            child: GroupQrCode(groupInfo: groupInfo),
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 12,
            ).add(const EdgeInsets.only(bottom: 20)),
            child: const Text(
              "Was muss ich machen?\n"
              "Nun muss dein Mitschüler oder dein Lehrer den QR-Code abscannen, indem er auf der \"Meine Kurse\" Seite auf \"Kurs beitreten\" klickt.",
              style: TextStyle(color: Colors.grey),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
