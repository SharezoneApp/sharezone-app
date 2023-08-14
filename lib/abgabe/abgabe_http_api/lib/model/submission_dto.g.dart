// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'submission_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

Serializer<SubmissionDto> _$submissionDtoSerializer =
    new _$SubmissionDtoSerializer();

class _$SubmissionDtoSerializer implements StructuredSerializer<SubmissionDto> {
  @override
  final Iterable<Type> types = const [SubmissionDto, _$SubmissionDto];
  @override
  final String wireName = 'SubmissionDto';

  @override
  Iterable<Object?> serialize(Serializers serializers, SubmissionDto object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object?>[
      'published',
      serializers.serialize(object.published,
          specifiedType: const FullType(bool)),
    ];

    return result;
  }

  @override
  SubmissionDto deserialize(
      Serializers serializers, Iterable<Object?> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new SubmissionDtoBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current! as String;
      iterator.moveNext();
      final Object? value = iterator.current;
      switch (key) {
        case 'published':
          result.published = serializers.deserialize(value,
              specifiedType: const FullType(bool))! as bool;
          break;
      }
    }

    return result.build();
  }
}

class _$SubmissionDto extends SubmissionDto {
  @override
  final bool published;

  factory _$SubmissionDto([void Function(SubmissionDtoBuilder)? updates]) =>
      (new SubmissionDtoBuilder()..update(updates))._build();

  _$SubmissionDto._({required this.published}) : super._() {
    BuiltValueNullFieldError.checkNotNull(
        published, r'SubmissionDto', 'published');
  }

  @override
  SubmissionDto rebuild(void Function(SubmissionDtoBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  SubmissionDtoBuilder toBuilder() => new SubmissionDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is SubmissionDto && published == other.published;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, published.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'SubmissionDto')
          ..add('published', published))
        .toString();
  }
}

class SubmissionDtoBuilder
    implements Builder<SubmissionDto, SubmissionDtoBuilder> {
  _$SubmissionDto? _$v;

  bool? _published;
  bool? get published => _$this._published;
  set published(bool? published) => _$this._published = published;

  SubmissionDtoBuilder();

  SubmissionDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _published = $v.published;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(SubmissionDto other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$SubmissionDto;
  }

  @override
  void update(void Function(SubmissionDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  SubmissionDto build() => _build();

  _$SubmissionDto _build() {
    final _$result = _$v ??
        new _$SubmissionDto._(
            published: BuiltValueNullFieldError.checkNotNull(
                published, r'SubmissionDto', 'published'));
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
