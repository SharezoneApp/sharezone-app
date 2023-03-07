// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'datei_hinzufuegen_command_dto1.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

Serializer<DateiHinzufuegenCommandDto1>
    _$dateiHinzufuegenCommandDto1Serializer =
    new _$DateiHinzufuegenCommandDto1Serializer();

class _$DateiHinzufuegenCommandDto1Serializer
    implements StructuredSerializer<DateiHinzufuegenCommandDto1> {
  @override
  final Iterable<Type> types = const [
    DateiHinzufuegenCommandDto1,
    _$DateiHinzufuegenCommandDto1
  ];
  @override
  final String wireName = 'DateiHinzufuegenCommandDto1';

  @override
  Iterable<Object?> serialize(
      Serializers serializers, DateiHinzufuegenCommandDto1 object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object?>[
      'id',
      serializers.serialize(object.id, specifiedType: const FullType(String)),
      'name',
      serializers.serialize(object.name, specifiedType: const FullType(String)),
    ];

    return result;
  }

  @override
  DateiHinzufuegenCommandDto1 deserialize(
      Serializers serializers, Iterable<Object?> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new DateiHinzufuegenCommandDto1Builder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current! as String;
      iterator.moveNext();
      final Object? value = iterator.current;
      switch (key) {
        case 'id':
          result.id = serializers.deserialize(value,
              specifiedType: const FullType(String))! as String;
          break;
        case 'name':
          result.name = serializers.deserialize(value,
              specifiedType: const FullType(String))! as String;
          break;
      }
    }

    return result.build();
  }
}

class _$DateiHinzufuegenCommandDto1 extends DateiHinzufuegenCommandDto1 {
  @override
  final String id;
  @override
  final String name;

  factory _$DateiHinzufuegenCommandDto1(
          [void Function(DateiHinzufuegenCommandDto1Builder)? updates]) =>
      (new DateiHinzufuegenCommandDto1Builder()..update(updates))._build();

  _$DateiHinzufuegenCommandDto1._({required this.id, required this.name})
      : super._() {
    BuiltValueNullFieldError.checkNotNull(
        id, r'DateiHinzufuegenCommandDto1', 'id');
    BuiltValueNullFieldError.checkNotNull(
        name, r'DateiHinzufuegenCommandDto1', 'name');
  }

  @override
  DateiHinzufuegenCommandDto1 rebuild(
          void Function(DateiHinzufuegenCommandDto1Builder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  DateiHinzufuegenCommandDto1Builder toBuilder() =>
      new DateiHinzufuegenCommandDto1Builder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is DateiHinzufuegenCommandDto1 &&
        id == other.id &&
        name == other.name;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'DateiHinzufuegenCommandDto1')
          ..add('id', id)
          ..add('name', name))
        .toString();
  }
}

class DateiHinzufuegenCommandDto1Builder
    implements
        Builder<DateiHinzufuegenCommandDto1,
            DateiHinzufuegenCommandDto1Builder> {
  _$DateiHinzufuegenCommandDto1? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  DateiHinzufuegenCommandDto1Builder();

  DateiHinzufuegenCommandDto1Builder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _name = $v.name;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(DateiHinzufuegenCommandDto1 other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$DateiHinzufuegenCommandDto1;
  }

  @override
  void update(void Function(DateiHinzufuegenCommandDto1Builder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  DateiHinzufuegenCommandDto1 build() => _build();

  _$DateiHinzufuegenCommandDto1 _build() {
    final _$result = _$v ??
        new _$DateiHinzufuegenCommandDto1._(
            id: BuiltValueNullFieldError.checkNotNull(
                id, r'DateiHinzufuegenCommandDto1', 'id'),
            name: BuiltValueNullFieldError.checkNotNull(
                name, r'DateiHinzufuegenCommandDto1', 'name'));
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
