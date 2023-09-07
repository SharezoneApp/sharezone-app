// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:dynamic_links/dynamic_links.dart';
import 'package:dynamic_links/test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sharezone/dynamic_links/dynamic_link_bloc.dart';

void main() {
  group('DynamicLinkBloc', () {
    late DynamicLinkBloc bloc;
    late LocalDynamicLinks dynamicLinks;
    setUp(() {
      dynamicLinks = LocalDynamicLinks();
      bloc = DynamicLinkBloc(dynamicLinks);
    });

    // Ich weiß nicht wie ich dynamicLinks.onLink stubben kann, daher gehen wir einfach davon aus, dass bei beiden Methoden das selbe gemacht wird.
    test('gibt keinen EinkommendenLink aus, wenn initialLink null emittiert.',
        () async {
      dynamicLinks.getInitialDataReturn = null;
      expect(bloc.einkommendeLinks, neverEmits(anything));
      bloc.dispose();
    });

    test('gibt keinen EinkommendenLink aus, wenn onLink null emittiert.',
        () async {
      dynamicLinks.onLinkSuccessReturn = null;
      expect(bloc.einkommendeLinks, neverEmits(anything));
      bloc.dispose();
    });

    test(
        'gibt einen EinkommendenLink mit typ = "" und keinen Zusatzattributen aus, linkData.link null ist.',
        () async {
      final android = DynamicLinkDataAndroid(null, null);
      final ios = DynamicLinkDataIOS(null);
      dynamicLinks.getInitialDataReturn = DynamicLinkData(null, android, ios);

      await expectBlocEmitsEmptyLink(bloc);
    });
  });
}

Future expectBlocEmitsEmptyLink(DynamicLinkBloc bloc) async {
  await bloc.initialisere();
  final link = await bloc.einkommendeLinks.first;
  expect(link.typ, "");
  expect(link.zusatzinformationen, <String, String>{});
}
