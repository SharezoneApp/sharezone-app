// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'dart:async';
import 'dart:developer';
import 'package:bloc_base/bloc_base.dart';
import 'package:common_domain_models/common_domain_models.dart';
import 'package:rxdart/subjects.dart';
import 'package:sharezone/dynamic_links/einkommender_link.dart';

import 'beitrittsversuch.dart';

class GruppenBeitrittsversuchFilterBloc implements BlocBase {
  static const matchingLinkType = 'joinbykey';
  static const sharecodeKey = "data";

  final Stream<EinkommenderLink> einkommendeLinks;
  final Future<bool> Function(Sharecode groupId) istGruppeBereitsBeigetreten;

  final _gefilterteBeitrittsversucheSubject =
      BehaviorSubject<Beitrittsversuch?>();
  Stream<Beitrittsversuch?> get gefilterteBeitrittsversuche =>
      _gefilterteBeitrittsversucheSubject;

  late StreamSubscription _subscription;
  GruppenBeitrittsversuchFilterBloc({
    required this.einkommendeLinks,
    required this.istGruppeBereitsBeigetreten,
  }) {
    _subscription = einkommendeLinks
        .asyncMap(_toBeitrittsversuchIfValid)
        .listen(
          _gefilterteBeitrittsversucheSubject.add,
          onError: _gefilterteBeitrittsversucheSubject.addError,
          cancelOnError: false,
        );
  }

  Future<Beitrittsversuch?> _toBeitrittsversuchIfValid(
    EinkommenderLink link,
  ) async {
    {
      if (link.typ == matchingLinkType) {
        final codeString = link.zusatzinformationen[sharecodeKey];
        if (codeString == null || codeString.isEmpty) {
          log("Kein Sharecode im Link vorhanden: $link");
          return null;
        }
        final sharecode = Sharecode(link.zusatzinformationen[sharecodeKey]!);
        final schonBeigetreten = await istGruppeBereitsBeigetreten(sharecode);
        if (!schonBeigetreten) {
          return Beitrittsversuch(sharecode: sharecode);
        } else {
          log("Gruppe wurde schon beigetreten");
          // Das dynamic-link Plugin gibt den Link beim Rückwechsel in die App nochmals als neues Event an,
          // weswegen dann der Beitrittsversuch einfach komplett ignoriert werden soll.
          // Falls allerdings beim App-Start dem Kurs bereits beigetreten worden ist,
          // kann davon ausgegangen werden, dass der Nutzer diese Aktion gestartet hat.
          // Daraufhin soll und kann eine Reaktion von der App kommen, z.B. ein Hinweis-Dialog ö.ä.
          if (link.einkommensZeitpunkt == EinkommensZeitpunkt.appstart) {
            throw KursBereitsBeigetretenException();
          }
        }
      }
    }
    return null;
  }

  @override
  void dispose() {
    _subscription.cancel();
    _gefilterteBeitrittsversucheSubject.close();
  }
}

class KursBereitsBeigetretenException implements Exception {}
