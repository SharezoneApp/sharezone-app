import 'package:bloc_base/bloc_base.dart';
import 'package:sharezone/util/api/courseGateway.dart';
import 'package:sharezone/util/api/schoolClassGateway.dart';
import 'package:sharezone/util/api/timetableGateway.dart';

import 'calendrical_events_page_bloc.dart';

class CalendricalEventsPageBlocFactory extends BlocBase {
  final TimetableGateway _timetableGateway;
  final CourseGateway _courseGateway;
  final SchoolClassGateway _schoolClassGateway;

  CalendricalEventsPageBlocFactory(
      this._timetableGateway, this._courseGateway, this._schoolClassGateway);

  CalendricalEventsPageBloc create() {
    return CalendricalEventsPageBloc(
        _timetableGateway, _courseGateway, _schoolClassGateway);
  }

  @override
  void dispose() {}
}
