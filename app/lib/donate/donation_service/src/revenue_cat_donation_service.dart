import 'package:purchases_flutter/purchases_flutter.dart';

import 'purchase_service.dart';

class RevenueCatPurchaseService implements PurchaseService {
  @override
  Future<void> purchase(ProductId id) async {
    final offerings = await Purchases.getOfferings();
    final availablePackages =
        offerings.getOffering('default-donate').availablePackages;
    final packageToPurchase = availablePackages
        .singleWhere((package) => package.identifier == id.toString());
    await Purchases.purchasePackage(packageToPurchase);
  }

  @override
  Future<List<Product>> getProducts() async {
    final offerings = await Purchases.getOfferings();

    final availablePackages =
        offerings.getOffering('default-donate').availablePackages;
    final identifiers =
        availablePackages.map((package) => package.product.identifier).toList();

    final products = await Purchases.getProducts(
      identifiers,
      type: PurchaseType.inapp,
    );

    return products;
  }
}
