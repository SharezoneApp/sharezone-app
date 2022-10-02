// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:authentification_base/authentification.dart';
import 'package:bloc_provider/bloc_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sharezone/blocs/application_bloc.dart';
import 'package:sharezone/main/missing_account_information_guard/missing_account_information_guard_bloc.dart';
import 'package:sharezone/onboarding/sign_up/sign_up_page.dart';

/// Manchmal passiert es, dass ein Nutzer, der noch kein Sharezone Konto hat,
/// sich über Google Sign bei der Login-Page anmeldet. Passiert das, wird der
/// Nutzer über Firebase Auth als normaler Nutzer trotzdem angemeldet. Das
/// Problem: Der Nutzer hat keinen Sharezone Account in Firestore, ist aber
/// trotzdem authentifziert, weswegen er in die App zugelassen wird (durch
/// den Firebase Auth Stream).
///
/// Früher war der Schutz dafür, dass direkt nach dem Google Sign In Anmeldung
/// geschaut wurde, ob es unter der UID ein Firestore-Dokument gibt. Falls nein,
/// wird der Account direkt gelöscht. Leider ist es häufiger dadurch passiert, dass
/// ein Account gelöscht wurde, den eigentlich gab. Deswegen gibt es jetzt einen
/// neuen Schutz.
///
/// Tritt dieser Fall ein, dass ein Nutzer mit Firebase Auth authentifiziert ist,
/// aber kein Firestore-Dokument hat, fällt dies direkt der [MissingAccountTypeGuard]
/// auf. Die [MissingAccountTypeGuard] zeigt dem Nutzer dann eine Page, wo
/// dieser seinen Account-Typ festlegen kann und ein neuen Nutzer in Firestore
/// erstellen kann.
class MissingAccountInformationGuard extends StatelessWidget {
  const MissingAccountInformationGuard({
    Key key,
    @required this.child,
    @required this.userCollection,
    this.gateway,
  }) : super(key: key);

  final CollectionReference userCollection;

  final RegistrationGateway gateway;

  /// Dieses Widget wird angezeigt, wenn der Nutzer einen Sharezone Account
  /// hat (normaler Fall).
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final userGateway = BlocProvider.of<SharezoneContext>(context).api.user;
    final bloc = MissingAccountInformationGuardBloc(userGateway);
    return BlocProvider(
      bloc: bloc,
      child: StreamBuilder<bool>(
        initialData: true,
        stream: bloc.hasUserSharezoneAccount,
        builder: (context, snapshot) {
          final hasUserSharezoneAccount = snapshot.data ?? true;
          if (hasUserSharezoneAccount) return child;

          return Scaffold(
            body: SignUpPage(withLogin: false),
            bottomNavigationBar: SafeArea(child: const _SignOutButton()),
          );
        },
      ),
    );
  }
}

class _SignOutButton extends StatelessWidget {
  const _SignOutButton({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<MissingAccountInformationGuardBloc>(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 0, 12, 8),
      child: TextButton(
        style: TextButton.styleFrom(
          foregroundColor: Theme.of(context).errorColor,
        ),
        onPressed: bloc.logOut,
        child: const Text("ABMELDEN"),
      ),
    );
  }
}
