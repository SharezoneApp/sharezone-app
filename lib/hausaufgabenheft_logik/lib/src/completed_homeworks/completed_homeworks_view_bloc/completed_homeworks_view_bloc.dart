import 'events.dart';
import 'states.dart';

abstract class CompletedHomeworksViewBloc
    implements
        Stream<CompletedHomeworksViewBlocState>,
        Sink<CompletedHomeworksViewBlocEvent> {}
