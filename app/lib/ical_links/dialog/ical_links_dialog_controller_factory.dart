import 'package:common_domain_models/common_domain_models.dart';
import 'package:sharezone/ical_links/dialog/ical_links_dialog_controller.dart';
import 'package:sharezone/ical_links/shared/ical_link_analytics.dart';
import 'package:sharezone/ical_links/shared/ical_links_gateway.dart';

class ICalLinksDialogControllerFactory {
  final ICalLinksGateway gateway;
  final ICalLinksAnalytics analytics;
  final UserId userId;

  const ICalLinksDialogControllerFactory({
    required this.gateway,
    required this.analytics,
    required this.userId,
  });

  ICalLinksDialogController create() {
    return ICalLinksDialogController(
      gateway: gateway,
      analytics: analytics,
      userId: userId,
    );
  }
}
