library holiday;

import 'dart:convert';

import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:sharezone/models/serializers.dart';

part 'holiday.g.dart';

// flutter packages pub run build_runner build

abstract class HolidayCacheData
    implements Built<HolidayCacheData, HolidayCacheDataBuilder> {
  factory HolidayCacheData([updates(HolidayCacheDataBuilder b)]) =
      _$HolidayCacheData;

  HolidayCacheData._();

  DateTime get saved;
  BuiltList<Holiday> get holidays;
  String toJson() {
    return json.encode(
        jsonSerializer.serializeWith(HolidayCacheData.serializer, this));
  }

  static HolidayCacheData fromJson(String jsonString) {
    return jsonSerializer.deserializeWith(
        HolidayCacheData.serializer, json.decode(jsonString));
  }

  static Serializer<HolidayCacheData> get serializer =>
      _$holidayCacheDataSerializer;
}

abstract class Holiday implements Built<Holiday, HolidayBuilder> {
  factory Holiday([updates(HolidayBuilder b)]) = _$Holiday;
  Holiday._();

  @BuiltValueField(wireName: 'start')
  DateTime get start;
  @BuiltValueField(wireName: 'end')
  DateTime get end;
  @BuiltValueField(wireName: 'year')
  int get year;
  @BuiltValueField(wireName: 'stateCode')
  String get stateCode;
  @BuiltValueField(wireName: 'name')
  String get name;
  @BuiltValueField(wireName: 'slug')
  String get slug;
  String toJson() {
    return json.encode(jsonSerializer.serializeWith(Holiday.serializer, this));
  }

  static Holiday fromJson(String jsonString) {
    return jsonSerializer.deserializeWith(
        Holiday.serializer, json.decode(jsonString));
  }

  static Serializer<Holiday> get serializer => _$holidaySerializer;
}
