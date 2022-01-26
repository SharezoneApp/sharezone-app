// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:streaming_shared_preferences/streaming_shared_preferences.dart';

class MockSharedPreferences extends Mock implements SharedPreferences {}

/// These tests make sure that that an identical Preference doesn't accidentally
/// cause refetching an unchanged value from persistent storage when using a
/// StreamBuilder widget and when the state of the parent widget is rebuilt.
///
/// Whenever the parent of a StreamBuilder widget is rebuilt, it causes the StreamBuilder
/// widget to check if the previous Stream and the new Stream are equal. If they
/// are not, StreamBuilder will unsubscribe from the previous Stream and subscribe
/// to a new one.
///
/// The problem is that if a Preference does not implement equals and hashCode, a
/// seemingly equal Preference will be considered as a completely new one by the
/// StreamBuilder widget. And since a Preference will fetch the latest value from
/// persistent storage once every time it's listened to, and a StreamBuilder will
/// always unsubscribe and listen on not equal Streams, every rebuild of the parent
/// widget would result in fetching a value from persistent storage. And that's not
/// good.
void main() {
  group('StreamBuilder and equality tests', () {
    MockSharedPreferences preferences;
    StreamController<String> keyChanges;

    setUp(() {
      preferences = MockSharedPreferences();
      keyChanges = StreamController<String>();
    });

    test('preferences with the same key and type are equal', () {
      expect(
        TestPreference('test', preferences, keyChanges),
        TestPreference('test', preferences, keyChanges),
      );
    });

    test('preferences with same key but different type are not equal', () {
      final first = Preference<String>.$$_private(
        preferences,
        'test',
        'default value',
        StringAdapter.instance,
        keyChanges,
      );

      final second = Preference<int>.$$_private(
        preferences,
        'test',
        0,
        IntAdapter.instance,
        keyChanges,
      );

      expect(first, isNot(equals(second)));
    });

    testWidgets(
        'should listen to the same preference only once even across rebuilds',
        (tester) async {
      await tester.pumpWidget(
        StatefulBuilder(
          builder: (_, stateSetter) {
            return StreamBuilder(
              stream: TestPreference('test', preferences, keyChanges),
              builder: (_, snapshot) {
                return GestureDetector(
                  onTap: () => stateSetter(() {}),
                  child: Text('X', textDirection: TextDirection.ltr),
                );
              },
            );
          },
        ),
      );

      await tester.tap(find.text('X'));
      await tester.pump();

      await tester.tap(find.text('X'));
      await tester.pump();

      await tester.tap(find.text('X'));
      await tester.pump();

      verify(preferences.getString('test')).called(1);
    });
  });
}

class TestPreference extends Preference<String> {
  // ignore: non_constant_identifier_names
  TestPreference(
    String key,
    SharedPreferences preferences,
    StreamController<String> keyChanges,
  ) : super.$$_private(
          preferences,
          key,
          'default value',
          StringAdapter.instance,
          keyChanges,
        );
}
