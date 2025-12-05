// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:bloc_provider/bloc_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:group_domain_models/group_domain_models.dart';
import 'package:helper_functions/helper_functions.dart';
import 'package:platform_check/platform_check.dart';
import 'package:share_plus/share_plus.dart';
import 'package:sharezone/onboarding/group_onboarding/logic/group_onboarding_bloc.dart';
import 'package:sharezone/onboarding/group_onboarding/logic/signed_up_bloc.dart';
import 'package:sharezone_widgets/sharezone_widgets.dart';

import 'group_qr_code.dart';

/// Sharecode because it could happend, that the joinLink is null, if the
/// course has a old structure
class LinkSharingButton extends StatelessWidget {
  const LinkSharingButton({super.key, required this.groupInfo});

  final GroupInfo groupInfo;
  static const color = Color(0xFF976aff);

  @override
  Widget build(BuildContext context) {
    final isEnabled = _hasSharecodeOrJoinLink();
    final hasJoinLink = !isEmptyOrNull(groupInfo.joinLink);
    return Expanded(
      child: GrayShimmer(
        enabled: !isEnabled,
        child: IgnorePointer(
          ignoring: !isEnabled,
          child: CircularButton(
            icon: const Icon(Icons.link, color: color),
            // Courses with an old course structure do not have a JoinLink,
            // which is why the sharecode should be used there.
            title: hasJoinLink ? "Link" : "Sharecode",
            // On the web/macOS there are no share options like on Android & iOS, so
            // the link can only be copied.
            subtitle: PlatformCheck.isMobile ? "verschicken" : "kopieren",
            color: color,
            onTap: () async {
              _showShareJoinLinkBox(
                context: context,
                groupInfo: groupInfo,
                hasJoinLink: hasJoinLink,
              );

              if (await _isUserCurrentlyInGroupOnboarding(context) &&
                  context.mounted) {
                _logOnboardingShareLinkAnalytics(context);
              }
            },
          ),
        ),
      ),
    );
  }

  bool _hasSharecodeOrJoinLink() {
    return !(isEmptyOrNull(groupInfo.joinLink) &&
        isEmptyOrNull(groupInfo.sharecode));
  }

  Future<void> _showShareJoinLinkBox({
    required BuildContext context,
    required GroupInfo groupInfo,
    required bool hasJoinLink,
  }) async {
    // On the web/macOS there are no share options like on Android & iOS, so
    // the link can only be copied.
    if (PlatformCheck.isMobile) {
      _openShareOptions(context, groupInfo);
    } else {
      // Courses with an old course structure do not have a JoinLink,
      // which is why the sharecode should be used there.
      if (hasJoinLink) {
        _copyLink(context, groupInfo.joinLink!);
      } else {
        _copySharecode(context, groupInfo.sharecode!);
      }
    }
  }

  Future<bool> _isUserCurrentlyInGroupOnboarding(BuildContext context) async {
    final signUpBloc = BlocProvider.of<SignUpBloc>(context);
    return await signUpBloc.signedUp.first;
  }

  /// Opens native share dialog on Android or iOS.
  void _openShareOptions(BuildContext context, GroupInfo groupInfo) {
    final box = context.findRenderObject() as RenderBox;
    final sharecode = groupInfo.joinLink ?? groupInfo.sharecode!;
    Share.share(
      sharecode,
      sharePositionOrigin: box.localToGlobal(Offset.zero) & box.size,
    );
  }

  void _copyLink(BuildContext context, String link) {
    _copyToClipboard(link);
    showSnackSec(context: context, text: "Link wurde kopiert");
  }

  void _copySharecode(BuildContext context, String sharecode) {
    _copyToClipboard(sharecode);
    showSnackSec(context: context, text: "Sharecode wurde kopiert");
  }

  void _copyToClipboard(String data) {
    Clipboard.setData(ClipboardData(text: data));
  }

  Future<void> _logOnboardingShareLinkAnalytics(BuildContext context) async {
    final groupOnboardingBloc = BlocProvider.of<GroupOnboardingBloc>(context);
    groupOnboardingBloc.logShareQrCode();
  }
}

class ShareThisGroupDialogContent extends StatelessWidget {
  const ShareThisGroupDialogContent({super.key, required this.groupInfo});

  final GroupInfo groupInfo;

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      contentPadding: const EdgeInsets.only(top: 20),
      children: <Widget>[
        DialogWrapper(
          child: SingleChildScrollView(
            child: ShareGroupSection(groupInfo: groupInfo, closeDialog: true),
          ),
        ),
      ],
    );
  }
}

class ShareGroupSection extends StatelessWidget {
  const ShareGroupSection({
    super.key,
    required this.groupInfo,
    this.closeDialog = false,
  });

  final bool closeDialog;
  final GroupInfo groupInfo;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: Text(
            "Lade deine Mitschüler & Lehrer in ${groupInfo.groupType == GroupType.course ? "diese Gruppe" : "diese Klasse"} ein!",
            style: Theme.of(context).textTheme.titleLarge,
            textAlign: TextAlign.center,
          ),
        ),
        const SizedBox(height: 12),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Text(
            "Verschicke einfach den Link zum Beitreten über eine beliebige App oder zeige den QR-Code an, damit deine Mitschüler & Lehrer diesen abscannen können 👍🚀",
            style: TextStyle(
              fontSize: 16,
              color:
                  Theme.of(context).isDarkTheme
                      ? Colors.grey[400]
                      : Colors.grey[600],
            ),
            textAlign: TextAlign.center,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: <Widget>[
            QRCodeButton(groupInfo, closeDialog: closeDialog),
            const SizedBox(width: 12),
            LinkSharingButton(groupInfo: groupInfo),
          ],
        ),
      ],
    );
  }
}
