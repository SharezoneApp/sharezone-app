import 'package:cloud_firestore/cloud_firestore.dart';

/// Convert Enum to String

typedef ObjectMapBuilder<T> = T Function(String key, dynamic decodedMapValue);
typedef ObjectListBuilder<T> = T Function(dynamic decodedMapValue);

Map<String, T> decodeMap<T>(dynamic data, ObjectMapBuilder<T> builder) {
  Map<dynamic, dynamic> originaldata = data?.cast<dynamic, dynamic>();
  if (originaldata != null)
    originaldata.removeWhere((key, value) => value == null);
  Map<String, dynamic> decodedMap = (originaldata ?? {}).map<String, dynamic>(
      (dynamic key, dynamic value) => MapEntry<String, dynamic>(key, value));
  return decodedMap.map((key, value) => MapEntry(key, builder(key, value)));
}

Map<T1, T2> decodeMapAdvanced<T1, T2>(dynamic data,
    MapEntry<T1, T2> Function(dynamic key, dynamic value) mapEntryBuilder) {
  Map<dynamic, dynamic> originaldata = data?.cast<dynamic, dynamic>();
  if (originaldata != null)
    originaldata.removeWhere((key, value) => value == null);
  final decodedMap =
      (originaldata ?? {}).map((key, value) => mapEntryBuilder(key, value));
  return decodedMap;
}

List<T> decodeList<T>(dynamic data, ObjectListBuilder<T> builder) {
  List<dynamic> originaldata = data;
  if (originaldata == null) return [];
  return originaldata.map((dynamic value) => builder(value)).toList();
}

T enumFromString<T>(List<T> values, dynamic json, {T orElse}) => json != null
    ? values.firstWhere(
        (it) =>
            '$it'.split(".")[1].toString().toLowerCase() ==
            json.toString().toLowerCase(),
        orElse: () => orElse)
    : orElse;

String enumToString<T>(T value) =>
    value != null ? value.toString().split('\.')[1] : null;

bool isNotEmptyOrNull(String value) => !isEmptyOrNull(value);

bool isEmptyOrNull(String value) {
  return value == null || value.isEmpty;
}

dynamic emptyFirestoreValue() => FieldValue.delete();

DateTime dateTimeFromTimestamp(Timestamp timestamp) =>
    (timestamp ?? Timestamp.now()).toDate();
DateTime dateTimeFromTimestampOrNull(Timestamp timestamp) {
  if (timestamp == null) return null;
  return (timestamp ?? Timestamp.now()).toDate();
}

Timestamp timestampFromDateTime(DateTime dateTime) {
  if (dateTime == null) return null;
  return Timestamp.fromDate(dateTime);
}

enum LoadingStatus { successful, loading, failed }
