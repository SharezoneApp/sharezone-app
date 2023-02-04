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
  Iterable<Object> serialize(
      Serializers serializers, DateienHinzufuegenCommandDto object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object>[
      'hinzufuegenCommands',
      serializers.serialize(object.hinzufuegenCommands,
          specifiedType: const FullType(
              BuiltList, const [const FullType(DateiHinzufuegenCommandDto1)])),
    ];

    return result;
  }

  @override
  DateienHinzufuegenCommandDto deserialize(
      Serializers serializers, Iterable<Object> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new DateienHinzufuegenCommandDtoBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current as String;
      iterator.moveNext();
      final dynamic value = iterator.current;
      switch (key) {
        case 'hinzufuegenCommands':
          result.hinzufuegenCommands.replace(serializers.deserialize(value,
              specifiedType: const FullType(BuiltList, const [
                const FullType(DateiHinzufuegenCommandDto1)
              ])) as BuiltList<dynamic>);
          break;
      }
    }

    return result.build();
  }
}

class _$DateienHinzufuegenCommandDto extends DateienHinzufuegenCommandDto {
  @override
  final BuiltList<DateiHinzufuegenCommandDto1> hinzufuegenCommands;

  factory _$DateienHinzufuegenCommandDto(
          [void Function(DateienHinzufuegenCommandDtoBuilder) updates]) =>
      (new DateienHinzufuegenCommandDtoBuilder()..update(updates)).build();

  _$DateienHinzufuegenCommandDto._({this.hinzufuegenCommands}) : super._() {
    if (hinzufuegenCommands == null) {
      throw new BuiltValueNullFieldError(
          'DateienHinzufuegenCommandDto', 'hinzufuegenCommands');
    }
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
    return $jf($jc(0, hinzufuegenCommands.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('DateienHinzufuegenCommandDto')
          ..add('hinzufuegenCommands', hinzufuegenCommands))
        .toString();
  }
}

class DateienHinzufuegenCommandDtoBuilder
    implements
        Builder<DateienHinzufuegenCommandDto,
            DateienHinzufuegenCommandDtoBuilder> {
  _$DateienHinzufuegenCommandDto _$v;

  ListBuilder<DateiHinzufuegenCommandDto1> _hinzufuegenCommands;
  ListBuilder<DateiHinzufuegenCommandDto1> get hinzufuegenCommands =>
      _$this._hinzufuegenCommands ??=
          new ListBuilder<DateiHinzufuegenCommandDto1>();
  set hinzufuegenCommands(
          ListBuilder<DateiHinzufuegenCommandDto1> hinzufuegenCommands) =>
      _$this._hinzufuegenCommands = hinzufuegenCommands;

  DateienHinzufuegenCommandDtoBuilder();

  DateienHinzufuegenCommandDtoBuilder get _$this {
    if (_$v != null) {
      _hinzufuegenCommands = _$v.hinzufuegenCommands?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(DateienHinzufuegenCommandDto other) {
    if (other == null) {
      throw new ArgumentError.notNull('other');
    }
    _$v = other as _$DateienHinzufuegenCommandDto;
  }

  @override
  void update(void Function(DateienHinzufuegenCommandDtoBuilder) updates) {
    if (updates != null) updates(this);
  }

  @override
  _$DateienHinzufuegenCommandDto build() {
    _$DateienHinzufuegenCommandDto _$result;
    try {
      _$result = _$v ??
          new _$DateienHinzufuegenCommandDto._(
              hinzufuegenCommands: hinzufuegenCommands.build());
    } catch (_) {
      String _$failedField;
      try {
        _$failedField = 'hinzufuegenCommands';
        hinzufuegenCommands.build();
      } catch (e) {
        throw new BuiltValueNestedFieldError(
            'DateienHinzufuegenCommandDto', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: always_put_control_body_on_new_line,always_specify_types,annotate_overrides,avoid_annotating_with_dynamic,avoid_as,avoid_catches_without_on_clauses,avoid_returning_this,lines_longer_than_80_chars,omit_local_variable_types,prefer_expression_function_bodies,sort_constructors_first,test_types_in_equals,unnecessary_const,unnecessary_new
