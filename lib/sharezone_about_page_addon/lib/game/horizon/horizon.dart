// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:flame/components.dart';

import '../game.dart';
import 'horizon_line.dart';

class Horizon extends PositionComponent with HasGameRef<TRexGame> {
  late final horizonLine = HorizonLine();

  @override
  Future<void> onLoad() async {
    addChild(horizonLine);
  }

  @override
  void update(double dt) {
    y = (gameRef.size.y / 2) + 21.0;
    super.update(dt);
  }

  void reset() {
    horizonLine.reset();
  }
}
