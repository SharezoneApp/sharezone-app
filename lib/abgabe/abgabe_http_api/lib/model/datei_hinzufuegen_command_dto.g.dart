// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'datei_hinzufuegen_command_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

Serializer<DateiHinzufuegenCommandDto> _$dateiHinzufuegenCommandDtoSerializer =
    new _$DateiHinzufuegenCommandDtoSerializer();

class _$DateiHinzufuegenCommandDtoSerializer
    implements StructuredSerializer<DateiHinzufuegenCommandDto> {
  @override
  final Iterable<Type> types = const [
    DateiHinzufuegenCommandDto,
    _$DateiHinzufuegenCommandDto
  ];
  @override
  final String wireName = 'DateiHinzufuegenCommandDto';

  @override
  Iterable<Object?> serialize(
      Serializers serializers, DateiHinzufuegenCommandDto object,
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
  DateiHinzufuegenCommandDto deserialize(
      Serializers serializers, Iterable<Object?> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new DateiHinzufuegenCommandDtoBuilder();

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

class _$DateiHinzufuegenCommandDto extends DateiHinzufuegenCommandDto {
  @override
  final String id;
  @override
  final String name;

  factory _$DateiHinzufuegenCommandDto(
          [void Function(DateiHinzufuegenCommandDtoBuilder)? updates]) =>
      (new DateiHinzufuegenCommandDtoBuilder()..update(updates))._build();

  _$DateiHinzufuegenCommandDto._({required this.id, required this.name})
      : super._() {
    BuiltValueNullFieldError.checkNotNull(
        id, r'DateiHinzufuegenCommandDto', 'id');
    BuiltValueNullFieldError.checkNotNull(
        name, r'DateiHinzufuegenCommandDto', 'name');
  }

  @override
  DateiHinzufuegenCommandDto rebuild(
          void Function(DateiHinzufuegenCommandDtoBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  DateiHinzufuegenCommandDtoBuilder toBuilder() =>
      new DateiHinzufuegenCommandDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is DateiHinzufuegenCommandDto &&
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
    return (newBuiltValueToStringHelper(r'DateiHinzufuegenCommandDto')
          ..add('id', id)
          ..add('name', name))
        .toString();
  }
}

class DateiHinzufuegenCommandDtoBuilder
    implements
        Builder<DateiHinzufuegenCommandDto, DateiHinzufuegenCommandDtoBuilder> {
  _$DateiHinzufuegenCommandDto? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  DateiHinzufuegenCommandDtoBuilder();

  DateiHinzufuegenCommandDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _name = $v.name;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(DateiHinzufuegenCommandDto other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$DateiHinzufuegenCommandDto;
  }

  @override
  void update(void Function(DateiHinzufuegenCommandDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  DateiHinzufuegenCommandDto build() => _build();

  _$DateiHinzufuegenCommandDto _build() {
    final _$result = _$v ??
        new _$DateiHinzufuegenCommandDto._(
            id: BuiltValueNullFieldError.checkNotNull(
                id, r'DateiHinzufuegenCommandDto', 'id'),
            name: BuiltValueNullFieldError.checkNotNull(
                name, r'DateiHinzufuegenCommandDto', 'name'));
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
