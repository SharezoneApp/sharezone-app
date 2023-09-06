import 'dart:async';

import 'package:bloc_base/bloc_base.dart';
import 'package:rxdart/subjects.dart';
import 'package:sharezone/sharezone_plus/page/sharezone_plus_page_view.dart';
import 'package:sharezone/sharezone_plus/subscription_service/purchase_service.dart';
import 'package:sharezone/sharezone_plus/subscription_service/revenue_cat_sharezone_plus_service.dart';
import 'package:sharezone/sharezone_plus/subscription_service/subscription_service.dart';

class SharezonePlusPageBloc extends BlocBase {
  final BehaviorSubject<SharezonePlusPageView> _view =
      BehaviorSubject<SharezonePlusPageView>.seeded(
          SharezonePlusPageView.empty());
  Stream<SharezonePlusPageView> get view => _view;

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
    _view.add(_view.value.copyWith(price: product.priceString));
  }

  void _listenToPlusStatus() {
    final hasPlus = _subscriptionService.isSubscriptionActiveStream();

    _hasPlusSubscription = hasPlus.listen((hasPlus) {
      _view.add(_view.value.copyWith(hasPlus: hasPlus));
    });
  }

  Future<void> buySubscription() async {
    //TODO: Implement

    final purchaseService = RevenueCatPurchaseService();
    final products = await purchaseService.getProducts();
    print(products);

    await purchaseService.purchase(ProductId('default-dev-plus-subscription'));
  }

  Future<void> cancelSubscription() async {
    // TODO
  }

  @override
  void dispose() {
    _view.close();
    _hasPlusSubscription.cancel();
  }
}
