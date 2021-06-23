import 'package:hausaufgabenheft_logik/hausaufgabenheft_logik.dart';
import 'package:key_value_store/key_value_store.dart';

class HomeworkSortingCache {
  final KeyValueStore _keyValueStore;

  static const _key = 'last-homework-sorting';

  HomeworkSortingCache(this._keyValueStore);

  Future<void> setLastSorting(HomeworkSort homeworkSort) async {
    return _keyValueStore.setString(_key, homeworkSortToString(homeworkSort));
  }

  Future<HomeworkSort> getLastSorting({HomeworkSort orElse}) async {
    final string = _keyValueStore.getString(_key);
    return string != null ? homeworkSortFromString(string) : orElse;
  }
}
