// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'dart:async';
import 'dart:developer';

import 'package:app_links/app_links.dart';
import 'package:bloc_base/bloc_base.dart';

import 'package:rxdart/rxdart.dart';

import 'einkommender_link.dart';

class DynamicLinkBloc extends BlocBase {
  final AppLinks appLinks;
  DynamicLinkBloc(this.appLinks);

  final _einkommendeLinksSubject = BehaviorSubject<EinkommenderLink>();
  Stream<EinkommenderLink> get einkommendeLinks => _einkommendeLinksSubject;

  /// Dynamic Link will be catched by the dynamic links pluign. This method
  /// can't be called in the constructor, because otherwise the dynamic link
  /// wouldn't work on ios at a cold start of the app.
  Future<void> initialisere() async {
    appLinks.uriLinkStream.listen(
      (incommingLink) async => _konvertiereZuEingehendemLink(incommingLink),
      onError: (e) async {
        log(
          "DynamicLink Error - Details: ${e.details}, Code: ${e.code}, Message: ${e.message}",
          error: e,
        );
      },
    );
  }

  void _konvertiereZuEingehendemLink(
    Uri? einkommenderLink, {
    bool isInitialLink = false,
  }) {
    if (einkommenderLink != null) {
      _einkommendeLinksSubject.add(
        EinkommenderLink.fromUri(
          einkommenderLink,
          isInitialLink
              ? EinkommensZeitpunkt.appstart
              : EinkommensZeitpunkt.laufzeit,
        ),
      );
    }
  }

  @override
  void dispose() {
    _einkommendeLinksSubject.close();
  }
}
