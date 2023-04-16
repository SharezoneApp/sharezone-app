// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dateien_hinzufuegen_command_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

Serializer<DateienHinzufuegenCommandDto>
    _$dateienHinzufuegenCommandDtoSerializer =
    new _$DateienHinzufuegenCommandDtoSerializer();

class _$DateienHinzufuegenCommandDtoSerializer
    implements StructuredSerializer<DateienHinzufuegenCommandDto> {
  @override
  final Iterable<Type> types = const [
    DateienHinzufuegenCommandDto,
    _$DateienHinzufuegenCommandDto
  ];
  @override
  final String wireName = 'DateienHinzufuegenCommandDto';

  @override
  Iterable<Object?> serialize(
      Serializers serializers, DateienHinzufuegenCommandDto object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object?>[
      'hinzufuegenCommands',
      serializers.serialize(object.hinzufuegenCommands,
          specifiedType: const FullType(
              BuiltList, const [const FullType(DateiHinzufuegenCommandDto)])),
    ];

    return result;
  }

  @override
  DateienHinzufuegenCommandDto deserialize(
      Serializers serializers, Iterable<Object?> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new DateienHinzufuegenCommandDtoBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current! as String;
      iterator.moveNext();
      final Object? value = iterator.current;
      switch (key) {
        case 'hinzufuegenCommands':
          result.hinzufuegenCommands.replace(serializers.deserialize(value,
              specifiedType: const FullType(BuiltList, const [
                const FullType(DateiHinzufuegenCommandDto)
              ]))! as BuiltList<Object?>);
          break;
      }
    }

    return result.build();
  }
}

class _$DateienHinzufuegenCommandDto extends DateienHinzufuegenCommandDto {
  @override
  final BuiltList<DateiHinzufuegenCommandDto> hinzufuegenCommands;

  factory _$DateienHinzufuegenCommandDto(
          [void Function(DateienHinzufuegenCommandDtoBuilder)? updates]) =>
      (new DateienHinzufuegenCommandDtoBuilder()..update(updates))._build();

  _$DateienHinzufuegenCommandDto._({required this.hinzufuegenCommands})
      : super._() {
    BuiltValueNullFieldError.checkNotNull(hinzufuegenCommands,
        r'DateienHinzufuegenCommandDto', 'hinzufuegenCommands');
  }

  @override
  DateienHinzufuegenCommandDto rebuild(
          void Function(DateienHinzufuegenCommandDtoBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  DateienHinzufuegenCommandDtoBuilder toBuilder() =>
      new DateienHinzufuegenCommandDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is DateienHinzufuegenCommandDto &&
        hinzufuegenCommands == other.hinzufuegenCommands;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, hinzufuegenCommands.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'DateienHinzufuegenCommandDto')
          ..add('hinzufuegenCommands', hinzufuegenCommands))
        .toString();
  }
}

class DateienHinzufuegenCommandDtoBuilder
    implements
        Builder<DateienHinzufuegenCommandDto,
            DateienHinzufuegenCommandDtoBuilder> {
  _$DateienHinzufuegenCommandDto? _$v;

  ListBuilder<DateiHinzufuegenCommandDto>? _hinzufuegenCommands;
  ListBuilder<DateiHinzufuegenCommandDto> get hinzufuegenCommands =>
      _$this._hinzufuegenCommands ??=
          new ListBuilder<DateiHinzufuegenCommandDto>();
  set hinzufuegenCommands(
          ListBuilder<DateiHinzufuegenCommandDto>? hinzufuegenCommands) =>
      _$this._hinzufuegenCommands = hinzufuegenCommands;

  DateienHinzufuegenCommandDtoBuilder();

  DateienHinzufuegenCommandDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _hinzufuegenCommands = $v.hinzufuegenCommands.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(DateienHinzufuegenCommandDto other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$DateienHinzufuegenCommandDto;
  }

  @override
  void update(void Function(DateienHinzufuegenCommandDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  DateienHinzufuegenCommandDto build() => _build();

  _$DateienHinzufuegenCommandDto _build() {
    _$DateienHinzufuegenCommandDto _$result;
    try {
      _$result = _$v ??
          new _$DateienHinzufuegenCommandDto._(
              hinzufuegenCommands: hinzufuegenCommands.build());
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'hinzufuegenCommands';
        hinzufuegenCommands.build();
      } catch (e) {
        throw new BuiltValueNestedFieldError(
            r'DateienHinzufuegenCommandDto', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
