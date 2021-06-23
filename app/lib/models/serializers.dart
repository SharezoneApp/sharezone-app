library serializers;

import 'package:built_collection/built_collection.dart';
import 'package:built_value/serializer.dart';
import 'package:built_value/standard_json_plugin.dart';
import 'package:sharezone/models/documentreference_serializer.dart';
import 'package:sharezone/models/extern_apis/holiday.dart';

import 'datetime_serializer.dart';

part 'serializers.g.dart';

/// Example of how to use built_value serialization.
///
/// Declare a top level [Serializers] field called serializers. Annotate it
/// with [SerializersFor] and provide a `const` `List` of types you want to
/// be serializable.
///
/// The built_value code generator will provide the implementation. It will
/// contain serializers for all the types asked for explicitly plus all the
/// types needed transitively via fields.
///
/// You usually only need to do this once per project.
@SerializersFor([
  Holiday,
  HolidayCacheData,
//  State,
])
final Serializers serializers = _$serializers;

/// As a Firestore Document returned by the Firestore/Firebase Plugin returns
/// with an DateTime Object and not with "just" data, it doesn't need to be converted
/// into a DateTime Object. So I've had to add an [TimestampDateTimeSerializer] for DateTime which
/// basically does nothing.
/// As the Firestore Plugin is only usable for flutter and not Web the problem is
/// that this !may! not work if the data has another form than returned of the
/// Firestore Plugin. But this should propably work even on the web. I hope ;)
///
/// see: https://github.com/google/built_value.dart/issues/454
///
/// Also the [StandardJsonPlugin] is used as a Firestore, so maps returned
/// by Firestore are usable and not converted/used as lists, which throws an error.
final standardSerializers = (serializers.toBuilder()
      ..add(DocumentReferenceSerializer())
      ..add(TimestampDateTimeSerializer())
      ..addPlugin(StandardJsonPlugin()))
    .build();

final jsonSerializer = (serializers.toBuilder()
      ..add(LocalDateTimeStringSerializer())
      ..addPlugin(StandardJsonPlugin()))
    .build();
