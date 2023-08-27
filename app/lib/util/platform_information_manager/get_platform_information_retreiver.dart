// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

//@dart=2.12

import 'flutter_platform_information_retreiver.dart';
import 'platform_information_retreiver.dart';

PlatformInformationRetriever getPlatformInformationRetriever() {
  return FlutterPlatformInformationRetriever();
}

Future<PlatformInformationRetriever>
    getPlatformInformationRetrieverWithInit() async {
  final retriever = FlutterPlatformInformationRetriever();
  await retriever.init();
  return retriever;
}
