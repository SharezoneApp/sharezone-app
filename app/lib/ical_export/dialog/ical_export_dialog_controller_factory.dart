import 'package:common_domain_models/common_domain_models.dart';
import 'package:sharezone/ical_export/dialog/ical_export_dialog_controller.dart';
import 'package:sharezone/ical_export/shared/ical_export_analytics.dart';
import 'package:sharezone/ical_export/shared/ical_export_gateway.dart';

class ICalExportDialogControllerFactory {
  final ICalExportGateway gateway;
  final ICalExportAnalytics analytics;
  final UserId userId;

  const ICalExportDialogControllerFactory({
    required this.gateway,
    required this.analytics,
    required this.userId,
  });

  ICalExportDialogController create() {
    return ICalExportDialogController(
      gateway: gateway,
      analytics: analytics,
      userId: userId,
    );
  }
}
