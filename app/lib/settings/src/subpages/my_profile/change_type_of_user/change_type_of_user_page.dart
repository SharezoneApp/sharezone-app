// Copyright (c) 2024 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:provider/provider.dart';
import 'package:sharezone/settings/src/subpages/my_profile/change_type_of_user/change_type_of_user_controller.dart';
import 'package:sharezone/support/support_page.dart';
import 'package:sharezone_localizations/sharezone_localizations.dart';
import 'package:sharezone_widgets/sharezone_widgets.dart';
import 'package:user/user.dart';

class ChangeTypeOfUserPage extends StatelessWidget {
  const ChangeTypeOfUserPage({super.key});

  static const tag = "change-type-of-user-page";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.changeTypeOfUserPageTitle),
        centerTitle: true,
      ),
      body: _Body(),
      floatingActionButton: const _SaveFab(),
    );
  }
}

class _SaveFab extends StatelessWidget {
  const _SaveFab();

  Future<void> _showRestartDialog(BuildContext context) async {
    await showDialog(
      context: context,
      builder: (context) => const _RestartAppDialog(),
    );
  }

  Future<void> _showErrorDialog({
    required BuildContext context,
    required ChangeTypeOfUserFailed e,
  }) async {
    showDialog(
      context: context,
      builder: (context) => _ErrorDialog(failure: e),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = context.select<ChangeTypeOfUserController, bool>(
        (controller) => controller.state is ChangeTypeOfUserLoading);
    return FloatingActionButton.extended(
      label:
          isLoading ? const _Loading() : Text(context.l10n.commonActionsSave),
      mouseCursor:
          isLoading ? SystemMouseCursors.basic : SystemMouseCursors.click,
      onPressed: !isLoading
          ? () async {
              final controller = context.read<ChangeTypeOfUserController>();
              try {
                await controller.changeTypeOfUser();

                if (context.mounted) {
                  _showRestartDialog(context);
                }
              } on ChangeTypeOfUserFailed catch (e) {
                if (context.mounted) {
                  _showErrorDialog(context: context, e: e);
                }
              }
            }
          : null,
      icon: isLoading ? null : const Icon(Icons.check),
    );
  }
}

class _ErrorDialog extends StatelessWidget {
  const _ErrorDialog({
    required this.failure,
  });

  final ChangeTypeOfUserFailed failure;

  @override
  Widget build(BuildContext context) {
    return MaxWidthConstraintBox(
      maxWidth: 500,
      child: AlertDialog(
        title: Text(context.l10n.changeTypeOfUserPageErrorDialogTitle),
        content: Text(
          switch (failure) {
            ChangeTypeOfUserUnknownException(error: final error) =>
              context.l10n.changeTypeOfUserPageErrorDialogContentUnknown(error),
            NoTypeOfUserSelectedException() => context.l10n
                .changeTypeOfUserPageErrorDialogContentNoTypeOfUserSelected,
            TypeUserOfUserHasNotChangedException() => context.l10n
                .changeTypeOfUserPageErrorDialogContentTypeOfUserHasNotChanged,
            ChangedTypeOfUserTooOftenException(
              blockedUntil: final blockedUntil
            ) =>
              context.l10n
                  .changeTypeOfUserPageErrorDialogContentChangedTypeOfUserTooOften(
                      blockedUntil),
          },
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(context.l10n.commonActionsClose.toUpperCase()),
          ),
          if (failure is ChangeTypeOfUserUnknownException)
            TextButton(
              onPressed: () =>
                  Navigator.of(context).pushReplacementNamed(SupportPage.tag),
              child:
                  Text(context.l10n.commonActionsContactSupport.toUpperCase()),
            ),
        ],
      ),
    );
  }
}

class _Loading extends StatelessWidget {
  const _Loading();

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      height: 25,
      width: 25,
      child: CircularProgressIndicator(
        color: Colors.white,
      ),
    );
  }
}

class _Body extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const SingleChildScrollView(
      padding: EdgeInsets.all(12),
      child: MaxWidthConstraintBox(
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              _ChangeTypeOfUser(),
              SizedBox(height: 16),
              _PermissionNote(),
            ],
          ),
        ),
      ),
    );
  }
}

class _PermissionNote extends StatelessWidget {
  const _PermissionNote();

  @override
  Widget build(BuildContext context) {
    const textStyle = TextStyle(color: Colors.grey);
    return MarkdownBody(
      data: context.l10n.changeTypeOfUserPagePermissionNote,
      styleSheet: MarkdownStyleSheet(
        p: textStyle,
        listBullet: textStyle,
      ),
    );
  }
}

class _ChangeTypeOfUser extends StatelessWidget {
  const _ChangeTypeOfUser();

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<ChangeTypeOfUserController>();
    final selectedTypeOfUser =
        controller.selectedTypeOfUser ?? controller.initialTypeOfUser;
    return Column(
      children: [
        for (final typeOfUser in [
          TypeOfUser.student,
          TypeOfUser.teacher,
          TypeOfUser.parent
        ])
          RadioListTile<TypeOfUser>(
            value: typeOfUser,
            groupValue: selectedTypeOfUser,
            title: Text(typeOfUser.toReadableString()),
            onChanged: (value) {
              controller.setSelectedTypeOfUser(typeOfUser);
            },
          )
      ],
    );
  }
}

class _RestartAppDialog extends StatelessWidget {
  const _RestartAppDialog();

  @override
  Widget build(BuildContext context) {
    return MaxWidthConstraintBox(
      maxWidth: 400,
      child: AlertDialog(
        title: Text(context.l10n.changeTypeOfUserPageRestartAppDialogTitle),
        content: Text(context.l10n.changeTypeOfUserPageRestartAppDialogContent),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(context.l10n.commonActionsOk.toUpperCase()),
          ),
        ],
      ),
    );
  }
}
