import 'dart:async';

import 'package:bloc_base/bloc_base.dart';
import 'package:rxdart/subjects.dart';
import 'package:sharezone/sharezone_plus/page/sharezone_plus_page_view.dart';
import 'package:sharezone/sharezone_plus/subscription_service/purchase_service.dart';
import 'package:sharezone/sharezone_plus/subscription_service/revenue_cat_sharezone_plus_service.dart';
import 'package:sharezone/sharezone_plus/subscription_service/subscription_service.dart';

class SharezonePlusPageBloc extends BlocBase {
  final BehaviorSubject<SharezonePlusPageView> view =
      BehaviorSubject<SharezonePlusPageView>.seeded(
          SharezonePlusPageView.empty());

  late StreamSubscription<bool> _hasPlusSubscription;
  late RevenueCatPurchaseService _purchaseService;
  late SubscriptionService _subscriptionService;

  SharezonePlusPageBloc({
    required RevenueCatPurchaseService purchaseService,
    required SubscriptionService subscriptionService,
  }) {
    _purchaseService = purchaseService;
    _subscriptionService = subscriptionService;

    _listenToPlusStatus();
    _getPlusPrice();
  }

  Future<void> _getPlusPrice() async {
    final product = await _purchaseService.getPlusSubscriptionProduct();
    view.add(view.value.copyWith(price: product.priceString));
  }

  void _listenToPlusStatus() {
    final hasPlus = _subscriptionService.isSubscriptionActiveStream();

    _hasPlusSubscription = hasPlus.listen((hasPlus) {
      view.add(view.value.copyWith(hasPlus: hasPlus));
    });
  }

  Future<void> buy() async {
    //TODO: Implement

    final purchaseService = RevenueCatPurchaseService();
    final products = await purchaseService.getProducts();
    print(products);

    await purchaseService.purchase(ProductId('default-dev-plus-subscription'));
  }

  @override
  void dispose() {
    view.close();
    _hasPlusSubscription.cancel();
  }
}
