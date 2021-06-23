import 'package:bloc_base/bloc_base.dart';
import 'package:common_domain_models/common_domain_models.dart';
import 'package:crash_analytics/crash_analytics.dart';
import 'package:flutter/services.dart';
import 'package:meta/meta.dart';
import 'package:optional/optional.dart';
import 'package:purchases_flutter/errors.dart';
import 'package:sharezone/donate/analytics/donation_analytics.dart';
import 'package:sharezone/donate/donation_service/donation_item.dart';
import 'package:sharezone/donate/donation_service/donation_service.dart';
import 'package:sharezone/donate/page/donation_item_view.dart';
import 'package:sharezone_utils/platform.dart';
import '../donation_service/src/should_be_reported_extension.dart';

class DonationBloc extends BlocBase {
  final UserId userId;
  final DonationService donationService;
  final DonationAnalytics analytics;

  DonationBloc({
    @required this.userId,
    @required this.donationService,
    @required this.analytics,
  });

  Future<List<DonationItemView>> getProductViews() async {
    final items = await donationService.loadDonationItems();
    items.sortById();
    return items.toViews();
  }

  Future<void> spende(DonationItemId id) async {
    try {
      await donationService.purchase(id);
    } on PlatformException catch (e, s) {
      final purchaseError = PurchasesErrorHelper.getErrorCode(e);
      if (purchaseError != PurchasesErrorCode.purchaseCancelledError) {
        if (purchaseError.shouldErrorBeReported()) {
          getCrashAnalytics().recordError(purchaseError, s);
        }
      }

      rethrow;
    }
  }

  void logDonationPageOpened() {
    analytics.logDonationPageOpened(getPlatform());
  }

  // Donations sind aktuell noch nich für macOS verfügbar. Trotzdem soll
  // getrackt werden, wie viele Nutzer über macOS gespendet hätten.
  void logPressedDonationButtonOnMacOs() {
    analytics.logPressedDonationButtonOnMacOs();
  }

  @override
  void dispose() {}
}

extension on List<DonationItem> {
  List<DonationItemView> toViews() {
    return map((p) => p.toView()).toList();
  }

  void sortById() {
    sort((a, b) => a.id.id.compareTo(b.id.id));
  }
}

extension on DonationItem {
  DonationItemView toView() {
    return DonationItemView(
      id: id,
      iconPath: Optional.ofNullable(_getIconPath()),
      title: title,
      price: formattedPrice,
    );
  }

  String _getIconPath() {
    const basepath = 'assets/icons';
    if (title.contains('Schokoriegel')) {
      return '$basepath/chocolate.svg';
    } else if (title.contains('Pausenbrot')) {
      return '$basepath/sandwich.svg';
    } else if (title.contains('Mittagessen')) {
      return '$basepath/pizza.svg';
    } else if (title.contains('Neue Hefter')) {
      return '$basepath/book.svg';
    } else if (title.contains('Neuer Schulranzen')) {
      return '$basepath/backpack.svg';
    }
    return null;
  }
}
