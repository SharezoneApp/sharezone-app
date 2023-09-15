// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sharezone_widgets/sharezone_widgets.dart';

class StateDialog {
  final Stream<StateDialogContent> stateSheetContent;

  const StateDialog(this.stateSheetContent);

  Future<void> _show(
    BuildContext context, {
    required ValueChanged<BuildContext> onReceivedContext,
  }) async {
    await showDialog(
      context: context,
      builder: (context) => _StateDialogWidget(
        stateDialogContent: stateSheetContent,
        onReceivedContext: onReceivedContext,
      ),
    );
  }

  Future<void> showDialogAutoPop(
    BuildContext context, {
    required Future<bool> future,
    Duration delay = const Duration(milliseconds: 250),
  }) async {
    BuildContext? dialogContext;

    final dialogPop = _show(
      context,
      onReceivedContext: (context) => dialogContext = context,
    );

    bool hasDialogPopped = false;
    dialogPop.then((_) => hasDialogPopped = true);
    future.then((result) async {
      if (result == true) {
        await Future.delayed(delay);
        if (!hasDialogPopped && dialogContext?.mounted == true) {
          // Because we want to pop the dialog, we need to use the BuildContext
          // of the dialog.
          //
          // ignore: use_build_context_synchronously
          Navigator.pop(dialogContext!);
        }
      }
    });
  }
}

class _StateDialogWidget extends StatelessWidget {
  const _StateDialogWidget({
    required this.stateDialogContent,
    required this.onReceivedContext,
  });

  final Stream<StateDialogContent> stateDialogContent;
  final ValueChanged<BuildContext> onReceivedContext;

  @override
  Widget build(BuildContext context) {
    onReceivedContext(context);
    return StreamBuilder<StateDialogContent>(
      stream: stateDialogContent,
      builder: (context, snapshot) {
        final stateDialogContent = snapshot.data;
        if (stateDialogContent == null) return Container();
        return AnimatedSwitcher(
          duration: const Duration(milliseconds: 150),
          child: _PlatformAlertDialog(
            key: ValueKey(stateDialogContent),
            stateDialogContent: stateDialogContent,
          ),
        );
      },
    );
  }
}

class _PlatformAlertDialog extends StatelessWidget {
  const _PlatformAlertDialog({
    super.key,
    required this.stateDialogContent,
  });

  final StateDialogContent stateDialogContent;

  @override
  Widget build(BuildContext context) {
    if (ThemePlatform.isCupertino) {
      return CupertinoAlertDialog(
        title: Text(stateDialogContent.title),
        content: DialogWrapper(child: stateDialogContent.body),
        actions: <Widget>[
          for (final action in stateDialogContent.actions)
            ActionItemButton(item: action),
        ],
      );
    }
    return AlertDialog(
      title: Text(
        stateDialogContent.title,
        textAlign: TextAlign.center,
      ),
      content: DialogWrapper(child: stateDialogContent.body),
      actions: <Widget>[
        for (final action in stateDialogContent.actions)
          ActionItemButton(item: action),
      ],
    );
  }
}
