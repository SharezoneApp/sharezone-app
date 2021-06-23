import 'package:rxdart/rxdart.dart';

extension MergeWithValueExtension<T> on Stream<T> {
  Stream<T> mergeWithValue(T value) => mergeWith([Stream.value(value)]);
  Stream<T> mergeWithValues(List<T> values) =>
      mergeWith([for (final value in values) Stream.value(value)]);
}
