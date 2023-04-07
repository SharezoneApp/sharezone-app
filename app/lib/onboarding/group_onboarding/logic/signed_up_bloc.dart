// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:bloc_base/bloc_base.dart';
import 'package:rxdart/rxdart.dart';
import 'package:user/user.dart';

/// Der [SignUpBloc] enthält den Stream [signedUp]. Dieser Stream ist
/// über das Widget [AuthApp] und [SharezoneApp] gewrappt, wodurch die Information eines
/// Sign-Ups über die beiden Widgets hinweg übertragen werden kann. Erstellt der Nutzer nun in
/// [AuthApp] einen neunen Account ([signedUp] wird auf true gesetzt), wird wegen FirebaseAuth
/// sofort [SharezoneApp] angezeigt. In [SharezoneApp] hört ein Stream auf [signedUp]. Falls
/// der Wert von [signedUp] == true ist, startet das Gruppen-Onboarding.
class SignUpBloc extends BlocBase {
  final _signedUpSubject = BehaviorSubject.seeded(false);

  /// [typeOfUser] wird in dem [SignUpBloc] gespeichert, damit im GroupOnboarding
  /// dieser Wert synchron geladen werden kann. Ansonsten müsste dieser über den
  /// TypeOfUser-Stream aus dem User-Gateway asynchron geladen werden.
  TypeOfUser typeOfUser;

  SignUpBloc();

  Function(TypeOfUser) get setTypeOfUser => (tou) => typeOfUser = tou;
  Function(bool) get setSignedUp => _signedUpSubject.sink.add;

  Stream<bool> get signedUp => _signedUpSubject;

  @override
  void dispose() {
    _signedUpSubject.close();
  }
}
