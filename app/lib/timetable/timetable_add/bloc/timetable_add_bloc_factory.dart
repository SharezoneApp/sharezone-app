import 'package:bloc_base/bloc_base.dart';
import 'package:sharezone/timetable/timetable_add/bloc/timetable_add_bloc.dart';
import 'package:sharezone/timetable/timetable_add/bloc/timetable_add_bloc_dependencies.dart';

class TimetableAddBlocFactory implements BlocBase {
  final TimetableAddBlocDependencies timetableAddBlocDependencies;

  TimetableAddBlocFactory(this.timetableAddBlocDependencies);

  TimetableAddBloc create() {
    return TimetableAddBloc.fromDependencies(timetableAddBlocDependencies);
  }

  @override
  void dispose() {} // Required by BlocProvider
}
