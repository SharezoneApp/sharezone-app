// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:flutter/material.dart';
import 'package:group_domain_models/group_domain_models.dart';
import 'package:sharezone_common/helper_functions.dart';
import 'package:sharezone_widgets/sharezone_widgets.dart';

import 'course_settings.dart';

class WritePermissions extends StatelessWidget {
  const WritePermissions({
    Key? key,
    required this.initialWritePermission,
    required this.writePermissionStream,
    required this.onChange,
    this.annotation,
  }) : super(key: key);

  final WritePermission initialWritePermission;
  final Stream<WritePermission> writePermissionStream;
  final FutureBoolValueChanged<WritePermission> onChange;
  final String? annotation;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: const Text("Schreibrechte"),
      subtitle: Text(writePermissionAsUiString(initialWritePermission)),
      onTap: () => showWritePermissionOptionsSheet(
        context: context,
        currentPermission: initialWritePermission,
        permissionsStream: writePermissionStream,
        onChange: onChange,
        annotation: annotation,
      ),
      leading: const Icon(Icons.create),
      onLongPress: () => showExplanation(context,
          "Mit dieser Einstellung kann reguliert werden, welche Nutzergruppen Schreibrechte erhalten."),
    );
  }
}

void showWritePermissionOptionsSheet({
  required BuildContext context,
  required WritePermission currentPermission,
  required Stream<WritePermission> permissionsStream,
  required FutureBoolValueChanged<WritePermission> onChange,
  String? annotation,
}) {
  showModalBottomSheet(
    context: context,
    builder: (context) => _WritePermissionSheet(
      initialData: currentPermission,
      permissionsStream: permissionsStream,
      onChange: onChange,
      annotation: annotation,
    ),
  );
}

class _WritePermissionSheet extends StatelessWidget {
  const _WritePermissionSheet({
    Key? key,
    required this.initialData,
    required this.permissionsStream,
    required this.onChange,
    this.annotation,
  }) : super(key: key);

  final WritePermission initialData;
  final Stream<WritePermission> permissionsStream;
  final FutureBoolValueChanged<WritePermission> onChange;
  final String? annotation;

  @override
  Widget build(BuildContext context) {
    const textStyle = TextStyle(color: Colors.grey, fontSize: 11);
    return StreamBuilder<WritePermission>(
      initialData: initialData,
      stream: permissionsStream,
      builder: (context, snapshot) {
        final currentPermission = snapshot.data!;
        return SingleChildScrollView(
          child: SafeArea(
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32)
                      .add(const EdgeInsets.only(top: 16)),
                  child: Column(
                    children: <Widget>[
                      Text(
                        "Wer ist dazu berechtigt, neue Einträge, neue Hausaufgaben, neue Dateien, etc. zu erstellen, bzw. hochzuladen?",
                        style: textStyle,
                        textAlign: TextAlign.center,
                      ),
                      if (isNotEmptyOrNull(annotation))
                        Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Text(
                            annotation!,
                            textAlign: TextAlign.center,
                            style: textStyle,
                          ),
                        ),
                    ],
                  ),
                ),
                _WritePermissionTile(
                  writePermission: WritePermission.everyone,
                  currentPermission: currentPermission,
                  title: "Alle",
                  subtitle:
                      'Jeder erhält die Rolle ”aktives Mitglied (Lese- und Schreibrechte)"',
                  onChange: onChange,
                ),
                _WritePermissionTile(
                  writePermission: WritePermission.onlyAdmins,
                  currentPermission: currentPermission,
                  title: "Nur Admins",
                  subtitle:
                      'Alle, außer die Admins, erhalten die Rolle "passives Mitglied (Nur Leserechte)"',
                  onChange: onChange,
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _WritePermissionTile extends StatelessWidget {
  const _WritePermissionTile({
    Key? key,
    required this.writePermission,
    required this.currentPermission,
    required this.title,
    this.subtitle,
    required this.onChange,
  }) : super(key: key);

  final String title;
  final String? subtitle;
  final WritePermission currentPermission, writePermission;
  final FutureBoolValueChanged<WritePermission> onChange;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: RadioListTile<WritePermission>(
        title: Text(title),
        subtitle: !isEmptyOrNull(subtitle) ? Text(subtitle!) : null,
        groupValue: currentPermission,
        value: writePermission,
        onChanged: (newPermission) {
          Future<bool> kickUser = onChange(writePermission);
          showSimpleStateDialog(context, kickUser);
        },
      ),
    );
  }
}
