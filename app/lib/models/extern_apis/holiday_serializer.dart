import 'package:built_collection/built_collection.dart';
import 'package:built_value/serializer.dart';

/// Alternative serializer for [DateTime].
///
/// Primarily used to deserialize the API-Response from http://api.smartnoob.de/ferien/v1/ferien/?bundesland=nw.
/// It takes the double secondsSinceEpoch (e.g. 1522015200.0) from the API
/// and converts it into a DateTime Object.
///
/// The DateTime gets serialized as an ISO8601String
class HolidayAPIDateTimeSerializer implements PrimitiveSerializer<DateTime> {
  final bool structured = false;
  @override
  final Iterable<Type> types = BuiltList<Type>([DateTime]);
  @override
  final String wireName = 'DateTime';

  @override
  Object serialize(Serializers serializers, DateTime dateTime,
      {FullType specifiedType = FullType.unspecified}) {
    return dateTime.toIso8601String();
  }

  @override
  DateTime deserialize(Serializers serializers, Object serialized,
      {FullType specifiedType = FullType.unspecified}) {
    if (serialized is double) {
      final int millisecondsSinceEpoch = serialized.truncate() * 1000;
      return DateTime.fromMillisecondsSinceEpoch(millisecondsSinceEpoch);
    } else if (serialized is String) {
      return DateTime.parse(serialized);
    } else {
      throw Exception("""
      The passed ${serialized.runtimeType} needs to be either a double representing the secondsSinceEpoch with a trailing 0 (e.g. 1522015200.0)
      or an ISO8601String convertable with DateTime.parse().
      """);
    }
  }
}
