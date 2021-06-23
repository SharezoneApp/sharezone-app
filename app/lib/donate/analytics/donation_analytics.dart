import 'package:analytics/analytics.dart';
import 'package:meta/meta.dart';
import 'package:sharezone/donate/donation_service/donation_service.dart';
import 'package:sharezone_utils/platform.dart';

class DonationAnalytics {
  final Analytics _analytics;

  DonationAnalytics(this._analytics);

  void logDonation(DonationItemId id) {
    _analytics.log(DonatedEvent(id: id));
  }

  void logDonationPageOpened(Platform platform) {
    _analytics.log(
      AnalyticsEvent(
        'donation_page_opened',
        data: {'platform': platform.toString().toLowerCase()},
      ),
    );
  }

  void logPressedDonationButtonOnMacOs() {
    _analytics.log(NamedAnalyticsEvent(name: 'donation_pressed_button_macos'));
  }
}

class DonatedEvent extends AnalyticsEvent {
  DonatedEvent({
    @required this.id,
  }) : super('donated_$id');

  final DonationItemId id;
}
