// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'dart:async';
import 'package:bloc_base/bloc_base.dart';
import 'package:dynamic_links/dynamic_links.dart';
import 'package:rxdart/rxdart.dart';

import 'einkommender_link.dart';

class DynamicLinkBloc extends BlocBase {
  final DynamicLinks dynamicLinks;

  DynamicLinkBloc(this.dynamicLinks);

  final _einkommendeLinksSubject = BehaviorSubject<EinkommenderLink>();
  Stream<EinkommenderLink> get einkommendeLinks => _einkommendeLinksSubject;

  /// Dynamic Link will be catched by the dynamic links pluign. This method
  /// can't be called in the constructor, because otherwise the dynamic link
  /// wouldn't work on ios at a cold start of the app.
  Future<void> initialisere() async {
    final initData = await dynamicLinks.getInitialLink();
    _konvertiereZuEingehendemLink(initData, isInitialLink: true);
    dynamicLinks.onLink(
      onSuccess: (incommingLink) async =>
          _konvertiereZuEingehendemLink(incommingLink),
      onError: (e) async {
        print(
            "DynamicLink Error - Details: ${e.details}, Code: ${e.code}, Message: ${e.message}");
      },
    );
  }

  void _konvertiereZuEingehendemLink(DynamicLinkData einkommenderLink,
      {bool isInitialLink = false}) {
    if (einkommenderLink != null) {
      _einkommendeLinksSubject.add(EinkommenderLink.fromDynamicLink(
        einkommenderLink,
        isInitialLink
            ? EinkommensZeitpunkt.appstart
            : EinkommensZeitpunkt.laufzeit,
      ));
    }
  }

  @override
  void dispose() {
    _einkommendeLinksSubject.close();
  }
}
