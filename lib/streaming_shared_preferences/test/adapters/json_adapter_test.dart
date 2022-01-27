// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:streaming_shared_preferences/streaming_shared_preferences.dart';
import 'package:test/test.dart';

class MockSharedPreferences extends Mock implements SharedPreferences {}

void main() {
  group('ValueAdapter tests', () {
    MockSharedPreferences preferences;

    setUp(() {
      preferences = MockSharedPreferences();
    });

    group('JsonAdapter', () {
      test('fails gracefully when getting a null value', () {
        when(preferences.getString('key')).thenReturn(null);

        final adapter = JsonAdapter();
        final json = adapter.getValue(preferences, 'key');

        expect(json, isNull);
      });

      test('decodes a stored JSON value into a Map', () {
        when(preferences.getString('key')).thenReturn('{"hello":"world"}');

        final adapter = JsonAdapter();
        final json = adapter.getValue(preferences, 'key');

        expect(json, {'hello': 'world'});
      });

      test('decodes a stored JSON value into a List', () {
        when(preferences.getString('key')).thenReturn('["hello","world"]');

        final adapter = JsonAdapter();
        final json = adapter.getValue(preferences, 'key');

        expect(json, ['hello', 'world']);
      });

      test('stores an object that implements a toJson() method', () {
        final adapter = JsonAdapter<TestObject>();
        adapter.setValue(preferences, 'key', TestObject('world'));

        verify(preferences.setString('key', '{"hello":"world"}'));
      });

      test('runs decoded json through deserializer when provided', () {
        when(preferences.getString('key')).thenReturn('{"hello":"world"}');

        final adapter = JsonAdapter<TestObject>(
          deserializer: (v) => TestObject.fromJson(v),
        );

        final testObject = adapter.getValue(preferences, 'key');
        expect(testObject.hello, 'world');
      });

      test('runs object through serializer when provided', () {
        final adapter = JsonAdapter<TestObject>(
          serializer: (v) => {'encoded': 'value'},
        );

        // What value we set here doesn't matter - we're testing that it's replaced
        // by the value returned by serializer.
        adapter.setValue(preferences, 'key', null);
        verify(preferences.setString('key', '{"encoded":"value"}'));
      });
    });
  });
}

class TestObject {
  TestObject(this.hello);
  final String hello;

  TestObject.fromJson(Map<String, dynamic> json) : hello = json['hello'];

  Map<String, dynamic> toJson() {
    return {
      'hello': 'world',
    };
  }
}
