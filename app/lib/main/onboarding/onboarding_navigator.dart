// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:bloc_base/bloc_base.dart';
import 'package:rxdart/rxdart.dart';
import 'package:sharezone/dynamic_links/beitrittsversuch.dart';
import 'package:sharezone/onboarding/group_onboarding/logic/signed_up_bloc.dart';
import 'package:platform_check/platform_check.dart';

class OnboardingNavigator extends BlocBase {
  final SignUpBloc _signedUpBloc;
  final Stream<Beitrittsversuch?> _beitrittsversucheStream;

  OnboardingNavigator(this._signedUpBloc, this._beitrittsversucheStream);

  /// Dieser Stream gibt den Status über das Anzeigen des GroupOnboardings an.
  ///
  /// Falls der Nutzer einen JoinLink (Beitrittsversuch) verwendet, soll nur die
  /// Seite [ChangeName] angezeigt werden, weil der Nutzer nicht mehr durch das
  /// [GroupOnboarding] geleitet werden muss (Nutzer ist ja schon den Gruppen
  /// beigetreten)
  /// Verwendet der Nutzer jedoch ein iOS-Gerät, sollte zusätzlich noch die Seite
  /// [TurnOnNotifcations] angezeigt werden, damit der Nutzer aufgefordert wird,
  /// die Push-Nachrichten zu aktivieren.
  ///
  /// Verwendet der Nutzer keine JoinLinks und hat sich gerade registriert
  /// ([signedUp] == true), so soll das gesamte Onboarding angezeigt werden.
  ///
  /// Hat der Nutzer sich gerade nicht registriert ([signedUp == false]), so soll kein
  /// GroupOnboarding angezeigt werden.
  Stream<OnboardingStatus> get status =>
      CombineLatestStream.combine2<bool, Beitrittsversuch?, OnboardingStatus>(
        _signedUpBloc.signedUp,
        _beitrittsversucheStream,
        (hasSignedUp, beitrittsversuche) {
          final usedJoinLink = beitrittsversuche?.sharecode != null;

          if (usedJoinLink && hasSignedUp) {
            if (PlatformCheck.isIOS) {
              return OnboardingStatus.onlyNameAndTurnOfNotifactions;
            } else {
              return OnboardingStatus.onlyName;
            }
          }

          if (!usedJoinLink && hasSignedUp) return OnboardingStatus.full;

          return OnboardingStatus.none;
        },
      );

  /// Dieser Stream ist eine Vereinfachung von [status], wodurch in der UI beim
  /// [GroupOnboardingListener] einfach gehört werden kann, ob ein GroupOnboarding
  Stream<bool> get showOnboarding => _signedUpBloc.signedUp;

  @override
  void dispose() {}
}

enum OnboardingStatus {
  /// Kein Group-Onboarding anzeigen
  none,

  /// Nur die Seite anzeigen, wo der Nutzer gefragt wird,
  /// welchen Namen er wählen möchten.
  onlyName,

  /// Nur die Seiten anzeigen, wo der Nutzer gefragt wird,
  /// welchen Namen er wählen möchte und wo er nach der
  /// Aktivieriung der Push-Nachrichten gefragt wird.
  onlyNameAndTurnOfNotifactions,

  /// Gesamte Onboarding anzeigen
  full,
}
