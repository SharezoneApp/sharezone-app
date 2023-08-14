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
  Iterable<Object?> serialize(Serializers serializers, InlineResponse400 object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object?>[
      'error',
      serializers.serialize(object.error,
          specifiedType: const FullType(String)),
    ];

    return result;
  }

  @override
  InlineResponse400 deserialize(
      Serializers serializers, Iterable<Object?> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new InlineResponse400Builder();

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
      }
    }

    return result.build();
  }
}

class _$InlineResponse400 extends InlineResponse400 {
  @override
  final String error;

  factory _$InlineResponse400(
          [void Function(InlineResponse400Builder)? updates]) =>
      (new InlineResponse400Builder()..update(updates))._build();

  _$InlineResponse400._({required this.error}) : super._() {
    BuiltValueNullFieldError.checkNotNull(error, r'InlineResponse400', 'error');
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
    var _$hash = 0;
    _$hash = $jc(_$hash, error.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'InlineResponse400')
          ..add('error', error))
        .toString();
  }
}

class InlineResponse400Builder
    implements Builder<InlineResponse400, InlineResponse400Builder> {
  _$InlineResponse400? _$v;

  String? _error;
  String? get error => _$this._error;
  set error(String? error) => _$this._error = error;

  InlineResponse400Builder();

  InlineResponse400Builder get _$this {
    final $v = _$v;
    if ($v != null) {
      _error = $v.error;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(InlineResponse400 other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$InlineResponse400;
  }

  @override
  void update(void Function(InlineResponse400Builder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  InlineResponse400 build() => _build();

  _$InlineResponse400 _build() {
    final _$result = _$v ??
        new _$InlineResponse400._(
            error: BuiltValueNullFieldError.checkNotNull(
                error, r'InlineResponse400', 'error'));
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
