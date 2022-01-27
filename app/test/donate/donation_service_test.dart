// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:purchases_flutter/discount.dart';
import 'package:purchases_flutter/product_wrapper.dart';
import 'package:random_string/random_string.dart';
import 'package:sharezone/donate/donation_service/donation_service.dart';
import 'package:sharezone/donate/donation_service/src/purchase_service.dart';
import 'package:sharezone/donate/donation_service/src/sharezone_donation_backend.dart';
import 'package:test/test.dart';

import 'mock_donate_analytics.dart';

void main() {
  group('DonationService', () {
    DonationService donationService;
    MockPurchasingService purchasingService;
    MockDonateAnalytics donateAnalytics;
    MockSharezoneDonationBackend sharezoneDonationBackend;

    setUp(() {
      purchasingService = MockPurchasingService();
      donateAnalytics = MockDonateAnalytics();
      sharezoneDonationBackend = MockSharezoneDonationBackend();

      donationService = DonationService.internal(
        sharezoneDonationBackend: sharezoneDonationBackend,
        donateAnalytics: donateAnalytics,
        purchaseService: purchasingService,
      );
    });

    TestProduct _productWith({String id, String title}) {
      return TestProduct(
          identifier: id,
          price: 3,
          currencyCode: 'EUR', // ?
          description: 'Schönes Ding',
          title: title ??
              'Schokoriegel (Schulplaner, Hausaufgaben, Stundenplan: Sharezone)',
          introductoryPrice: null,
          priceString: '3€');
    }

    Future<void> expectTitle(
        {String fromPurchaseTitle, String isFormattedTo}) async {
      var id = randomAlpha(9);
      final productAtOffer = _productWith(id: id, title: fromPurchaseTitle);
      purchasingService.add(productAtOffer);

      final item = await donationService.loadDonationWithId(id);

      expect(item.title, isFormattedTo);
    }

    test('loggt Analytics, wenn gespendet wurde.', () async {
      final productAtOffer = _productWith(id: '1');
      purchasingService.add(productAtOffer);

      await donationService.purchase(DonationItemId('donation_1_play_store'));

      expect(donateAnalytics.donationLogged, true);
    });

    test('formats title form purchase to donation item correctly', () async {
      await expectTitle(
        fromPurchaseTitle:
            'Schokoriegel (Schulplaner, Hausaufgaben, Stundenplan: Sharezone)',
        isFormattedTo: 'Schokoriegel',
      );
      await expectTitle(
        fromPurchaseTitle:
            'Neuer Schulranzen (Schulplaner, Hausaufgaben, Stundenplan: Sharezone)',
        isFormattedTo: 'Neuer Schulranzen',
      );
      await expectTitle(
        fromPurchaseTitle: 'Neuer Schulranzen (Irgendein Title)',
        isFormattedTo: 'Neuer Schulranzen',
      );
      await expectTitle(
        fromPurchaseTitle: 'Neuer Schulranzen',
        isFormattedTo: 'Neuer Schulranzen',
      );
    });
  });
}

class TestProduct implements Product {
  /// Product Id.
  @override
  final String identifier;

  /// Description of the product.
  @override
  final String description;

  /// Title of the product.
  @override
  final String title;

  /// Price of the product in the local currency.
  @override
  final double price;

  /// Formatted price of the item, including its currency sign.
  @override
  final String priceString;

  /// Currency code for price and original price.
  @override
  final String currencyCode;

  /// Introductory price for product. Can be null.
  @override
  final IntroductoryPrice introductoryPrice;

  @override
  final List<Discount> discounts;

  /// For Testing
  bool wasBought = false;

  TestProduct({
    this.identifier,
    this.description,
    this.title,
    this.price,
    this.priceString,
    this.currencyCode,
    this.introductoryPrice,
    this.discounts,
  });
}

class MockPurchasingService extends PurchaseService {
  final _products = <TestProduct>[];

  void add(TestProduct product) {
    _products.add(product);
  }

  @override
  Future<List<Product>> getProducts() async {
    return _products;
  }

  @override
  Future<void> purchase(ProductId id) async {
    getProduct(id).wasBought = true;
  }

  TestProduct getProduct(ProductId id) {
    return _products.singleWhere((p) => p.identifier == '$id');
  }

  bool wasProductBought(String id) {
    return _products.singleWhere((p) => p.identifier == id).wasBought;
  }
}

extension on DonationService {
  Future<DonationItem> loadDonationWithId(String id) async {
    return (await loadDonationItems()).singleWhere((p) => '${p.id}' == id);
  }
}

class MockSharezoneDonationBackend extends SharezoneDonationBackend {
  @override
  Future<void> notifyUserDonated(DonationItemId productId) async {}
}
