// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:common_domain_models/common_domain_models.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rxdart/subjects.dart';
import 'package:sharezone/dynamic_links/beitrittsversuch.dart';
import 'package:sharezone/dynamic_links/einkommender_link.dart';
import 'package:sharezone/dynamic_links/gruppen_beitritts_transformer.dart';

void main() {
  group('GruppenBeitrittsTransformer', () {
    const gruppenId = "gruppenId";
    BehaviorSubject<EinkommenderLink> einkommendeLinks;

    setUp(() {
      einkommendeLinks = BehaviorSubject<EinkommenderLink>();
    });

    tearDown(() {
      einkommendeLinks.close();
    });

    GruppenBeitrittsversuchFilterBloc transformerWithHasJoinedGroupAlways(
            bool hasJoinedGroup) =>
        GruppenBeitrittsversuchFilterBloc(
          einkommendeLinks: einkommendeLinks,
          istGruppeBereitsBeigetreten: (_) => Future.value(hasJoinedGroup),
        );

    EinkommenderLink erstelleValidenEinkommendenLink(
        [EinkommensZeitpunkt einkommensZeitpunkt =
            EinkommensZeitpunkt.appstart]) {
      final einkommenderLink = EinkommenderLink(
          typ: GruppenBeitrittsversuchFilterBloc.matchingLinkType,
          einkommensZeitpunkt: einkommensZeitpunkt,
          zusatzinformationen: {
            GruppenBeitrittsversuchFilterBloc.sharecodeKey: gruppenId
          });
      return einkommenderLink;
    }

    test(
        'emittiert KEINE KursBereitsBeigetretenException, falls der Gruppe schon beigetreten wurde, aber der Link zur Laufzeit angekommen ist',
        () async {
      EinkommenderLink einkommenderLink =
          erstelleValidenEinkommendenLink(EinkommensZeitpunkt.laufzeit);

      var transformer = transformerWithHasJoinedGroupAlways(true);
      final beitrittsVersuche = transformer.gefilterteBeitrittsversuche;

      einkommendeLinks.add(einkommenderLink);

      beitrittsVersuche.listen((d) {}, onError: (e) {
        throw Error();
      });
      transformer.dispose();
      await beitrittsVersuche.drain();
    });
    test(
        'emittiert eine KursBereitsBeigetretenException, falls der Gruppe schon beigetreten wurde und der EinkommensZeitpunkt zum Appstart ist',
        () {
      EinkommenderLink einkommenderLink =
          erstelleValidenEinkommendenLink(EinkommensZeitpunkt.appstart);
      final beitrittsVersuche =
          transformerWithHasJoinedGroupAlways(true).gefilterteBeitrittsversuche;

      einkommendeLinks.add(einkommenderLink);

      expect(beitrittsVersuche,
          emitsError(TypeMatcher<KursBereitsBeigetretenException>()));
    });
    test(
        'emittiert keinen Beitrittsversuch, falls der Gruppe schon beigetreten wurde',
        () {
      EinkommenderLink einkommenderLink = erstelleValidenEinkommendenLink();
      var transformer = transformerWithHasJoinedGroupAlways(true);
      final beitrittsVersuche = transformer.gefilterteBeitrittsversuche;

      einkommendeLinks.add(einkommenderLink);

      expect(beitrittsVersuche, neverEmits(anything));
      transformer.dispose();
    });
    test(
        'emittiert einen Beitrittsversuch, falls der Gruppe noch nicht beigetreten wurde ',
        () {
      EinkommenderLink einkommenderLink = erstelleValidenEinkommendenLink();
      final beitrittsVersuche = transformerWithHasJoinedGroupAlways(false)
          .gefilterteBeitrittsversuche;

      einkommendeLinks.add(einkommenderLink);

      expect(beitrittsVersuche,
          emits(Beitrittsversuch(sharecode: Sharecode(gruppenId))));
    });

    test('transformiert keinen unpassenden einkommenden Link ', () {
      final einkommenderLink = EinkommenderLink(
          typ: "some_wrong_type", zusatzinformationen: {"foo": "bar"});
      var transformer = transformerWithHasJoinedGroupAlways(true);
      final beitrittsVersuche = transformer.gefilterteBeitrittsversuche;

      einkommendeLinks.add(einkommenderLink);

      expect(beitrittsVersuche, neverEmits(anything));
      transformer.dispose();
    });
  });
}
