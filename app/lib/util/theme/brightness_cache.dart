import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';
import 'package:sharezone/account/theme/theme_brightness.dart';
import 'package:sharezone/util/cache/streaming_key_value_store.dart';

const currentBrightnessCacheKey = 'currentBrightnessCacheKey';
const light = 'light';
const dark = 'dark';
const system = 'system';

class BrightnessCache {
  final StreamingKeyValueStore streamingCache;
  final _brightnessSubject = BehaviorSubject<ThemeBrightness>();
  Stream<ThemeBrightness> get brightness => _brightnessSubject;

  BrightnessCache({@required this.streamingCache}) {
    streamingCache
        .getString(currentBrightnessCacheKey, defaultValue: system)
        .map(_parseBrightness)
        .listen(_brightnessSubject.sink.add);
  }

  Future<bool> setBrightness(ThemeBrightness brightness) async {
    if (brightness != null) {
      final brightnessString = _parseBrightnessString(brightness);
      return streamingCache.setString(
          currentBrightnessCacheKey, brightnessString);
    }
    return false;
  }

  ThemeBrightness _parseBrightness(String brightness) {
    switch (brightness) {
      case dark:
        return ThemeBrightness.dark;
      case light:
        return ThemeBrightness.light;
      case system:
      default:
        return ThemeBrightness.system;
    }
  }

  String _parseBrightnessString(ThemeBrightness brightness) {
    if (brightness != null) {
      switch (brightness) {
        case ThemeBrightness.dark:
          return dark;
        case ThemeBrightness.light:
          return light;
        case ThemeBrightness.system:
        default:
          return system;
      }
    }
    return null;
  }

  void dispose() {
    _brightnessSubject.close();
  }
}
