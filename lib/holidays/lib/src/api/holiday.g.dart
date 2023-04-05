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
  Iterable<Object?> serialize(Serializers serializers, HolidayCacheData object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object?>[
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
  HolidayCacheData deserialize(
      Serializers serializers, Iterable<Object?> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new HolidayCacheDataBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current! as String;
      iterator.moveNext();
      final Object? value = iterator.current;
      switch (key) {
        case 'saved':
          result.saved = serializers.deserialize(value,
              specifiedType: const FullType(DateTime))! as DateTime;
          break;
        case 'holidays':
          result.holidays.replace(serializers.deserialize(value,
                  specifiedType: const FullType(
                      BuiltList, const [const FullType(Holiday)]))!
              as BuiltList<Object?>);
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
  Iterable<Object?> serialize(Serializers serializers, Holiday object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object?>[
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
  Holiday deserialize(Serializers serializers, Iterable<Object?> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new HolidayBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current! as String;
      iterator.moveNext();
      final Object? value = iterator.current;
      switch (key) {
        case 'start':
          result.start = serializers.deserialize(value,
              specifiedType: const FullType(DateTime))! as DateTime;
          break;
        case 'end':
          result.end = serializers.deserialize(value,
              specifiedType: const FullType(DateTime))! as DateTime;
          break;
        case 'year':
          result.year = serializers.deserialize(value,
              specifiedType: const FullType(int))! as int;
          break;
        case 'stateCode':
          result.stateCode = serializers.deserialize(value,
              specifiedType: const FullType(String))! as String;
          break;
        case 'name':
          result.name = serializers.deserialize(value,
              specifiedType: const FullType(String))! as String;
          break;
        case 'slug':
          result.slug = serializers.deserialize(value,
              specifiedType: const FullType(String))! as String;
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
          [void Function(HolidayCacheDataBuilder)? updates]) =>
      (new HolidayCacheDataBuilder()..update(updates))._build();

  _$HolidayCacheData._({required this.saved, required this.holidays})
      : super._() {
    BuiltValueNullFieldError.checkNotNull(saved, r'HolidayCacheData', 'saved');
    BuiltValueNullFieldError.checkNotNull(
        holidays, r'HolidayCacheData', 'holidays');
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
    var _$hash = 0;
    _$hash = $jc(_$hash, saved.hashCode);
    _$hash = $jc(_$hash, holidays.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'HolidayCacheData')
          ..add('saved', saved)
          ..add('holidays', holidays))
        .toString();
  }
}

class HolidayCacheDataBuilder
    implements Builder<HolidayCacheData, HolidayCacheDataBuilder> {
  _$HolidayCacheData? _$v;

  DateTime? _saved;
  DateTime? get saved => _$this._saved;
  set saved(DateTime? saved) => _$this._saved = saved;

  ListBuilder<Holiday>? _holidays;
  ListBuilder<Holiday> get holidays =>
      _$this._holidays ??= new ListBuilder<Holiday>();
  set holidays(ListBuilder<Holiday>? holidays) => _$this._holidays = holidays;

  HolidayCacheDataBuilder();

  HolidayCacheDataBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _saved = $v.saved;
      _holidays = $v.holidays.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(HolidayCacheData other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$HolidayCacheData;
  }

  @override
  void update(void Function(HolidayCacheDataBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  HolidayCacheData build() => _build();

  _$HolidayCacheData _build() {
    _$HolidayCacheData _$result;
    try {
      _$result = _$v ??
          new _$HolidayCacheData._(
              saved: BuiltValueNullFieldError.checkNotNull(
                  saved, r'HolidayCacheData', 'saved'),
              holidays: holidays.build());
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'holidays';
        holidays.build();
      } catch (e) {
        throw new BuiltValueNestedFieldError(
            r'HolidayCacheData', _$failedField, e.toString());
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

  factory _$Holiday([void Function(HolidayBuilder)? updates]) =>
      (new HolidayBuilder()..update(updates))._build();

  _$Holiday._(
      {required this.start,
      required this.end,
      required this.year,
      required this.stateCode,
      required this.name,
      required this.slug})
      : super._() {
    BuiltValueNullFieldError.checkNotNull(start, r'Holiday', 'start');
    BuiltValueNullFieldError.checkNotNull(end, r'Holiday', 'end');
    BuiltValueNullFieldError.checkNotNull(year, r'Holiday', 'year');
    BuiltValueNullFieldError.checkNotNull(stateCode, r'Holiday', 'stateCode');
    BuiltValueNullFieldError.checkNotNull(name, r'Holiday', 'name');
    BuiltValueNullFieldError.checkNotNull(slug, r'Holiday', 'slug');
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
    var _$hash = 0;
    _$hash = $jc(_$hash, start.hashCode);
    _$hash = $jc(_$hash, end.hashCode);
    _$hash = $jc(_$hash, year.hashCode);
    _$hash = $jc(_$hash, stateCode.hashCode);
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jc(_$hash, slug.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'Holiday')
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
  _$Holiday? _$v;

  DateTime? _start;
  DateTime? get start => _$this._start;
  set start(DateTime? start) => _$this._start = start;

  DateTime? _end;
  DateTime? get end => _$this._end;
  set end(DateTime? end) => _$this._end = end;

  int? _year;
  int? get year => _$this._year;
  set year(int? year) => _$this._year = year;

  String? _stateCode;
  String? get stateCode => _$this._stateCode;
  set stateCode(String? stateCode) => _$this._stateCode = stateCode;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  String? _slug;
  String? get slug => _$this._slug;
  set slug(String? slug) => _$this._slug = slug;

  HolidayBuilder();

  HolidayBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _start = $v.start;
      _end = $v.end;
      _year = $v.year;
      _stateCode = $v.stateCode;
      _name = $v.name;
      _slug = $v.slug;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(Holiday other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$Holiday;
  }

  @override
  void update(void Function(HolidayBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  Holiday build() => _build();

  _$Holiday _build() {
    final _$result = _$v ??
        new _$Holiday._(
            start: BuiltValueNullFieldError.checkNotNull(
                start, r'Holiday', 'start'),
            end: BuiltValueNullFieldError.checkNotNull(end, r'Holiday', 'end'),
            year:
                BuiltValueNullFieldError.checkNotNull(year, r'Holiday', 'year'),
            stateCode: BuiltValueNullFieldError.checkNotNull(
                stateCode, r'Holiday', 'stateCode'),
            name:
                BuiltValueNullFieldError.checkNotNull(name, r'Holiday', 'name'),
            slug: BuiltValueNullFieldError.checkNotNull(
                slug, r'Holiday', 'slug'));
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
