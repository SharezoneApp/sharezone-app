import 'events.dart';
import 'states.dart';

abstract class LazyLoadingCompletedHomeworksBloc
    implements
        Stream<LazyLoadingCompletedHomeworksBlocState>,
        Sink<LazyLoadingCompletedHomeworksEvent> {}
