import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sharezone/settings/src/subpages/my_profile/change_type_of_user/change_type_of_user_controller.dart';
import 'package:sharezone_widgets/sharezone_widgets.dart';
import 'package:user/user.dart';

class ChangeTypeOfUserPage extends StatelessWidget {
  const ChangeTypeOfUserPage({super.key});

  static const tag = "change-type-of-user-page";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Account-Typ ändern"),
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

  Future<void> _showErrorSnackBar({
    required BuildContext context,
    required ChangeTypeOfUserFailed e,
  }) async {
    showSnackSec(
      text: switch (e) {
        ChangeTypeOfUserUnknownException(error: final error) =>
          'Fehler: $error. Bitte kontaktiere den Support.',
        NoTypeOfUserSelectedException() =>
          'Es wurde kein Account-Typ ausgewählt.',
        TypeUserOfUserHasNotChangedException() =>
          'Der Account-Typ hat sich nicht geändert.',
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.extended(
      label: const Text("Speichern"),
      onPressed: () async {
        sendDataToFrankfurtSnackBar(context);

        final controller = context.read<ChangeTypeOfUserController>();
        try {
          await controller.changeTypeOfUser();

          if (context.mounted) {
            _showRestartDialog(context);
          }
        } on ChangeTypeOfUserFailed catch (e) {
          if (context.mounted) {
            _showErrorSnackBar(context: context, e: e);
          }
        }
      },
      icon: const Icon(Icons.check),
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
    return const Text(
      'Hinweis: Durch das Ändern der Nutzer erhältst du keine weiteren Berechtigungen in den Gruppen. Ausschlaggebend sind die Gruppenberechtigungen ("Administrator", "Aktives Mitglied", "Passives Mitglied").',
      style: TextStyle(color: Colors.grey),
    );
  }
}

class _ChangeTypeOfUser extends StatelessWidget {
  const _ChangeTypeOfUser();

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<ChangeTypeOfUserController>();
    final selectedTypeOfUser = controller.selectedTypeOfUser;
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
        title: const Text('Neustart erforderlich'),
        content: const Text(
            'Die Änderung deines Account-Typs war erfolgreich. Jedoch muss die App muss neu gestartet werden, damit die Änderung wirksam wird.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}
