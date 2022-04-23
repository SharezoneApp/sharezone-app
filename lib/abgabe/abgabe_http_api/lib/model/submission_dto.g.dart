// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

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
  Iterable<Object> serialize(Serializers serializers, SubmissionDto object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object>[
      'published',
      serializers.serialize(object.published,
          specifiedType: const FullType(bool)),
    ];

    return result;
  }

  @override
  SubmissionDto deserialize(
      Serializers serializers, Iterable<Object> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new SubmissionDtoBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current as String;
      iterator.moveNext();
      final dynamic value = iterator.current;
      switch (key) {
        case 'published':
          result.published = serializers.deserialize(value,
              specifiedType: const FullType(bool)) as bool;
          break;
      }
    }

    return result.build();
  }
}

class _$SubmissionDto extends SubmissionDto {
  @override
  final bool published;

  factory _$SubmissionDto([void Function(SubmissionDtoBuilder) updates]) =>
      (new SubmissionDtoBuilder()..update(updates)).build();

  _$SubmissionDto._({this.published}) : super._() {
    if (published == null) {
      throw new BuiltValueNullFieldError('SubmissionDto', 'published');
    }
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
    return $jf($jc(0, published.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('SubmissionDto')
          ..add('published', published))
        .toString();
  }
}

class SubmissionDtoBuilder
    implements Builder<SubmissionDto, SubmissionDtoBuilder> {
  _$SubmissionDto _$v;

  bool _published;
  bool get published => _$this._published;
  set published(bool published) => _$this._published = published;

  SubmissionDtoBuilder();

  SubmissionDtoBuilder get _$this {
    if (_$v != null) {
      _published = _$v.published;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(SubmissionDto other) {
    if (other == null) {
      throw new ArgumentError.notNull('other');
    }
    _$v = other as _$SubmissionDto;
  }

  @override
  void update(void Function(SubmissionDtoBuilder) updates) {
    if (updates != null) updates(this);
  }

  @override
  _$SubmissionDto build() {
    final _$result = _$v ?? new _$SubmissionDto._(published: published);
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: always_put_control_body_on_new_line,always_specify_types,annotate_overrides,avoid_annotating_with_dynamic,avoid_as,avoid_catches_without_on_clauses,avoid_returning_this,lines_longer_than_80_chars,omit_local_variable_types,prefer_expression_function_bodies,sort_constructors_first,test_types_in_equals,unnecessary_const,unnecessary_new
