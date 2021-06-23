import 'package:bloc_base/bloc_base.dart';
import 'package:sharezone/util/cache/streaming_key_value_store.dart';

const _timePickerWithFifeMinutesIntervalKey =
    'time_icker_with_fife_minutes_interval_key';

class TimePickerSettingsCache extends BlocBase {
  final StreamingKeyValueStore streamingCache;

  TimePickerSettingsCache(this.streamingCache);

  void setTimePickerWithFifeMinutesInterval(bool newValue) {
    if (newValue != null) {
      streamingCache.setBool(_timePickerWithFifeMinutesIntervalKey, newValue);
    }
  }

  Stream<bool> isTimePickerWithFifeMinutesIntervalActiveStream() {
    return streamingCache.getBool(_timePickerWithFifeMinutesIntervalKey,
        defaultValue: true);
  }

  @override
  void dispose() {} // Required by BlocProvider
}
