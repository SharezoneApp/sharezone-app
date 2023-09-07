// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:analytics/analytics.dart';
import 'package:bloc_provider/bloc_provider.dart';
import 'package:flutter/material.dart';
import 'package:group_domain_models/group_domain_models.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:sharezone/blocs/application_bloc.dart';
import 'package:sharezone/groups/group_join/bloc/group_join_bloc.dart';
import 'package:sharezone_common/helper_functions.dart';
import 'package:sharezone_utils/platform.dart';
import 'package:sharezone_widgets/sharezone_widgets.dart';

import '../group_join_result_dialog.dart';

class GroupJoinTextField extends StatefulWidget implements PreferredSizeWidget {
  const GroupJoinTextField({Key? key}) : super(key: key);

  @override
  Size get preferredSize => Size.fromHeight(140);

  @override
  _GroupJoinTextFieldState createState() => _GroupJoinTextFieldState();
}

class _GroupJoinTextFieldState extends State<GroupJoinTextField> {
  final sharecodeFieldFocusNode = FocusNode();
  final sharecodeFieldTextController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (!PlatformCheck.isWeb) {
      copySharecodeFromClipboardOrOpenKeyboard();
    }
  }

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<GroupJoinBloc>(context);
    return MaxWidthConstraintBox(
      child: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(
              left: 32,
              right: 32,
              top: 8,
              bottom: 8,
            ),
            child: Theme(
              data: Theme.of(context).copyWith(
                primaryColor: Colors.white,
                colorScheme:
                    ColorScheme.fromSwatch().copyWith(secondary: Colors.white),
              ),
              child: TextField(
                maxLength: 6,
                maxLines: 1,
                focusNode: sharecodeFieldFocusNode,
                controller: sharecodeFieldTextController,
                style: TextStyle(color: Colors.white),
                onChanged: (newText) {
                  if (_isValidText(newText)) {
                    bloc.enterValue(newText);
                    final groupJoinResultDialog = GroupJoinResultDialog(bloc);
                    groupJoinResultDialog.show(context);
                  }
                },
                cursorColor: Colors.white,
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  labelText: 'Sharecode',
                  hintText: "z.B. Qb32vF",
                  suffixIcon: IconButton(
                    tooltip: 'QR-Code scannen',
                    onPressed: () async {
                      hideKeyboard(context: context);
                      final qrCode = await _scanQRCode();
                      if (_isValidQrCode(qrCode)) {
                        bloc.enterValue(qrCode);
                        final groupJoinResultDialog =
                            GroupJoinResultDialog(bloc);
                        groupJoinResultDialog.show(context);
                      }
                    },
                    icon: PlatformSvg.asset(
                      "assets/icons/qr-code.svg",
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 18),
        ],
      ),
    );
  }

  bool _isValidQrCode(String? qrCodeText) => isNotEmptyOrNull(qrCodeText);

  bool _isValidText(String newText) {
    return isNotEmptyOrNull(newText) && newText.length == 6;
  }

  Future<String?> _scanQRCode() async {
    return showQrCodeScanner(
      context,
      title: const Text('QR-Code scannen'),
      description:
          const Text('Scanne einen QR-Code, um einer Gruppe beizutreten.'),
      settings: const RouteSettings(name: 'scan-sharecode-qr-code-page'),
    );
  }

  void copySharecodeFromClipboardOrOpenKeyboard() {
    final bloc = BlocProvider.of<GroupJoinBloc>(context);
    bloc.getSharecodeFromClipboard().then((sharecode) {
      if (sharecode == null) {
        _openKeyboardForSharecodeField();
      } else {
        showCopySharecodeFromClipboardDialog(sharecode);
      }
    });
  }

  void _openKeyboardForSharecodeField() {
    FocusManager.instance.primaryFocus?.unfocus();
  }

  Future<void> showCopySharecodeFromClipboardDialog(Sharecode sharecode) async {
    final bloc = BlocProvider.of<GroupJoinBloc>(context);

    final result = await showLeftRightAdaptiveDialog<bool>(
      context: context,
      defaultValue: false,
      title: "Sharecode einfügen",
      content: Text(
          'Möchtest du den Sharecode "${sharecode.value}" aus deiner Zwischenablage übernehmen?'),
      left: AdaptiveDialogAction(
        title: 'Nein',
        popResult: false,
      ),
      right: AdaptiveDialogAction(
        title: 'Ja',
        popResult: true,
        isDefaultAction: true,
      ),
    );

    if (result == true) {
      bloc.enterValue(sharecode.value);
      sharecodeFieldTextController.text = sharecode.value;
      _logPastingSharecodeFromClipboard(context);
      final groupJoinResultDialog = GroupJoinResultDialog(bloc);
      groupJoinResultDialog.show(context);
    } else
      _openKeyboardForSharecodeField();
  }

  void _logPastingSharecodeFromClipboard(BuildContext context) {
    final analytics = BlocProvider.of<SharezoneContext>(context).analytics;
    analytics.log(NamedAnalyticsEvent(name: 'paste_sharecode_from_clipboard'));
  }
}
