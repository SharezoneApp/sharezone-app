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
  Iterable<Object?> serialize(Serializers serializers, InlineResponse403 object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object?>[
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
      Serializers serializers, Iterable<Object?> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new InlineResponse403Builder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current! as String;
      iterator.moveNext();
      final Object? value = iterator.current;
      switch (key) {
        case 'error':
          result.error = serializers.deserialize(value,
              specifiedType: const FullType(String))! as String;
          break;
        case 'scope':
          result.scope = serializers.deserialize(value,
              specifiedType: const FullType(String))! as String;
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
          [void Function(InlineResponse403Builder)? updates]) =>
      (new InlineResponse403Builder()..update(updates))._build();

  _$InlineResponse403._({required this.error, required this.scope})
      : super._() {
    BuiltValueNullFieldError.checkNotNull(error, r'InlineResponse403', 'error');
    BuiltValueNullFieldError.checkNotNull(scope, r'InlineResponse403', 'scope');
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
    var _$hash = 0;
    _$hash = $jc(_$hash, error.hashCode);
    _$hash = $jc(_$hash, scope.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'InlineResponse403')
          ..add('error', error)
          ..add('scope', scope))
        .toString();
  }
}

class InlineResponse403Builder
    implements Builder<InlineResponse403, InlineResponse403Builder> {
  _$InlineResponse403? _$v;

  String? _error;
  String? get error => _$this._error;
  set error(String? error) => _$this._error = error;

  String? _scope;
  String? get scope => _$this._scope;
  set scope(String? scope) => _$this._scope = scope;

  InlineResponse403Builder();

  InlineResponse403Builder get _$this {
    final $v = _$v;
    if ($v != null) {
      _error = $v.error;
      _scope = $v.scope;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(InlineResponse403 other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$InlineResponse403;
  }

  @override
  void update(void Function(InlineResponse403Builder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  InlineResponse403 build() => _build();

  _$InlineResponse403 _build() {
    final _$result = _$v ??
        new _$InlineResponse403._(
            error: BuiltValueNullFieldError.checkNotNull(
                error, r'InlineResponse403', 'error'),
            scope: BuiltValueNullFieldError.checkNotNull(
                scope, r'InlineResponse403', 'scope'));
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
