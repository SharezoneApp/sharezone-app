import 'package:bloc_base/bloc_base.dart';
import 'package:sharezone/timetable/timetable_add_event/bloc/timetable_add_event_bloc.dart';
import 'package:sharezone/timetable/timetable_add_event/bloc/timetable_add_event_bloc_dependencies.dart';

class TimetableAddEventBlocFactory implements BlocBase {
  final TimetableAddEventBlocDependencies timetableAddBlocDependencies;

  TimetableAddEventBlocFactory(this.timetableAddBlocDependencies);

  TimetableAddEventBloc create() {
    return TimetableAddEventBloc.fromDependencies(timetableAddBlocDependencies);
  }

  @override
  void dispose() {} // Required by BlocProvider
}
