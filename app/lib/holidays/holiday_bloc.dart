// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'dart:async';

import 'package:bloc_base/bloc_base.dart';
import 'package:clock/clock.dart';
import 'package:holidays/holidays.dart';
import 'package:rxdart/subjects.dart';
import 'package:sharezone/util/api/user_api.dart';
import 'package:user/user.dart';

class HolidayBloc extends BlocBase {
  // Siehe Kommentar dazu in dispose()
  // ignore: close_sinks
  final BehaviorSubject<List<Holiday?>> _holidays =
      BehaviorSubject<List<Holiday>>();
  final HolidayService holidayManager;
  DateTime Function()? getCurrentTime;
  Stream<List<Holiday?>> get holidays => _holidays;

  final HolidayStateGateway stateGateway;
  Stream<StateEnum?> get userState => stateGateway.userState;
  Stream<bool> get hasStateSelected =>
      userState.map((state) => state != null && state != StateEnum.notSelected);
  Future<void> Function(StateEnum? state) get changeState =>
      stateGateway.changeState;

  HolidayBloc({
    required this.holidayManager,
    required this.stateGateway,
    this.getCurrentTime,
  }) {
    getCurrentTime ??= () => clock.now();

    final holidaysStream = userState
        // StateEnum.notSelected would result into an UnsupportedStateException
        // while loading the holidays, which would lead to an error in the UI
        // (see https://github.com/SharezoneApp/sharezone-app/issues/566).
        .where((state) => state != StateEnum.notSelected)
        .asyncMap((stateEnum) async {
          final state = toStateOrThrow(stateEnum);
          return await holidayManager.load(state);
        });

    holidaysStream.listen(
      _holidays.add,
      onError: _holidays.addError,
      cancelOnError: false,
    );
  }

  @override
  void dispose() {
    // _subscription.cancel();
    // ⬆⬆⬆⬆⬆⬆⬆⬆⬆⬆⬆⬆⬆⬆⬆⬆⬆⬆⬆⬆⬆⬆⬆⬆⬆
    // Führt zu dem Fehler, dass nach dem Ändern von einem Bundesland sich die
    // Ferien nicht anpassen weil scheinbar (obwohl das ein Top-Level Bloc ist)
    // [dispose] aus irgendeinem Grund aufgerufen wird.

    // Vielleicht habe ich auch was mit dem BlocProvider falsch verstanden, der
    // ja dispose automatisch aufruft? Das sollte ja eigentlich nicht passieren,
    // weil der Bloc wie schon gesagt Top-Level ist. Naja keine Ahnung.

    // Speichertechnisch (wegen möglichen memory leak) sollte es eigentlich kein
    // Unterschied machen, weil der Bloc ja im Laufe der Applikation nie
    // wirklich disposed werden sollte, außer vielleicht beim Account-Ummelden
    // und der Fall passiert eh fast nie und es ist auch nur eine Subscription.
    // Deswegen sollte alles in Ordnung sein.
  }
}

// Abstrakte Klasse, damit einfacher eine Test-Implementation erstellt werden
// kann.
abstract class HolidayStateGateway {
  Stream<StateEnum?> get userState;
  Future<void> changeState(StateEnum? state);

  const HolidayStateGateway();

  factory HolidayStateGateway.fromUserGateway(UserGateway userGateway) =
      _HolidayStateGatewayUserGatewayAdapter;
}

class _HolidayStateGatewayUserGatewayAdapter extends HolidayStateGateway {
  final UserGateway userGateway;

  _HolidayStateGatewayUserGatewayAdapter(this.userGateway);

  @override
  Future<void> changeState(StateEnum? state) => userGateway.changeState(state!);

  @override
  Stream<StateEnum> get userState =>
      userGateway.userStream.map((user) => user!.state);
}

class UnsupportedStateException implements Exception {
  final String? message;
  final StateEnum? state;

  UnsupportedStateException([this.message, this.state]);

  @override
  String toString() {
    String report = "UnsupportedStateException";
    if (state != null) report += " for StateEnum $state";
    if (message != null && message != "") {
      report += ": $message.";
    } else {
      report += ".";
    }
    return report;
  }
}

State toStateOrThrow(StateEnum? stateEnum) {
  switch (stateEnum) {
    case StateEnum.badenWuerttemberg:
      return const BadenWuerttemberg();
    case StateEnum.bayern:
      return const Bayern();
    case StateEnum.berlin:
      return const Berlin();
    case StateEnum.brandenburg:
      return const Brandenburg();
    case StateEnum.bremen:
      return const Bremen();
    case StateEnum.hamburg:
      return const Hamburg();
    case StateEnum.hessen:
      return const Hessen();
    case StateEnum.mecklenburgVorpommern:
      return const MecklenburgVorpommern();
    case StateEnum.niedersachsen:
      return const Niedersachsen();
    case StateEnum.nordrheinWestfalen:
      return const NordrheinWestfalen();
    case StateEnum.rheinlandPfalz:
      return const RheinlandPfalz();
    case StateEnum.saarland:
      return const Saarland();
    case StateEnum.sachsen:
      return const Sachsen();
    case StateEnum.sachsenAnhalt:
      return const SachsenAnhalt();
    case StateEnum.schleswigHolstein:
      return const SchleswigHolstein();
    case StateEnum.thueringen:
      return const Thueringen();
    case StateEnum.notFromGermany:
      throw UnsupportedStateException(
        "Holidays are not available for selected State",
        stateEnum,
      );
    case StateEnum.anonymous:
      throw UnsupportedStateException(
        "Can't load Holidays for anonymous user.",
        stateEnum,
      );
    default:
      throw UnsupportedStateException("Unknown State Value.", stateEnum);
  }
}
