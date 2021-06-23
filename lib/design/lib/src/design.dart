import 'dart:math';
import 'package:flutter/material.dart';

import 'color_parser.dart';
import 'package:quiver/core.dart';
import 'package:sharezone_common/helper_functions.dart';

enum DesignType {
  color,
}

DesignType designTypeFromJson(dynamic data) =>
    enumFromString<DesignType>(DesignType.values, data,
        orElse: DesignType.color);

String designTypeToJson(DesignType designType) => enumToString(designType);

class Design {
  final String hex;
  final DesignType type;

  const Design._({this.hex, this.type});

  factory Design.standard() => Design.fromColor(Colors.lightBlue);

  factory Design.random() {
    final value = Random().nextInt(designList.length);
    return designList[value];
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
      DesignType type = designTypeFromJson(data['type']);
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
      'type': designTypeToJson(type),
    };
  }

  @override
  bool operator ==(other) {
    return other is Design && hex == other.hex;
  }

  @override
  int get hashCode => hash2(hex.hashCode, type.hashCode);

  static List<Design> designList = [
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
  ].map((color) => Design.fromColor(color)).toList();
}
