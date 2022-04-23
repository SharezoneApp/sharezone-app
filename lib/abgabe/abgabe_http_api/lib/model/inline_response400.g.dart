// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'inline_response400.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

Serializer<InlineResponse400> _$inlineResponse400Serializer =
    new _$InlineResponse400Serializer();

class _$InlineResponse400Serializer
    implements StructuredSerializer<InlineResponse400> {
  @override
  final Iterable<Type> types = const [InlineResponse400, _$InlineResponse400];
  @override
  final String wireName = 'InlineResponse400';

  @override
  Iterable<Object> serialize(Serializers serializers, InlineResponse400 object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object>[
      'error',
      serializers.serialize(object.error,
          specifiedType: const FullType(String)),
    ];

    return result;
  }

  @override
  InlineResponse400 deserialize(
      Serializers serializers, Iterable<Object> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new InlineResponse400Builder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current as String;
      iterator.moveNext();
      final dynamic value = iterator.current;
      switch (key) {
        case 'error':
          result.error = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
      }
    }

    return result.build();
  }
}

class _$InlineResponse400 extends InlineResponse400 {
  @override
  final String error;

  factory _$InlineResponse400(
          [void Function(InlineResponse400Builder) updates]) =>
      (new InlineResponse400Builder()..update(updates)).build();

  _$InlineResponse400._({this.error}) : super._() {
    if (error == null) {
      throw new BuiltValueNullFieldError('InlineResponse400', 'error');
    }
  }

  @override
  InlineResponse400 rebuild(void Function(InlineResponse400Builder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  InlineResponse400Builder toBuilder() =>
      new InlineResponse400Builder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is InlineResponse400 && error == other.error;
  }

  @override
  int get hashCode {
    return $jf($jc(0, error.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('InlineResponse400')
          ..add('error', error))
        .toString();
  }
}

class InlineResponse400Builder
    implements Builder<InlineResponse400, InlineResponse400Builder> {
  _$InlineResponse400 _$v;

  String _error;
  String get error => _$this._error;
  set error(String error) => _$this._error = error;

  InlineResponse400Builder();

  InlineResponse400Builder get _$this {
    if (_$v != null) {
      _error = _$v.error;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(InlineResponse400 other) {
    if (other == null) {
      throw new ArgumentError.notNull('other');
    }
    _$v = other as _$InlineResponse400;
  }

  @override
  void update(void Function(InlineResponse400Builder) updates) {
    if (updates != null) updates(this);
  }

  @override
  _$InlineResponse400 build() {
    final _$result = _$v ?? new _$InlineResponse400._(error: error);
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: always_put_control_body_on_new_line,always_specify_types,annotate_overrides,avoid_annotating_with_dynamic,avoid_as,avoid_catches_without_on_clauses,avoid_returning_this,lines_longer_than_80_chars,omit_local_variable_types,prefer_expression_function_bodies,sort_constructors_first,test_types_in_equals,unnecessary_const,unnecessary_new
