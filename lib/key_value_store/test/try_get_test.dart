import 'package:key_value_store/in_memory_key_value_store.dart';
import 'package:test/test.dart';

void main() {
  group('tryGet', () {
    test('Int works', () {
      expect(
          InMemoryKeyValueStore({'foo': 'Not an int'}).tryGetInt('foo'), null);
    });
  });
}
