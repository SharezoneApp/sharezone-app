// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'flutter_platform_information_receiver.dart';
import 'platform_information_receiver.dart';

PlatformInformationReceiver getPlatformInformationReceiver() {
  return FlutterPlatformInformationReceiver();
}

Future<PlatformInformationReceiver>
    getPlatformInformationReceiverWithInit() async {
  final retriever = FlutterPlatformInformationReceiver();
  await retriever.init();
  return retriever;
}
