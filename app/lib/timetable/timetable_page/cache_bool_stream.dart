import 'package:bloc_base/bloc_base.dart';
import 'package:rxdart/subjects.dart';
import 'package:streaming_shared_preferences/streaming_shared_preferences.dart';

class CacheBoolStream extends BlocBase {
  final String cachedBoolKey;
  final _stream = BehaviorSubject.seeded(false);
  Stream<bool> get boolExistsAndIsTrue => _stream.distinct();

  CacheBoolStream(this.cachedBoolKey) {
    init();
  }

  Future<void> init() async {
    final prefs = await StreamingSharedPreferences.instance;
    final result = prefs.getBool(cachedBoolKey, defaultValue: true);
    result.listen(print);
    result.listen((data) => _stream.add(data));
  }

  @override
  void dispose() {
    _stream.close();
  }
}
