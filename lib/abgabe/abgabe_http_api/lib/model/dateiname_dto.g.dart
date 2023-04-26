// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dateiname_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

Serializer<DateinameDto> _$dateinameDtoSerializer =
    new _$DateinameDtoSerializer();

class _$DateinameDtoSerializer implements StructuredSerializer<DateinameDto> {
  @override
  final Iterable<Type> types = const [DateinameDto, _$DateinameDto];
  @override
  final String wireName = 'DateinameDto';

  @override
  Iterable<Object?> serialize(Serializers serializers, DateinameDto object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object?>[
      'name',
      serializers.serialize(object.name, specifiedType: const FullType(String)),
    ];

    return result;
  }

  @override
  DateinameDto deserialize(
      Serializers serializers, Iterable<Object?> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new DateinameDtoBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current! as String;
      iterator.moveNext();
      final Object? value = iterator.current;
      switch (key) {
        case 'name':
          result.name = serializers.deserialize(value,
              specifiedType: const FullType(String))! as String;
          break;
      }
    }

    return result.build();
  }
}

class _$DateinameDto extends DateinameDto {
  @override
  final String name;

  factory _$DateinameDto([void Function(DateinameDtoBuilder)? updates]) =>
      (new DateinameDtoBuilder()..update(updates))._build();

  _$DateinameDto._({required this.name}) : super._() {
    BuiltValueNullFieldError.checkNotNull(name, r'DateinameDto', 'name');
  }

  @override
  DateinameDto rebuild(void Function(DateinameDtoBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  DateinameDtoBuilder toBuilder() => new DateinameDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is DateinameDto && name == other.name;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'DateinameDto')..add('name', name))
        .toString();
  }
}

class DateinameDtoBuilder
    implements Builder<DateinameDto, DateinameDtoBuilder> {
  _$DateinameDto? _$v;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  DateinameDtoBuilder();

  DateinameDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _name = $v.name;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(DateinameDto other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$DateinameDto;
  }

  @override
  void update(void Function(DateinameDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  DateinameDto build() => _build();

  _$DateinameDto _build() {
    final _$result = _$v ??
        new _$DateinameDto._(
            name: BuiltValueNullFieldError.checkNotNull(
                name, r'DateinameDto', 'name'));
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
