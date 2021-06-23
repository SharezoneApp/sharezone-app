import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sharezone_widgets/common_widgets.dart';
import 'package:sharezone_widgets/src/state_sheet/state_dialog_content.dart';
import 'package:sharezone_widgets/theme.dart';

import '../dialog_wrapper.dart';

class StateDialog {
  final Stream<StateDialogContent> stateSheetContent;

  const StateDialog(this.stateSheetContent);

  Future<void> show(BuildContext context) async {
    await showDialog(
      context: context,
      builder: (context) =>
          _StateDialogWidget(stateDialogContent: stateSheetContent),
    );
  }

  Future<void> showDialogAutoPop(
    BuildContext context, {
    @required Future<bool> future,
    Duration delay = const Duration(milliseconds: 250),
  }) async {
    final dialogPop = show(context);
    bool hasDialogPopped = false;
    dialogPop.then((_) => hasDialogPopped = true);
    future.then((result) async {
      if (result == true) {
        await Future.delayed(delay);
        if (!hasDialogPopped) {
          Navigator.pop(context);
        }
      }
    });
  }
}

class _StateDialogWidget extends StatelessWidget {
  final Stream<StateDialogContent> stateDialogContent;

  const _StateDialogWidget({Key key, this.stateDialogContent})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<StateDialogContent>(
      stream: stateDialogContent,
      builder: (context, snapshot) {
        if (!snapshot.hasData) return Container();
        final stateDialogContent = snapshot.data;
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
  final StateDialogContent stateDialogContent;

  const _PlatformAlertDialog({Key key, this.stateDialogContent})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    if (ThemePlatform.isCupertino)
      return CupertinoAlertDialog(
        title: stateDialogContent.title != null
            ? Text(stateDialogContent.title)
            : null,
        content: DialogWrapper(child: stateDialogContent.body),
        actions: <Widget>[
          for (final action in stateDialogContent.actions)
            ActionItemButton(item: action),
        ],
      );
    return AlertDialog(
      title: stateDialogContent.title != null
          ? Text(
              stateDialogContent.title,
              textAlign: TextAlign.center,
            )
          : null,
      content: DialogWrapper(child: stateDialogContent.body),
      actions: <Widget>[
        for (final action in stateDialogContent.actions)
          ActionItemButton(item: action),
      ],
    );
  }
}
