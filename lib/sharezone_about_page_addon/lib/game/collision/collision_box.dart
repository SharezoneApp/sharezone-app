// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:flame/extensions.dart';
import 'package:flutter/foundation.dart';

@immutable
class CollisionBox {
  const CollisionBox({
    required this.position,
    required this.size,
  });

  factory CollisionBox.from(CollisionBox otherCollisionBox) {
    return CollisionBox(
      position: otherCollisionBox.position,
      size: otherCollisionBox.size,
    );
  }

  final Vector2 position;
  final Vector2 size;

  Rect toRect() {
    return Rect.fromLTWH(position.x, position.y, size.x, size.y);
  }

  @override
  String toString() {
    return 'position: $position; size: $size';
  }
}
