import 'package:sharezone/util/cache/streaming_key_value_store.dart';

const dashboardCounterKey = "dashboard-counter";

class DashboardTipCache {
  final StreamingKeyValueStore streamingCache;

  DashboardTipCache(this.streamingCache);

  Future<void> increaseDashboardCounter() async {
    final counter =
        await getDashboardCounter().first;
    streamingCache.setInt(dashboardCounterKey, counter + 1);
  }

  void markTipAsShown(String key) {
    streamingCache.setBool(key, true);
  }

  Stream<int> getDashboardCounter() {
    return streamingCache.getInt(dashboardCounterKey, defaultValue: 0);
  }

  Stream<bool> showedTip(String key) {
    return streamingCache.getBool(key,
        defaultValue: false);
  }
}
