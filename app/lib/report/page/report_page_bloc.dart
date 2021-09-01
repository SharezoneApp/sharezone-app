import 'package:bloc_base/bloc_base.dart';
import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';
import 'package:sharezone/report/report_factory.dart';
import 'package:sharezone/report/report_item.dart' as ui;
import 'package:sharezone_common/api_errors.dart';
import 'package:sharezone_common/helper_functions.dart';

import '../report.dart';
import '../report_gateway.dart';
import '../report_item.dart';
import '../report_reason.dart';

class ReportPageBloc extends BlocBase {
  final ReportGateway reportGateway;
  final ui.ReportItemReference item;
  final ReportFactory reportFactory;

  ReportPageBloc({
    @required this.reportGateway,
    @required this.item,
    @required this.reportFactory,
  });

  final _reasonSubject = BehaviorSubject<ReportReason>();
  final _descriptionSubject = BehaviorSubject<String>();

  Function(String) get changeDescription => _descriptionSubject.sink.add;
  Function(ReportReason) get changeReason => _reasonSubject.sink.add;

  Stream<String> get description => _descriptionSubject;
  Stream<ReportReason> get reason => _reasonSubject;
  ReportedItemType get reportedItemType => ReportItem(item.path).type;

  bool isSubmitValid() {
    final description = _descriptionSubject.valueOrNull;
    final reason = _reasonSubject.valueOrNull;

    return reason != null && isNotEmptyOrNull(description);
  }

  void send() {
    if (isSubmitValid()) {
      final description = _descriptionSubject.valueOrNull;
      final reason = _reasonSubject.valueOrNull;

      final report = reportFactory.create(
        description,
        reason,
        item,
      );

      reportGateway.sendReport(report);
    } else {
      throw MissingReportInformation();
    }
  }

  bool wasEdited() {
    final description = _descriptionSubject.valueOrNull;
    final reason = _reasonSubject.valueOrNull;

    return isNotEmptyOrNull(description) || reason != null;
  }

  @override
  void dispose() {
    _reasonSubject.close();
    _descriptionSubject.close();
  }
}
