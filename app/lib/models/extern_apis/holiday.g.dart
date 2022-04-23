// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

// GENERATED CODE - DO NOT MODIFY BY HAND

part of holiday;

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

Serializer<HolidayCacheData> _$holidayCacheDataSerializer =
    new _$HolidayCacheDataSerializer();
Serializer<Holiday> _$holidaySerializer = new _$HolidaySerializer();

class _$HolidayCacheDataSerializer
    implements StructuredSerializer<HolidayCacheData> {
  @override
  final Iterable<Type> types = const [HolidayCacheData, _$HolidayCacheData];
  @override
  final String wireName = 'HolidayCacheData';

  @override
  Iterable serialize(Serializers serializers, HolidayCacheData object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object>[
      'saved',
      serializers.serialize(object.saved,
          specifiedType: const FullType(DateTime)),
      'holidays',
      serializers.serialize(object.holidays,
          specifiedType:
              const FullType(BuiltList, const [const FullType(Holiday)])),
    ];

    return result;
  }

  @override
  HolidayCacheData deserialize(Serializers serializers, Iterable serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new HolidayCacheDataBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current as String;
      iterator.moveNext();
      final dynamic value = iterator.current;
      switch (key) {
        case 'saved':
          result.saved = serializers.deserialize(value,
              specifiedType: const FullType(DateTime)) as DateTime;
          break;
        case 'holidays':
          result.holidays.replace(serializers.deserialize(value,
              specifiedType: const FullType(
                  BuiltList, const [const FullType(Holiday)])) as BuiltList);
          break;
      }
    }

    return result.build();
  }
}

class _$HolidaySerializer implements StructuredSerializer<Holiday> {
  @override
  final Iterable<Type> types = const [Holiday, _$Holiday];
  @override
  final String wireName = 'Holiday';

  @override
  Iterable serialize(Serializers serializers, Holiday object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object>[
      'start',
      serializers.serialize(object.start,
          specifiedType: const FullType(DateTime)),
      'end',
      serializers.serialize(object.end,
          specifiedType: const FullType(DateTime)),
      'year',
      serializers.serialize(object.year, specifiedType: const FullType(int)),
      'stateCode',
      serializers.serialize(object.stateCode,
          specifiedType: const FullType(String)),
      'name',
      serializers.serialize(object.name, specifiedType: const FullType(String)),
      'slug',
      serializers.serialize(object.slug, specifiedType: const FullType(String)),
    ];

    return result;
  }

  @override
  Holiday deserialize(Serializers serializers, Iterable serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new HolidayBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current as String;
      iterator.moveNext();
      final dynamic value = iterator.current;
      switch (key) {
        case 'start':
          result.start = serializers.deserialize(value,
              specifiedType: const FullType(DateTime)) as DateTime;
          break;
        case 'end':
          result.end = serializers.deserialize(value,
              specifiedType: const FullType(DateTime)) as DateTime;
          break;
        case 'year':
          result.year = serializers.deserialize(value,
              specifiedType: const FullType(int)) as int;
          break;
        case 'stateCode':
          result.stateCode = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'name':
          result.name = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'slug':
          result.slug = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
      }
    }

    return result.build();
  }
}

class _$HolidayCacheData extends HolidayCacheData {
  @override
  final DateTime saved;
  @override
  final BuiltList<Holiday> holidays;

  factory _$HolidayCacheData(
          [void Function(HolidayCacheDataBuilder) updates]) =>
      (new HolidayCacheDataBuilder()..update(updates)).build();

  _$HolidayCacheData._({this.saved, this.holidays}) : super._() {
    if (saved == null) {
      throw new BuiltValueNullFieldError('HolidayCacheData', 'saved');
    }
    if (holidays == null) {
      throw new BuiltValueNullFieldError('HolidayCacheData', 'holidays');
    }
  }

  @override
  HolidayCacheData rebuild(void Function(HolidayCacheDataBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  HolidayCacheDataBuilder toBuilder() =>
      new HolidayCacheDataBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is HolidayCacheData &&
        saved == other.saved &&
        holidays == other.holidays;
  }

  @override
  int get hashCode {
    return $jf($jc($jc(0, saved.hashCode), holidays.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('HolidayCacheData')
          ..add('saved', saved)
          ..add('holidays', holidays))
        .toString();
  }
}

class HolidayCacheDataBuilder
    implements Builder<HolidayCacheData, HolidayCacheDataBuilder> {
  _$HolidayCacheData _$v;

  DateTime _saved;
  DateTime get saved => _$this._saved;
  set saved(DateTime saved) => _$this._saved = saved;

  ListBuilder<Holiday> _holidays;
  ListBuilder<Holiday> get holidays =>
      _$this._holidays ??= new ListBuilder<Holiday>();
  set holidays(ListBuilder<Holiday> holidays) => _$this._holidays = holidays;

  HolidayCacheDataBuilder();

  HolidayCacheDataBuilder get _$this {
    if (_$v != null) {
      _saved = _$v.saved;
      _holidays = _$v.holidays?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(HolidayCacheData other) {
    if (other == null) {
      throw new ArgumentError.notNull('other');
    }
    _$v = other as _$HolidayCacheData;
  }

  @override
  void update(void Function(HolidayCacheDataBuilder) updates) {
    if (updates != null) updates(this);
  }

  @override
  _$HolidayCacheData build() {
    _$HolidayCacheData _$result;
    try {
      _$result = _$v ??
          new _$HolidayCacheData._(saved: saved, holidays: holidays.build());
    } catch (_) {
      String _$failedField;
      try {
        _$failedField = 'holidays';
        holidays.build();
      } catch (e) {
        throw new BuiltValueNestedFieldError(
            'HolidayCacheData', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

class _$Holiday extends Holiday {
  @override
  final DateTime start;
  @override
  final DateTime end;
  @override
  final int year;
  @override
  final String stateCode;
  @override
  final String name;
  @override
  final String slug;

  factory _$Holiday([void Function(HolidayBuilder) updates]) =>
      (new HolidayBuilder()..update(updates)).build();

  _$Holiday._(
      {this.start, this.end, this.year, this.stateCode, this.name, this.slug})
      : super._() {
    if (start == null) {
      throw new BuiltValueNullFieldError('Holiday', 'start');
    }
    if (end == null) {
      throw new BuiltValueNullFieldError('Holiday', 'end');
    }
    if (year == null) {
      throw new BuiltValueNullFieldError('Holiday', 'year');
    }
    if (stateCode == null) {
      throw new BuiltValueNullFieldError('Holiday', 'stateCode');
    }
    if (name == null) {
      throw new BuiltValueNullFieldError('Holiday', 'name');
    }
    if (slug == null) {
      throw new BuiltValueNullFieldError('Holiday', 'slug');
    }
  }

  @override
  Holiday rebuild(void Function(HolidayBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  HolidayBuilder toBuilder() => new HolidayBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is Holiday &&
        start == other.start &&
        end == other.end &&
        year == other.year &&
        stateCode == other.stateCode &&
        name == other.name &&
        slug == other.slug;
  }

  @override
  int get hashCode {
    return $jf($jc(
        $jc(
            $jc($jc($jc($jc(0, start.hashCode), end.hashCode), year.hashCode),
                stateCode.hashCode),
            name.hashCode),
        slug.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('Holiday')
          ..add('start', start)
          ..add('end', end)
          ..add('year', year)
          ..add('stateCode', stateCode)
          ..add('name', name)
          ..add('slug', slug))
        .toString();
  }
}

class HolidayBuilder implements Builder<Holiday, HolidayBuilder> {
  _$Holiday _$v;

  DateTime _start;
  DateTime get start => _$this._start;
  set start(DateTime start) => _$this._start = start;

  DateTime _end;
  DateTime get end => _$this._end;
  set end(DateTime end) => _$this._end = end;

  int _year;
  int get year => _$this._year;
  set year(int year) => _$this._year = year;

  String _stateCode;
  String get stateCode => _$this._stateCode;
  set stateCode(String stateCode) => _$this._stateCode = stateCode;

  String _name;
  String get name => _$this._name;
  set name(String name) => _$this._name = name;

  String _slug;
  String get slug => _$this._slug;
  set slug(String slug) => _$this._slug = slug;

  HolidayBuilder();

  HolidayBuilder get _$this {
    if (_$v != null) {
      _start = _$v.start;
      _end = _$v.end;
      _year = _$v.year;
      _stateCode = _$v.stateCode;
      _name = _$v.name;
      _slug = _$v.slug;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(Holiday other) {
    if (other == null) {
      throw new ArgumentError.notNull('other');
    }
    _$v = other as _$Holiday;
  }

  @override
  void update(void Function(HolidayBuilder) updates) {
    if (updates != null) updates(this);
  }

  @override
  _$Holiday build() {
    final _$result = _$v ??
        new _$Holiday._(
            start: start,
            end: end,
            year: year,
            stateCode: stateCode,
            name: name,
            slug: slug);
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: always_put_control_body_on_new_line,always_specify_types,annotate_overrides,avoid_annotating_with_dynamic,avoid_as,avoid_catches_without_on_clauses,avoid_returning_this,lines_longer_than_80_chars,omit_local_variable_types,prefer_expression_function_bodies,sort_constructors_first,test_types_in_equals,unnecessary_const,unnecessary_new
