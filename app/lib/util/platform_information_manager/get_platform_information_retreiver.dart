// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'flutter_platform_information_retreiver.dart';
import 'platform_information_retreiver.dart';

PlatformInformationRetreiver getPlatformInformationRetreiver() {
  return FlutterPlatformInformationRetreiver();
}

Future<PlatformInformationRetreiver>
    getPlatformInformationRetreiverWithInit() async {
  final retriever = FlutterPlatformInformationRetreiver();
  await retriever.init();
  return retriever;
}
