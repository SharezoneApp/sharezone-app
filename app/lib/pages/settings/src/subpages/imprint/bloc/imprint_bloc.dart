// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:bloc_base/bloc_base.dart';
import 'package:sharezone/pages/settings/src/subpages/imprint/gateway/imprint_gateway.dart';

class ImprintBloc extends BlocBase {
  final ImprintGateway _gateway;

  ImprintBloc(this._gateway);

  Stream<String> get markdownStream =>
      _gateway.imprintStream.map((imprint) => imprint.asMarkdown);

  @override
  void dispose() {}
}
