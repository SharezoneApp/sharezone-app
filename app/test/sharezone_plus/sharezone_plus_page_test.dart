import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:sharezone/sharezone_plus/page/sharezone_plus_page.dart';
import 'package:sharezone/sharezone_plus/page/sharezone_plus_page_controller.dart';

class MockSharezonePlusPageController extends ChangeNotifier
    implements SharezonePlusPageController {
  @override
  late bool hasPlus;

  @override
  late String price;

  @override
  Future<void> buySubscription() async {}

  @override
  Future<void> cancelSubscription() async {}
}

void main() {
  group(SharezonePlusPage, () {
    late MockSharezonePlusPageController controller;
    setUp(() {
      controller = MockSharezonePlusPageController();
    });

    Future<void> pumpPlusPage(WidgetTester tester) async {
      await tester.pumpWidget(
        ChangeNotifierProvider<SharezonePlusPageController>(
          create: (context) => controller,
          child:
              const MaterialApp(home: Scaffold(body: SharezonePlusPageMain())),
        ),
      );
    }

    testWidgets('shows price to pay if not subscribed', (tester) async {
      controller.hasPlus = false;
      controller.price = '4,99 €';

      await pumpPlusPage(tester);

      expect(find.text('4,99 €'), findsOneWidget);
    });

    testWidgets('shows "subscribe" button if not subscribed', (tester) async {
      controller.hasPlus = false;
      controller.price = '4,99 €';

      await tester.pumpWidget(
        ChangeNotifierProvider<SharezonePlusPageController>(
          create: (context) => controller,
          child:
              const MaterialApp(home: Scaffold(body: SharezonePlusPageMain())),
        ),
      );

      expect(find.widgetWithText(CallToActionButton, 'Abonnieren'),
          findsOneWidget);
    });
    testWidgets('shows "cancel" button if subscribed', (tester) async {
      controller.hasPlus = true;
      controller.price = '4,99 €';

      await tester.pumpWidget(
        ChangeNotifierProvider<SharezonePlusPageController>(
          create: (context) => controller,
          child:
              const MaterialApp(home: Scaffold(body: SharezonePlusPageMain())),
        ),
      );

      expect(
          find.widgetWithText(CallToActionButton, 'Kündigen'), findsOneWidget);
    });
  });
}
