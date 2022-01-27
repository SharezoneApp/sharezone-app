// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'inline_response403.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

Serializer<InlineResponse403> _$inlineResponse403Serializer =
    new _$InlineResponse403Serializer();

class _$InlineResponse403Serializer
    implements StructuredSerializer<InlineResponse403> {
  @override
  final Iterable<Type> types = const [InlineResponse403, _$InlineResponse403];
  @override
  final String wireName = 'InlineResponse403';

  @override
  Iterable<Object> serialize(Serializers serializers, InlineResponse403 object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object>[
      'error',
      serializers.serialize(object.error,
          specifiedType: const FullType(String)),
      'scope',
      serializers.serialize(object.scope,
          specifiedType: const FullType(String)),
    ];

    return result;
  }

  @override
  InlineResponse403 deserialize(
      Serializers serializers, Iterable<Object> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new InlineResponse403Builder();

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
        case 'scope':
          result.scope = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
      }
    }

    return result.build();
  }
}

class _$InlineResponse403 extends InlineResponse403 {
  @override
  final String error;
  @override
  final String scope;

  factory _$InlineResponse403(
          [void Function(InlineResponse403Builder) updates]) =>
      (new InlineResponse403Builder()..update(updates)).build();

  _$InlineResponse403._({this.error, this.scope}) : super._() {
    if (error == null) {
      throw new BuiltValueNullFieldError('InlineResponse403', 'error');
    }
    if (scope == null) {
      throw new BuiltValueNullFieldError('InlineResponse403', 'scope');
    }
  }

  @override
  InlineResponse403 rebuild(void Function(InlineResponse403Builder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  InlineResponse403Builder toBuilder() =>
      new InlineResponse403Builder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is InlineResponse403 &&
        error == other.error &&
        scope == other.scope;
  }

  @override
  int get hashCode {
    return $jf($jc($jc(0, error.hashCode), scope.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('InlineResponse403')
          ..add('error', error)
          ..add('scope', scope))
        .toString();
  }
}

class InlineResponse403Builder
    implements Builder<InlineResponse403, InlineResponse403Builder> {
  _$InlineResponse403 _$v;

  String _error;
  String get error => _$this._error;
  set error(String error) => _$this._error = error;

  String _scope;
  String get scope => _$this._scope;
  set scope(String scope) => _$this._scope = scope;

  InlineResponse403Builder();

  InlineResponse403Builder get _$this {
    if (_$v != null) {
      _error = _$v.error;
      _scope = _$v.scope;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(InlineResponse403 other) {
    if (other == null) {
      throw new ArgumentError.notNull('other');
    }
    _$v = other as _$InlineResponse403;
  }

  @override
  void update(void Function(InlineResponse403Builder) updates) {
    if (updates != null) updates(this);
  }

  @override
  _$InlineResponse403 build() {
    final _$result =
        _$v ?? new _$InlineResponse403._(error: error, scope: scope);
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: always_put_control_body_on_new_line,always_specify_types,annotate_overrides,avoid_annotating_with_dynamic,avoid_as,avoid_catches_without_on_clauses,avoid_returning_this,lines_longer_than_80_chars,omit_local_variable_types,prefer_expression_function_bodies,sort_constructors_first,test_types_in_equals,unnecessary_const,unnecessary_new
