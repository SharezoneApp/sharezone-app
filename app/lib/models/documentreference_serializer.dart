import 'package:built_collection/built_collection.dart';
import 'package:built_value/serializer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

/// A Serializer which does basically "nothing".
/// It is used, as a DocumentReference returned by Firestore is ALREADY a DocumentReference Object
/// and not just "data" which has to be deserialized into a DocumentReference.
/// Also Firestore can take a DocumentReference directly, so it doesn't need to be serialized.
class DocumentReferenceSerializer
    implements PrimitiveSerializer<DocumentReference> {
  final bool structured = false;
  @override
  final Iterable<Type> types = BuiltList<Type>([DocumentReference]);
  @override
  final String wireName = 'DocumentReference';

  @override
  Object serialize(Serializers serializers, DocumentReference documentReference,
      {FullType specifiedType = FullType.unspecified}) {
    return documentReference;
  }

  @override
  DocumentReference deserialize(Serializers serializers, Object serialized,
      {FullType specifiedType = FullType.unspecified}) {
    return serialized as DocumentReference;
  }
}
