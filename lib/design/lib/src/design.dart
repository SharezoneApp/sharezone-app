// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'dart:math';

import 'package:flutter/material.dart';

import 'color_parser.dart';

enum DesignType {
  color,
}

class Design {
  final String hex;
  final DesignType type;

  const Design._({
    required this.hex,
    required this.type,
  });

  factory Design.standard() => Design.fromColor(Colors.lightBlue);

  factory Design.random() {
    final value = Random().nextInt(freeDesigns.length);
    return freeDesigns[value];
  }

  factory Design.fromColor(Color color) {
    return Design._(hex: ColorParser.toHex(color), type: DesignType.color);
  }

  factory Design.fromData(dynamic data) {
    try {
      if (data == null) return Design.standard();
      if (data is String) {
        return Design._(hex: data, type: DesignType.color);
      }
      final type = DesignType.values.byName(data['type']);
      if (type == DesignType.color) {
        return Design._(hex: data['color'], type: type);
      }
      return Design.standard();
    } catch (_) {
      return Design.standard();
    }
  }

  Color get color => ColorParser.fromHex(hex);

  dynamic toJson() {
    return {
      'color': hex,
      'type': type.name,
    };
  }

  @override
  bool operator ==(other) {
    return other is Design && hex == other.hex;
  }

  @override
  int get hashCode => Object.hash(hex, type);

  /// A list of designs that are available for free and don't require a
  /// Sharezone Plus subscription.
  static List<Design> freeDesigns = [
    Colors.pinkAccent,
    Colors.grey[700],
    Colors.green,
    Colors.deepOrangeAccent,
    Colors.orangeAccent,
    Colors.purpleAccent,
    Colors.lightBlue,
    Colors.amberAccent,
    Colors.yellow,
    Colors.redAccent,
    Colors.deepPurpleAccent,
    Colors.lightGreen,
    Colors.green[800],
    Colors.blueAccent,
    Colors.blue[800],
    Colors.indigo,
    Colors.grey,
    Colors.brown,
    Colors.black87,
  ].map((color) => Design.fromColor(color!)).toList();
}
