// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:helper_functions/helper_functions.dart';

enum EinkommensZeitpunkt { appstart, laufzeit, unbekannt }

class EinkommenderLink {
  final String typ;
  final Map<String, String> zusatzinformationen;
  final EinkommensZeitpunkt einkommensZeitpunkt;
  bool get empty => isEmptyOrNull(typ) && zusatzinformationen.isEmpty;

  EinkommenderLink({
    this.typ = "",
    this.zusatzinformationen = const {},
    this.einkommensZeitpunkt = EinkommensZeitpunkt.unbekannt,
  });

  factory EinkommenderLink.fromUri(
    Uri? pendingDynamicLinkData,
    EinkommensZeitpunkt einkommensZeitpunkt,
  ) {
    if (pendingDynamicLinkData == null) {
      return EinkommenderLink();
    }

    final copiedQueryParameters = Map<String, String>.from(
      pendingDynamicLinkData.queryParameters,
    );
    final type = copiedQueryParameters.remove("type") ?? "";

    return EinkommenderLink(
      typ: type,
      zusatzinformationen: copiedQueryParameters,
      einkommensZeitpunkt: einkommensZeitpunkt,
    );
  }

  @override
  String toString() {
    return "EinkommenderLink(typ: $typ, zusatzinformationen: $zusatzinformationen, einkommensZeitpunkt: $einkommensZeitpunkt, empty: $empty)";
  }
}
