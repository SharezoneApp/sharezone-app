// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

class HorizonConfig {
  late final double cloudFrequency = 0.5;
  late final int maxClouds = 20;
  late final double bgCloudSpeed = 0.2;
}

class HorizonDimensions {
  late final double width = 1200.0;
  late final double height = 24.0;
  late final double yPos = 127.0;
}

class CloudConfig {
  late final double height = 28.0;

  late final double maxCloudGap = 400.0;
  late final double minCloudGap = 100.0;

  late final double maxSkyLevel = 71.0;
  late final double minSkyLevel = 30.0;

  late final double width = 92.0;
}
