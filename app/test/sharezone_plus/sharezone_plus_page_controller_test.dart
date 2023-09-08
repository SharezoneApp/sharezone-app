import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:purchases_flutter/object_wrappers.dart';
import 'package:remote_configuration/remote_configuration.dart';
import 'package:sharezone/sharezone_plus/page/sharezone_plus_page_controller.dart';
import 'package:sharezone/sharezone_plus/sharezone_plus_fallback_price.dart';
import 'package:sharezone/sharezone_plus/subscription_service/purchase_service.dart';
import 'package:sharezone/sharezone_plus/subscription_service/subscription_service.dart';

import 'sharezone_plus_page_controller_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<PurchaseService>(),
  MockSpec<SubscriptionService>(),
  MockSpec<RemoteConfiguration>(),
])
void main() {
  group(SharezonePlusPageController, () {
    late MockPurchaseService purchaseService;
    late MockSubscriptionService subscriptionService;
    // mockRemoteConfiguration is needed when we need to answer with exceptions
    late MockRemoteConfiguration mockRemoteConfiguration;
    // otherwise we use this:
    late StubRemoteConfiguration localRemoteConfiguration;

    setUp(() {
      purchaseService = MockPurchaseService();
      subscriptionService = MockSubscriptionService();
      mockRemoteConfiguration = MockRemoteConfiguration();
      localRemoteConfiguration = StubRemoteConfiguration();
    });

    test('returns price given by purchase service', () async {
      when(purchaseService.getProducts()).thenAnswer((_) async => [
            StoreProduct('sz-plus', 'Sharezone Plus description',
                'Sharezone Plus', 2.99, '2,99€', 'EUR')
          ]);

      final plusPageController = SharezonePlusPageController(
        purchaseService: purchaseService,
        subscriptionService: subscriptionService,
        remoteConfiguration: localRemoteConfiguration,
      );
      // As the price is fetched asynchronously we need to wait a bit.
      await pumpEventQueue();

      expect(plusPageController.price, '2,99€');
    });
    test(
        'returns fallback price from remote config is price cannot be fetched from $PurchaseService',
        () {
      localRemoteConfiguration
          .initialize({'sz_plus_price_with_symbol': '6,32€'});
      when(purchaseService.getProducts())
          .thenThrow(Exception('Couldnt fetch products'));
      // Ensure that the remote config fallback price in this test is not the
      // same as the hardcoded fallback price.
      expect('6,32€', isNot(fallbackSharezonePlusPriceWithCurrencySymbol));

      final plusPageController = SharezonePlusPageController(
        purchaseService: purchaseService,
        subscriptionService: subscriptionService,
        remoteConfiguration: localRemoteConfiguration,
      );

      expect(plusPageController.price, '6,32€');
    });
    test(
        'returns hardcoded fallback price if price cannot be fetched from $PurchaseService or $RemoteConfiguration',
        () {
      when(mockRemoteConfiguration.getString(any)).thenThrow(Exception());
      when(purchaseService.getProducts())
          .thenThrow(Exception('Couldnt fetch products'));

      final plusPageController = SharezonePlusPageController(
        purchaseService: purchaseService,
        subscriptionService: subscriptionService,
        remoteConfiguration: mockRemoteConfiguration,
      );

      expect(plusPageController.price,
          fallbackSharezonePlusPriceWithCurrencySymbol);
    });
  });
}
