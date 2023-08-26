// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'android_information.dart';
import 'ios_information.dart';

abstract class DeviceInformationRetriever {
  Future<AndroidDeviceInformation> get androidInfo;
  Future<IosDeviceInformation> get iosInfo;
}
