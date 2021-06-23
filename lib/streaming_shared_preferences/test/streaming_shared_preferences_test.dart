import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart' show TestWidgetsFlutterBinding;
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:streaming_shared_preferences/streaming_shared_preferences.dart';
import 'package:test/test.dart';

class MockSharedPreferences extends Mock implements SharedPreferences {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  group('StreamingKeyValueStore', () {
    MockSharedPreferences delegate;
    StreamingSharedPreferences preferences;

    setUpAll(() async {
      // SharedPreferences calls "getAll" through a method channel initially when
      // creating an instance of it.
      //
      // This will crash in tests by default, so this is a minimal glue code to
      // make sure that we can run the test below without crashes.
      const channel = MethodChannel('plugins.flutter.io/shared_preferences');
      channel.setMockMethodCallHandler((call) async {
        return call.method == 'getAll' ? {} : null;
      });

      // [debugObtainSharedPreferencesInstance] should be non-null and return
      // a [Future] that completes with an instance of SharedPreferences.
      //
      // Otherwise tests might run just fine, but we can't be sure that the
      // instance obtainer is not broken in production.
      final instance = await debugObtainSharedPreferencesInstance;
      expect(debugObtainSharedPreferencesInstance, isNotNull);
      expect(instance, const TypeMatcher<SharedPreferences>());
    });

    setUp(() async {
      delegate = MockSharedPreferences();

      // Swap the instance obtainer with one that always returns a mocked version
      // of shared preferences.
      debugObtainSharedPreferencesInstance = Future.value(delegate);
      preferences = await StreamingSharedPreferences.instance;
    });

    tearDown(() {
      debugResetStreamingSharedPreferencesInstance();
    });

    test('obtaining instance calls delegate only once', () async {
      var obtainCount = 0;

      // Need to reset the instance as the singleton was already obtained in
      // the [setUp] method in tests.
      debugResetStreamingSharedPreferencesInstance();

      // Swap the instance obtainer to a spying one that increases the counter
      // whenever it's called.
      debugObtainSharedPreferencesInstance = Future(() {
        obtainCount++;
        return MockSharedPreferences();
      });

      await StreamingSharedPreferences.instance;
      await StreamingSharedPreferences.instance;
      await StreamingSharedPreferences.instance;

      expect(obtainCount, 1);
    });

    test('forwards all method invocations and parameters to the delegate',
        () async {
      preferences.getKeys().listen(null);
      preferences.getBool('boolKey', defaultValue: false).listen(null);
      preferences.getInt('intKey', defaultValue: 0).listen(null);
      preferences.getDouble('doubleKey', defaultValue: 0).listen(null);
      preferences.getString('stringKey', defaultValue: '').listen(null);
      preferences.getStringList('stringListKey', defaultValue: []).listen(null);

      preferences.setBool('boolKey', true);
      preferences.setInt('intKey', 1337);
      preferences.setDouble('doubleKey', 13.37);
      preferences.setString('stringKey', 'stringValue');
      preferences.setStringList('stringListKey', ['stringListValue']);

      preferences.remove('removeKey');

      // Calling clear() calls delegate.getKeys() - so we must return a non-null
      // value here.
      when(delegate.getKeys()).thenReturn(Set());
      preferences.clear();

      verifyInOrder([
        // Getters
        delegate.getKeys(),
        delegate.getBool('boolKey'),
        delegate.getInt('intKey'),
        delegate.getDouble('doubleKey'),
        delegate.getString('stringKey'),
        delegate.getStringList('stringListKey'),

        // Setters
        delegate.setBool('boolKey', true),
        delegate.setInt('intKey', 1337),
        delegate.setDouble('doubleKey', 13.37),
        delegate.setString('stringKey', 'stringValue'),
        delegate.setStringList('stringListKey', ['stringListValue']),

        // Other
        delegate.remove('removeKey'),

        // Calling clear() should first get the keys and then call clear() on
        // the delegate. calling getKeys() after clear() returns an empty set
        // of keys, so it would not notify about the deleted keys properly.
        delegate.getKeys(),
        delegate.clear(),
      ]);

      verifyNoMoreInteractions(delegate);
    });

    test('settable values should be... settable', () {
      // These invocations make sure that a ".setValue(..)" method exists and is
      // accessible for all these getters. If the test doesn't crash, it's considered
      // a passing test.
      preferences.getBool('key', defaultValue: false).setValue(true);
      preferences.getInt('key', defaultValue: 0).setValue(1);
      preferences.getDouble('key', defaultValue: 0).setValue(1);
      preferences.getString('key', defaultValue: '').setValue('');
      preferences.getStringList('key', defaultValue: []).setValue(['a']);

      // Casting "getKeys()" to dynamic and trying to call ".setValue(..)" on it should
      // throw an error.
      expect(
        () => (preferences.getKeys() as dynamic).setValue(null),
        throwsA(const TypeMatcher<Error>()),
      );
    });

    group('getKeys() tests', () {
      test('getKeys() - can listen to multiple times', () {
        when(delegate.getKeys()).thenReturn(Set.from(['first', 'second']));
        final stream = preferences.getKeys();

        // If this doesn't crash the test, the test is considered a passing test.
        stream.listen((_) {});
        stream.listen((_) {});
        stream.listen((_) {});
      });

      test('when keys are null or empty, emits an empty set', () async {
        when(delegate.getKeys()).thenReturn(null);
        await expectLater(preferences.getKeys(), emits(Set()));

        when(delegate.getKeys()).thenReturn(Set());
        expect(preferences.getKeys(), emits(Set()));
      });

      test('initial values', () {
        when(delegate.getKeys()).thenReturn(Set.from(['first', 'second']));
        expect(preferences.getKeys(), emits(Set.from(['first', 'second'])));
      });

      test('getKeys().getValue() - initial values', () {
        when(delegate.getKeys()).thenReturn(Set.from(['first', 'second']));
        expect(preferences.getKeys(), emits(Set.from(['first', 'second'])));
      });

      test('setting a value emits latest keys in the stream', () async {
        final keys = preferences.getKeys();
        var count = 0;

        /// This might seem wonky, but it is actually testing the relevant use
        /// case. Every time a "setXYZ()" is called, we should fetch keys using
        /// delegate.getKey() and then emit them. Although what delegate.getKeys()
        /// returns doesn't matter in a test case, we're returning what would be
        /// returned in a real scenario so that it's easier to follow.
        // ignore:missing_return
        when(delegate.getKeys()).thenAnswer((_) {
          count++;

          switch (count) {
            case 1:
              return Set.from(['key1']);
            case 2:
              return Set.from(['key1', 'key2']);
            case 3:
              return Set.from(['key1', 'key2', 'key3']);
            case 4:
              return Set.from(['key1', 'key2', 'key3', 'key4']);
            case 5:
              return Set.from(['key1', 'key2', 'key3', 'key4', 'key5']);
            case 6:
              return Set.from(['key1', 'key2', 'key3', 'key4', 'key5', 'key6']);
          }
        });

        preferences.setBool('key1', true);
        preferences.setInt('key2', 2);
        preferences.setDouble('key3', 3.0);
        preferences.setString('key4', 'value4');
        preferences.setStringList('key5', ['value5']);
        preferences.setCustomValue('key6', '', adapter: StringAdapter.instance);

        expect(
          keys,
          emitsInOrder([
            // setting a bool
            Set.from(['key1']),

            // setting an int
            Set.from(['key1', 'key2']),

            // setting a double
            Set.from(['key1', 'key2', 'key3']),

            // setting a String
            Set.from(['key1', 'key2', 'key3', 'key4']),

            // setting a String list
            Set.from(['key1', 'key2', 'key3', 'key4', 'key5']),

            // setting a custom value
            Set.from(['key1', 'key2', 'key3', 'key4', 'key5', 'key6']),
          ]),
        );
      });

      test(
        'calling .getValue() has a different result after setting values',
        () async {
          final keys = preferences.getKeys();
          var count = 0;

          /// This might seem wonky, but it is actually testing the relevant use
          /// case. Every time a "setXYZ()" is called, we should fetch keys using
          /// delegate.getKey() and then emit them. Although what delegate.getKeys()
          /// returns doesn't matter in a test case, we're returning what would be
          /// returned in a real scenario so that it's easier to follow.
          // ignore:missing_return
          when(delegate.getKeys()).thenAnswer((_) {
            count++;

            switch (count) {
              case 1:
                return Set.from(['key1']);
              case 2:
                return Set.from(['key1', 'key2']);
              case 3:
                return Set.from(['key1', 'key2', 'key3']);
              case 4:
                return Set.from(['key1', 'key2', 'key3', 'key4']);
              case 5:
                return Set.from(['key1', 'key2', 'key3', 'key4', 'key5']);
            }
          });

          preferences.setBool('key1', true);
          expect(keys.getValue(), Set.from(['key1']));

          preferences.setInt('key2', 2);
          expect(keys.getValue(), Set.from(['key1', 'key2']));

          preferences.setDouble('key3', 3.0);
          expect(keys.getValue(), Set.from(['key1', 'key2', 'key3']));

          preferences.setString('key4', 'value4');
          expect(keys.getValue(), Set.from(['key1', 'key2', 'key3', 'key4']));

          preferences.setStringList('key5', ['value5']);
          expect(
            keys.getValue(),
            Set.from(['key1', 'key2', 'key3', 'key4', 'key5']),
          );
        },
      );

      test('trying to call setValue() on getKeys() throws an error', () {
        expect(
          () => preferences.getKeys().setValue(Set()),
          throwsA(const TypeMatcher<UnsupportedError>()),
        );
      });
    });

    group('boolean tests', () {
      setUp(() {
        when(delegate.getBool('myTrueBool')).thenReturn(true);
        when(delegate.getBool('myFalseBool')).thenReturn(false);
        when(delegate.getBool('myNullBool')).thenReturn(null);
      });

      test('getBool() - can listen to multiple times', () {
        final stream = preferences.getBool('myTrueBool', defaultValue: false);

        // If this doesn't crash the test, the test is considered a passing test.
        stream.listen((_) {});
        stream.listen((_) {});
        stream.listen((_) {});
      });

      test('getBool().stream() - initial values', () {
        expect(
          preferences.getBool('myTrueBool', defaultValue: false),
          emits(true),
        );

        expect(
          preferences.getBool('myFalseBool', defaultValue: true),
          emits(false),
        );

        expect(
          preferences.getBool('myNullBool', defaultValue: true),
          emits(true),
        );

        expect(
          preferences.getBool('myNullBool', defaultValue: false),
          emits(false),
        );
      });

      test('getBool().getValue() - initial values', () {
        expect(
          preferences.getBool('myTrueBool', defaultValue: false).getValue(),
          true,
        );

        expect(
          preferences.getBool('myFalseBool', defaultValue: true).getValue(),
          false,
        );

        expect(
          preferences.getBool('myNullBool', defaultValue: true).getValue(),
          true,
        );

        expect(
          preferences.getBool('myNullBool', defaultValue: false).getValue(),
          false,
        );
      });

      test('getBool().getValue()', () async {
        final storedBool = preferences.getBool('key1', defaultValue: false);
        expect(storedBool.getValue(), isFalse);

        when(delegate.getBool('key1')).thenReturn(true);
        expect(storedBool.getValue(), isTrue);

        when(delegate.getBool('key1')).thenReturn(false);
        expect(
          preferences.getBool('key1', defaultValue: true).getValue(),
          isFalse,
        );

        when(delegate.getBool('key1')).thenReturn(null);
        expect(
          preferences.getBool('key1', defaultValue: true).getValue(),
          isTrue,
        );

        expect(
          preferences.getBool('key1', defaultValue: false).getValue(),
          isFalse,
        );
      });

      test('setBool emits an update in getBool', () async {
        final storedBool = preferences.getBool('key1', defaultValue: false);

        scheduleMicrotask(() {
          when(delegate.getBool('key1')).thenReturn(true);

          // Setting value to null won't matter here as the delegate is just a mock.
          // What we're interested instead is triggering an update in the changed
          // keys stream.
          preferences.setBool('key1', null);
        });

        await expectLater(storedBool, emitsInOrder([false, true]));
      });
    });

    group('int tests', () {
      setUp(() {
        when(delegate.getInt('myInt')).thenReturn(1337);
        when(delegate.getInt('myNullInt')).thenReturn(null);
      });

      test('getInt() - can listen to multiple times', () {
        final stream = preferences.getInt('myInt', defaultValue: 0);

        // If this doesn't crash the test, the test is considered a passing test.
        stream.listen((_) {});
        stream.listen((_) {});
        stream.listen((_) {});
      });

      test('getInt() - initial values', () {
        expect(preferences.getInt('myInt', defaultValue: 0), emits(1337));
        expect(preferences.getInt('myNullInt', defaultValue: 0), emits(0));
        expect(
          preferences.getInt('myNullInt', defaultValue: 1337),
          emits(1337),
        );
      });

      test('getInt().getValue() - initial values', () {
        expect(preferences.getInt('myInt', defaultValue: 0).getValue(), 1337);
        expect(
          preferences.getInt('myNullInt', defaultValue: 1337).getValue(),
          1337,
        );
      });

      test('getInt().getValue()', () async {
        final storedInt = preferences.getInt('key1', defaultValue: 0);
        expect(storedInt.getValue(), 0);

        when(delegate.getInt('key1')).thenReturn(1);
        expect(storedInt.getValue(), 1);

        when(delegate.getInt('key1')).thenReturn(2);
        expect(preferences.getInt('key1', defaultValue: 0).getValue(), 2);

        when(delegate.getInt('key1')).thenReturn(null);
        expect(
          preferences.getInt('key1', defaultValue: 1).getValue(),
          1,
        );
      });

      test('setInt emits an update in getInt', () async {
        final storedInt = preferences.getInt('key1', defaultValue: 1);

        scheduleMicrotask(() {
          when(delegate.getInt('key1')).thenReturn(2);

          // Setting value to null won't matter here as the delegate is just a mock.
          // What we're interested instead is triggering an update in the changed
          // keys stream.
          preferences.setInt('key1', null);
        });

        await expectLater(storedInt, emitsInOrder([1, 2]));
      });
    });

    group('double tests', () {
      setUp(() {
        when(delegate.getDouble('myDouble')).thenReturn(13.37);
        when(delegate.getDouble('myNullDouble')).thenReturn(null);
      });

      test('getDouble() - can listen to multiple times', () {
        final stream = preferences.getDouble('myDouble', defaultValue: 0);

        // If this doesn't crash the test, the test is considered a passing test.
        stream.listen((_) {});
        stream.listen((_) {});
        stream.listen((_) {});
      });

      test('getDouble() - initial values', () {
        expect(
          preferences.getDouble('myDouble', defaultValue: 0),
          emits(13.37),
        );

        expect(
          preferences.getDouble('myNullDouble', defaultValue: 13.37),
          emits(13.37),
        );
      });

      test('getDouble().getValue() - initial values', () {
        expect(
          preferences.getDouble('myDouble', defaultValue: 0).getValue(),
          13.37,
        );

        expect(
          preferences.getDouble('myNullDouble', defaultValue: 13.37).getValue(),
          13.37,
        );
      });

      test('getDouble().getValue()', () async {
        final storedDouble = preferences.getDouble('key1', defaultValue: 0);
        expect(storedDouble.getValue(), 0);

        when(delegate.getDouble('key1')).thenReturn(1.1);
        expect(storedDouble.getValue(), 1.1);

        when(delegate.getDouble('key1')).thenReturn(2.2);
        expect(preferences.getDouble('key1', defaultValue: 0).getValue(), 2.2);

        when(delegate.getDouble('key1')).thenReturn(null);
        expect(
          preferences.getDouble('key1', defaultValue: 1.1).getValue(),
          1.1,
        );
      });

      test('setDouble emits an update in getDouble', () async {
        final storedDouble = preferences.getDouble('key1', defaultValue: 1.1);

        scheduleMicrotask(() {
          when(delegate.getDouble('key1')).thenReturn(2.2);

          // Setting value to null won't matter here as the delegate is just a mock.
          // What we're interested instead is triggering an update in the changed
          // keys stream.
          preferences.setDouble('key1', null);
        });

        expect(storedDouble, emitsInOrder([1.1, 2.2]));
      });
    });

    group('String tests', () {
      setUp(() {
        when(delegate.getString('myString')).thenReturn('myValue');
        when(delegate.getString('myNullString')).thenReturn(null);
      });

      test('getString() - can listen to multiple times', () {
        final stream = preferences.getString('myString', defaultValue: '');

        // If this doesn't crash the test, the test is considered a passing test.
        stream.listen((_) {});
        stream.listen((_) {});
        stream.listen((_) {});
      });

      test('getString() - initial values', () {
        expect(
          preferences.getString('myString', defaultValue: ''),
          emits('myValue'),
        );

        expect(
          preferences.getString('null-defValue', defaultValue: 'defaultValue'),
          emits('defaultValue'),
        );
      });

      test('getString().getValue() - initial values', () {
        expect(
          preferences.getString('myString', defaultValue: '').getValue(),
          'myValue',
        );

        expect(
          preferences
              .getString('null-defValue', defaultValue: 'defaultValue')
              .getValue(),
          'defaultValue',
        );
      });

      test('getString().getValue()', () async {
        final storedString = preferences.getString('key1', defaultValue: '');
        expect(storedString.getValue(), isEmpty);

        when(delegate.getString('key1')).thenReturn('value 1');
        expect(storedString.getValue(), 'value 1');

        when(delegate.getString('key1')).thenReturn('value 2');
        expect(
          preferences.getString('key1', defaultValue: '').getValue(),
          'value 2',
        );

        when(delegate.getString('key1')).thenReturn(null);
        expect(
          preferences
              .getString('key1', defaultValue: 'defaultValue')
              .getValue(),
          'defaultValue',
        );
      });

      test('setString emits an update in getString Stream', () async {
        final storedString =
            preferences.getString('key1', defaultValue: 'defaultValue');

        scheduleMicrotask(() {
          when(delegate.getString('key1')).thenReturn('updated string');

          // Setting value to null won't matter here as the delegate is just a mock.
          // What we're interested instead is triggering an update in the changed
          // keys stream.
          preferences.setString('key1', null);
        });

        await expectLater(
          storedString,
          emitsInOrder(['defaultValue', 'updated string']),
        );
      });
    });

    group('String list tests', () {
      setUp(() {
        when(delegate.getStringList('myStringList')).thenReturn(['a', 'b']);
        when(delegate.getStringList('myNullStringList')).thenReturn(null);
        when(delegate.getStringList('myEmptyStringList')).thenReturn([]);
      });

      test('getStringList() - can listen to multiple times', () {
        final stream = preferences.getStringList(
          'myStringList',
          defaultValue: [],
        );

        // If this doesn't crash the test, the test is considered a passing test.
        stream.listen((_) {});
        stream.listen((_) {});
        stream.listen((_) {});
      });

      test('getStringList() - initial values', () {
        expect(
          preferences.getStringList('myStringList', defaultValue: []),
          emits(['a', 'b']),
        );

        expect(
          preferences.getStringList(
            'myEmptyStringList',
            defaultValue: ['nonempty'],
          ),
          emits([]),
        );

        expect(
          preferences.getStringList(
            'myNullStringList',
            defaultValue: ['default', 'value'],
          ),
          emits(['default', 'value']),
        );
      });

      test('getStringList().getValue() - initial values', () {
        expect(
          preferences.getStringList(
            'myStringList',
            defaultValue: [],
          ).getValue(),
          ['a', 'b'],
        );

        expect(
          preferences.getStringList(
            'null-defValue',
            defaultValue: ['default', 'value'],
          ).getValue(),
          ['default', 'value'],
        );
      });

      test('getStringList().getValue()', () async {
        final storedStringList = preferences.getStringList(
          'key1',
          defaultValue: [],
        );

        expect(storedStringList.getValue(), isEmpty);

        when(delegate.getStringList('key1')).thenReturn(['a', 'a']);
        expect(storedStringList.getValue(), ['a', 'a']);

        when(delegate.getStringList('key1')).thenReturn(['b', 'b']);
        expect(
          preferences.getStringList('key1', defaultValue: []).getValue(),
          ['b', 'b'],
        );

        when(delegate.getStringList('key1')).thenReturn(null);
        expect(
          preferences.getStringList(
            'key1',
            defaultValue: ['default', 'value'],
          ).getValue(),
          ['default', 'value'],
        );
      });

      test('setStringList emits an update in getStringList', () async {
        final storedString = preferences.getStringList(
          'key1',
          defaultValue: ['default', 'value'],
        );

        scheduleMicrotask(() {
          when(delegate.getStringList('key1')).thenReturn(['updated', 'value']);

          // Setting value to null won't matter here as the delegate is just a mock.
          // What we're interested instead is triggering an update in the changed
          // keys stream.
          preferences.setStringList('key1', null);
        });

        await expectLater(
          storedString,
          emitsInOrder([
            ['default', 'value'],
            ['updated', 'value'],
          ]),
        );
      });
    });

    test('removing a key triggers an update in value stream', () {
      when(delegate.getString('myString')).thenReturn('initial value');
      final stringValue = preferences.getString('myString', defaultValue: '');

      scheduleMicrotask(() {
        // We're  only testing that the removal triggers an update in the key stream.
        // While this "when" call here could return anything, we're returning null
        // because that's what would happen in a real scenario.
        when(delegate.getString('myString')).thenReturn(null);
        preferences.remove('myString');
      });

      expect(stringValue, emitsInOrder(['initial value', '']));
    });

    test('clear() triggers update on all existing keys', () {
      when(delegate.getKeys()).thenReturn(Set.from(['key1', 'key2', 'key3']));
      when(delegate.getString(any)).thenReturn('value');

      final value1 = preferences.getString('key1', defaultValue: '');
      final value2 = preferences.getString('key2', defaultValue: '');
      final value3 = preferences.getString('key3', defaultValue: '');

      scheduleMicrotask(() {
        // We're  only testing that calling clear() triggers an update in the key
        // stream for all of the existing keys.
        //
        // While this "when" call here could return anything, we're returning null
        // because that's what would happen in a real scenario.
        when(delegate.getString(any)).thenReturn(null);
        preferences.clear();
      });

      expect(value1, emitsInOrder(['value', '']));
      expect(value2, emitsInOrder(['value', '']));
      expect(value3, emitsInOrder(['value', '']));
    });

    test('setters throw assertion error when key is null', () {
      final assertionError = throwsA(const TypeMatcher<AssertionError>());

      expect(() => preferences.setBool(null, true), assertionError);
      expect(() => preferences.setInt(null, 0), assertionError);
      expect(() => preferences.setDouble(null, 0), assertionError);
      expect(() => preferences.setString(null, ''), assertionError);
      expect(
        () => preferences.setStringList(null, []),
        assertionError,
      );
    });

    test('throws assertion error for null preference adapter', () {
      final assertionError = throwsA(const TypeMatcher<AssertionError>());
      expect(
        () => preferences.getCustomValue('', defaultValue: '', adapter: null),
        assertionError,
      );

      expect(
        () => preferences.setCustomValue<String>('', '', adapter: null),
        assertionError,
      );
    });

    test('getters throw assertion error when key is null', () {
      final assertionError = throwsA(const TypeMatcher<AssertionError>());

      expect(
        () => preferences.getBool(null, defaultValue: true),
        assertionError,
      );

      expect(() => preferences.getInt(null, defaultValue: 0), assertionError);
      expect(
        () => preferences.getDouble(null, defaultValue: 0),
        assertionError,
      );

      expect(
        () => preferences.getString(null, defaultValue: ''),
        assertionError,
      );

      expect(
        () => preferences.getStringList(null, defaultValue: []),
        assertionError,
      );
    });

    test('getters throw assertion error when default value is null', () {
      final assertionError = throwsA(const TypeMatcher<AssertionError>());

      expect(
        () => preferences.getBool('k', defaultValue: null),
        assertionError,
      );

      expect(() => preferences.getInt('k', defaultValue: null), assertionError);
      expect(
        () => preferences.getDouble('', defaultValue: null),
        assertionError,
      );

      expect(
        () => preferences.getString('k', defaultValue: null),
        assertionError,
      );

      expect(
        () => preferences.getStringList('', defaultValue: null),
        assertionError,
      );
    });
  });
}
