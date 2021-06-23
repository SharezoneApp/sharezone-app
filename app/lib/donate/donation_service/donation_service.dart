import 'package:analytics/analytics.dart';
import 'package:app_functions/app_functions.dart';
import 'package:crash_analytics/crash_analytics.dart';
import 'package:meta/meta.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:sharezone/donate/analytics/donation_analytics.dart';
import 'package:sharezone/donate/donation_service/src/revenue_cat_donation_service.dart';

import 'donation_item.dart';
import 'src/purchase_service.dart';
import 'src/sharezone_donation_backend.dart';

export 'donation_item.dart';

class DonationService {
  final PurchaseService purchaseService;
  final SharezoneDonationBackend sharezoneDonationBackend;
  final DonationAnalytics donateAnalytics;

  factory DonationService({
    @required CrashAnalytics crashAnalytics,
    @required Analytics analytics,
    @required AppFunctions appFunctions,
  }) {
    return DonationService.internal(
      purchaseService: RevenueCatPurchaseService(),
      sharezoneDonationBackend: AppFunctionSharezoneDonationBackend(
        crashAnalytics: crashAnalytics,
        appFunctions: appFunctions,
      ),
      donateAnalytics: DonationAnalytics(analytics),
    );
  }

  @visibleForTesting
  DonationService.internal({
    @required this.purchaseService,
    @required this.sharezoneDonationBackend,
    @required this.donateAnalytics,
  });

  Future<void> purchase(DonationItemId id) async {
    await purchaseService.purchase(ProductId.fromDonationItemId(id));
    await sharezoneDonationBackend.notifyUserDonated(id);
    donateAnalytics.logDonation(id);
  }

  Future<List<DonationItem>> loadDonationItems() async {
    final products = await purchaseService.getProducts();
    return [
      for (final product in products) product.toDonationItem(),
    ];
  }
}

extension on Product {
  DonationItem toDonationItem() {
    return DonationItem(
      id: DonationItemId(identifier),
      title: _getTitle(),
      formattedPrice: priceString,
    );
  }

  /// Der Title, den RevenueCat zurückgibt, enthalt am Ende
  /// den App-Titel aus dem jeweiligen noch. Bei Android wäre
  /// dies z.B. "Schokoriegel (Schulplaner, Hausaufgaben,
  /// Stundenplan: Sharezone)". Diese Methode gibt den Titel
  /// des Produktes ohne den App-Titel zurück.
  String _getTitle() {
    return title.replaceAll(RegExp(r"\(.+?\)$"), "").trim();
  }
}
