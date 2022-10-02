// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:bloc_provider/bloc_provider.dart';
import 'package:build_context/build_context.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:optional/optional.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:sharezone/donate/bloc/donation_bloc.dart';
import 'package:sharezone/navigation/logic/navigation_bloc.dart';
import 'package:sharezone/navigation/models/navigation_item.dart';
import 'package:sharezone/navigation/scaffold/app_bar_configuration.dart';
import 'package:sharezone/navigation/scaffold/sharezone_main_scaffold.dart';
import 'package:sharezone/pages/settings/src/subpages/about/widgets/team.dart';
import 'package:sharezone/pages/settings/support_page.dart';
import 'package:sharezone/util/launch_link.dart';
import 'package:sharezone_utils/dimensions.dart';
import 'package:sharezone_utils/platform.dart';
import 'package:sharezone_widgets/adaptive_dialog.dart';
import 'package:sharezone_widgets/snackbars.dart';
import 'package:sharezone_widgets/svg.dart';
import 'package:sharezone_widgets/theme.dart';
import 'package:sharezone_widgets/widgets.dart';
import 'package:sharezone_widgets/wrapper.dart';

import 'donation_item_view.dart';
import 'translate_purchases_error_code.dart';

class DonatePage extends StatefulWidget {
  static const tag = 'donate-page';

  @override
  _DonatePageState createState() => _DonatePageState();
}

class _DonatePageState extends State<DonatePage> {
  @override
  void initState() {
    super.initState();
    logPageOpened();
  }

  void logPageOpened() {
    final bloc = BlocProvider.of<DonationBloc>(context);
    bloc.logDonationPageOpened();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => popToOverview(context),
      child: SharezoneMainScaffold(
        appBarConfiguration: AppBarConfiguration(title: 'Spenden'),
        navigationItem: NavigationItem.donate,
        body: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(vertical: 12),
            child: MaxWidthConstraintBox(
              child: SafeArea(
                child: Column(
                  children: const [
                    SizedBox(height: 8),
                    _Team(),
                    SizedBox(height: 20),
                    _Title(),
                    SizedBox(height: 20),
                    _BeggingForMoneyText(),
                    SizedBox(height: 18),
                    _DonationOptions(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _Title extends StatelessWidget {
  const _Title({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      'Unterstütze Sharezone 💙',
      style: Theme.of(context).textTheme.headline5,
      textAlign: TextAlign.center,
    );
  }
}

class _Team extends StatelessWidget {
  const _Team({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final sizedBoxWidth =
        Dimensions.fromMediaQuery(context).isDesktopModus ? 50.0 : 12.0;
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _TeamMember(
            imagePath: TeamImagePath.nils,
            name: 'Nils Reichardt',
          ),
          SizedBox(width: sizedBoxWidth),
          _TeamMember(
            imagePath: TeamImagePath.jonas,
            name: 'Jonas Sander',
          ),
          SizedBox(width: sizedBoxWidth),
        ],
      ),
    );
  }
}

class _TeamMember extends StatelessWidget {
  const _TeamMember({
    Key key,
    @required this.imagePath,
    @required this.name,
  }) : super(key: key);

  final String imagePath;
  final String name;

  @override
  Widget build(BuildContext context) {
    final imageSize =
        (MediaQuery.of(context).size.width * 0.25).clamp(0.0, 100.0).toDouble();
    return Tooltip(
      message: name,
      child: Image(
        width: imageSize,
        height: imageSize,
        image: AssetImage(imagePath),
      ),
    );
  }
}

class _BeggingForMoneyText extends StatelessWidget {
  const _BeggingForMoneyText({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: MarkdownBody(
        data:
            // Umbrüche müssen mit \n gemacht werden, da ansonsten bei ''' '''
            // das Markdown-Plugin den Text nicht korrekt anzeigt, wenn dort ein
            // Emoji enthalten ist.
            'Wir sind 2 Jungs, die aus der Schule heraus mit Sharezone den Schulalltag revolutionieren wollen!\n\nWir sind für jede Spende dankbar, die es uns ermöglicht noch weiter Zeit und Energie in Sharezone zu stecken ❤️\n\nJeder Spender enthält zudem den Unterstützer-Rang auf unserem [Discord-Server](https://sharezone.net/discord) 💪',
        styleSheet: MarkdownStyleSheet(
          textAlign: WrapAlignment.center,
          p: Theme.of(context)
              .textTheme
              .bodyText2
              .copyWith(fontSize: 16, height: 1.3),
          a: linkStyle(context),
        ),
        onTapLink: (url, _, __) => launchURL(url, context: context),
      ),
    );
  }
}

class _DonationOptions extends StatelessWidget {
  const _DonationOptions({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Im Web laufen die Donations über einen PayPal-Link, weil ein
    // Bezahlservice, wie z.B. Stripe noch nicht implementiert ist.
    if (PlatformCheck.isWeb) return _PayPalDonateButton();

    // Das RevenueCat-Plugin unterstützt momentan noch keine In-App-Käufe für
    // Flutter macOS. Sobald dies möglich ist, kann auch über die macOS-App
    // gespendet werden.
    //
    // Ticket: https://github.com/RevenueCat/purchases-flutter/issues/26
    if (PlatformCheck.isMacOS) return _DonationsNotSupportedOnMacOsButton();

    final bloc = BlocProvider.of<DonationBloc>(context);
    return FutureBuilder<List<DonationItemView>>(
      future: bloc.getProductViews(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return AccentColorCircularProgressIndicator();
        final products = snapshot.data;
        return Column(
          children: [
            for (final product in products)
              _DonationOptionTile(
                leadingSvgPath: product.iconPath,
                product: product,
              )
          ],
        );
      },
    );
  }
}

class _PayPalDonateButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: () => launchURL("https://paypal.me/sharezone"),
      label: const Text("Spenden via PayPal"),
      icon: Icon(Icons.favorite),
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white, backgroundColor: Theme.of(context).primaryColor,
      ),
    );
  }
}

class _DonationsNotSupportedOnMacOsButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: () {
        _noMacOsSupportDialog(context);
        _logPressedDonationButton(context);
      },
      label: const Text("Spenden"),
      icon: Icon(Icons.favorite),
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white, backgroundColor: Theme.of(context).primaryColor,
      ),
    );
  }

  void _logPressedDonationButton(BuildContext context) {
    final bloc = BlocProvider.of<DonationBloc>(context);
    bloc.logPressedDonationButtonOnMacOs();
  }

  void _noMacOsSupportDialog(BuildContext context) {
    showLeftRightAdaptiveDialog(
      context: context,
      title: 'Spenden über macOS nicht möglich',
      left: AdaptiveDialogAction.ok,
      content: Text(
          "Aktuell kann leider nicht über die macOS-App gespendet werden. Dies ist nur über die Android-, iOS- oder Web-App möglich."),
    );
  }
}

class _DonationOptionTile extends StatelessWidget {
  const _DonationOptionTile({
    Key key,
    @required this.leadingSvgPath,
    this.product,
  }) : super(key: key);

  final Optional<String> leadingSvgPath;
  final DonationItemView product;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: 400),
        child: ListTile(
          leading: CircleAvatar(
            backgroundColor: isDarkThemeEnabled(context)
                ? Colors.grey[700]
                : Colors.grey[300],
            child: leadingSvgPath.isPresent
                ? PlatformSvg.asset(
                    leadingSvgPath.value,
                    width: 27.5,
                    height: 27.5,
                  )
                : null,
          ),
          title: Text(product.title),
          trailing: Text(product.price),
          onTap: () => donate(context),
        ),
      ),
    );
  }

  Future<void> donate(BuildContext context) async {
    final bloc = BlocProvider.of<DonationBloc>(context);
    try {
      // Snackbar wird verzögert angezeigt, damit erst der Kaufdialog angezeigt
      // wird und danach erst die Lade-Snackbar.
      Future.delayed(const Duration(milliseconds: 600)).then(
        (value) => showSnackSec(
          context: context,
          text: 'Spende wird übermittelt',
          seconds: 60,
          withLoadingCircle: true,
        ),
      );
      await bloc.spende(product.id);
      context.hideCurrentSnackBar();
      showThanksDialog(context);
    } on PlatformException catch (e) {
      context.hideCurrentSnackBar();
      final purchaseError = PurchasesErrorHelper.getErrorCode(e);
      if (purchaseError != PurchasesErrorCode.purchaseCancelledError) {
        showErrorDialog(context,
            PurchasesErrorTranslator.getTranslatedMessage(purchaseError));
      }
    } on Exception catch (e) {
      context.hideCurrentSnackBar();
      showErrorDialog(context, 'Es gab einen Fehler: ${e.toString()}');
    }
  }

  Future<void> showErrorDialog(BuildContext context, String errorMsg) async {
    final contactSupport = await showLeftRightAdaptiveDialog<bool>(
      context: context,
      defaultValue: false,
      content: Text(errorMsg),
      title: 'Fehler',
      left: AdaptiveDialogAction<bool>(
        title: 'Support kontakieren',
        popResult: true,
      ),
      right: AdaptiveDialogAction.ok,
    );
    if (contactSupport) {
      Navigator.pushNamed(context, SupportPage.tag);
    }
  }

  void showThanksDialog(BuildContext context) {
    showLeftRightAdaptiveDialog(
      context: context,
      title: "Danke!",
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          PlatformSvg.asset('assets/icons/gift.svg', width: 125, height: 125),
          const SizedBox(height: 28),
          Text(
            "Vielen Dank für deine Spende!\n\nFalls du den Unterstützer-Rang auf unserem Discord-Server erhalten möchtest, dann melde dich dort bei einem Admin 👍",
            textAlign: TextAlign.center,
          )
        ],
      ),
      left: AdaptiveDialogAction.ok,
    );
  }
}
