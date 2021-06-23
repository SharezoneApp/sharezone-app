import 'package:common_domain_models/common_domain_models.dart';
import 'package:key_value_store/key_value_store.dart';
import 'package:meta/meta.dart';
import '../data_source/homework_data_source.dart';
import '../homework_completion/homework_completion_dispatcher.dart';

class HausaufgabenheftDependencies {
  /// Used to load open and completed homeworks
  final HomeworkDataSource dataSource;

  /// Used change the completion status of a homework
  final HomeworkCompletionDispatcher completionDispatcher;

  /// Used to complete all overdue homeworks at once by using the completion
  /// dispatcher.
  final Future<List<HomeworkId>> Function() getOpenOverdueHomeworkIds;

  final KeyValueStore keyValueStore;

  final DateTime Function() getCurrentDateTime;

  HausaufgabenheftDependencies({
    @required this.dataSource,
    @required this.completionDispatcher,
    @required this.getOpenOverdueHomeworkIds,
    @required this.keyValueStore,
    this.getCurrentDateTime,
  });
}
