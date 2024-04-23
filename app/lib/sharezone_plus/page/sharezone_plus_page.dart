// Copyright (c) 2023 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:bloc_provider/bloc_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:platform_check/platform_check.dart';
import 'package:provider/provider.dart';
import 'package:share/share.dart';
import 'package:sharezone/navigation/logic/navigation_bloc.dart';
import 'package:sharezone/navigation/models/navigation_item.dart';
import 'package:sharezone/navigation/scaffold/sharezone_main_scaffold.dart';
import 'package:sharezone/sharezone_plus/page/sharezone_plus_page_controller.dart';
import 'package:sharezone/support/support_page.dart';
import 'package:sharezone_utils/launch_link.dart';
import 'package:sharezone_plus_page_ui/sharezone_plus_page_ui.dart';
import 'package:sharezone_widgets/sharezone_widgets.dart';
import 'package:user/user.dart';

Future<void> navigateToSharezonePlusPage(BuildContext context) async {
  final navigationBloc = BlocProvider.of<NavigationBloc>(context);
  Navigator.popUntil(context, ModalRoute.withName('/'));
  navigationBloc.navigateTo(NavigationItem.sharezonePlus);
}

void openSharezonePlusPageAsFullscreenDialog(BuildContext context) {
  Navigator.push(
    context,
    MaterialPageRoute(
      fullscreenDialog: true,
      builder: ((context) => Scaffold(
            appBar: AppBar(),
            body: const SharezonePlusPageMain(),
          )),
      settings: const RouteSettings(name: SharezonePlusPage.tag),
    ),
  );
}

class SharezonePlusPage extends StatelessWidget {
  static const String tag = 'sharezone-plus-page';

  const SharezonePlusPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const SharezoneMainScaffold(
      navigationItem: NavigationItem.sharezonePlus,
      body: SharezonePlusPageMain(),
    );
  }
}

@visibleForTesting
class SharezonePlusPageMain extends StatelessWidget {
  const SharezonePlusPageMain({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final typeOfUser = context.watch<TypeOfUser?>();
    return SharezonePlusPageTheme(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: MaxWidthConstraintBox(
            maxWidth: 750,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 18),
              child: SafeArea(
                child: Column(
                  children: [
                    const SharezonePlusPageHeader(),
                    const SizedBox(height: 18),
                    const WhyPlusSharezoneCard(),
                    const SizedBox(height: 18),
                    _Advantages(typeOfUser: typeOfUser),
                    const SizedBox(height: 18),
                    const _CallToActionSection(),
                    const SizedBox(height: 32),
                    const SharezonePlusFaq(),
                    const SizedBox(height: 18),
                    const SharezonePlusSupportNote(),
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

class _Advantages extends StatelessWidget {
  const _Advantages({
    required this.typeOfUser,
  });

  final TypeOfUser? typeOfUser;

  @override
  Widget build(BuildContext context) {
    return SharezonePlusAdvantages(
      isHomeworkDoneListsFeatureVisible: typeOfUser == TypeOfUser.teacher,
      isHomeworkReminderFeatureVisible: typeOfUser == TypeOfUser.student,
      onOpenedAdvantage: (advantage) {
        final analytics = context.read<SharezonePlusPageController>();
        analytics.logOpenedAdvantage(advantage);
      },
      onGitHubOpen: () {
        final analytics = context.read<SharezonePlusPageController>();
        analytics.logOpenGitHub();
      },
    );
  }
}

class _CallToActionSection extends StatelessWidget {
  const _CallToActionSection();

  @override
  Widget build(BuildContext context) {
    final hasPlus = context.watch<SharezonePlusPageController>().hasPlus;
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      // If the users plus status is still loading then we show the
      // _SubscribeSection which will show loading indicators in turn.
      child: hasPlus ?? false
          ? const _UnsubscribeSection()
          : const _PurchaseSection(),
    );
  }
}

class _UnsubscribeSection extends StatelessWidget {
  const _UnsubscribeSection();

  @override
  Widget build(BuildContext context) {
    final hasLifetime =
        context.watch<SharezonePlusPageController>().hasLifetime;
    return Column(
      key: const ValueKey('unsubscribe-section'),
      children: [
        const SizedBox(height: 12),
        _UnsubscribeText(hasLifetime: hasLifetime),
        if (!hasLifetime) ...const [
          SizedBox(height: 12),
          _UnsubscribeButton(),
        ]
      ],
    );
  }
}

class _UnsubscribeText extends StatelessWidget {
  const _UnsubscribeText({
    required this.hasLifetime,
  });

  final bool hasLifetime;

  String getText(bool hasLifetime) {
    if (hasLifetime) {
      return 'Du hast Sharezone-Plus auf Lebenszeit. Solltest du nicht zufrieden sein, würden wir uns über ein [Feedback](#feedback) freuen!';
    }
    return 'Du hast aktuell das Sharezone-Plus Abo. Solltest du nicht zufrieden sein, würden wir uns über ein [Feedback](#feedback) freuen! Natürlich kannst du dich jederzeit dafür entscheiden, das Abo zu kündigen.';
  }

  @override
  Widget build(BuildContext context) {
    return MarkdownBody(
      data: getText(hasLifetime),
      styleSheet: MarkdownStyleSheet(
        a: TextStyle(
          color: Theme.of(context).primaryColor,
          decoration: TextDecoration.underline,
        ),
        textAlign: WrapAlignment.center,
      ),
      onTapLink: (text, href, title) {
        if (href == null) return;

        if (href == '#feedback') {
          final navigationBloc = BlocProvider.of<NavigationBloc>(context);
          navigationBloc.navigateTo(NavigationItem.feedbackBox);
          return;
        }

        launchURL(href, context: context);
      },
    );
  }
}

class _UnsubscribeButton extends StatelessWidget {
  const _UnsubscribeButton();

  @override
  Widget build(BuildContext context) {
    const flatRed = Color(0xFFF55F4B);
    return CallToActionButton(
      onPressed: () async {
        final shouldCancel = await showDialog<bool>(
          context: context,
          builder: (context) => const _UnsubscribeNoteDialog(),
        );

        if (shouldCancel != true || !context.mounted) {
          return;
        }

        final controller = context.read<SharezonePlusPageController>();
        try {
          await controller.cancelSubscription();
        } on Exception catch (e) {
          if (!context.mounted) return;
          showDialog(
            context: context,
            builder: (context) => _UnsubscribeFailure(error: '$e'),
          );
        }
      },
      text: const Text('Kündigen'),
      backgroundColor: flatRed,
    );
  }
}

class _UnsubscribeFailure extends StatelessWidget {
  const _UnsubscribeFailure({
    required this.error,
  });

  final String error;

  @override
  Widget build(BuildContext context) {
    return MaxWidthConstraintBox(
      maxWidth: 400,
      child: AlertDialog(
        title: const Text('Kündigung fehlgeschlagen'),
        content: SingleChildScrollView(
          child: Text(
              'Es ist ein Fehler aufgetreten. Bitte versuche es später erneut.\n\nFehler: $error'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
          FilledButton(
            onPressed: () => Navigator.pushNamed(context, SupportPage.tag),
            child: const Text('Support kontaktieren'),
          ),
        ],
      ),
    );
  }
}

class _UnsubscribeNoteDialog extends StatelessWidget {
  const _UnsubscribeNoteDialog();

  @override
  Widget build(BuildContext context) {
    return MaxWidthConstraintBox(
      maxWidth: 400,
      child: AlertDialog(
        title: const Text('Bist du dir sicher?'),
        content: const Text(
            'Wenn du dein Sharezone-Plus Abo kündigst, verlierst du den Zugriff auf alle Plus-Funktionen.\n\nBist du sicher, dass du kündigen möchtest?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Abbrechen'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Kündigen'),
          ),
        ],
      ),
    );
  }
}

class _PurchaseSection extends StatelessWidget {
  const _PurchaseSection();

  Future<void> onLetParentsBuy(BuildContext context) async {
    final controller = context.read<SharezonePlusPageController>();
    final token = await controller.getBuyWebsiteToken();

    if (!context.mounted) {
      return;
    }

    if (token == null) {
      showDialog(
        context: context,
        builder: (context) => const BuyingFailedDialog(
          error: 'Der Token für den Link konnte nicht geladen werden.',
        ),
      );
      return;
    }

    final shouldShare = await showDialog<bool>(
      context: context,
      builder: (context) => const _ShareLetParentsBuyLinkDialog(),
    );

    if (shouldShare == true && context.mounted) {
      final url = 'https://sharezone.net/plus?token=$token';
      if (PlatformCheck.isDesktopOrWeb) {
        Clipboard.setData(ClipboardData(text: url));
        showSnackSec(
            context: context, text: 'Link in die Zwischenablage kopiert.');
      } else {
        Share.share(url);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<SharezonePlusPageController>();
    final monthlyPrice = controller.monthlySubscriptionPrice;
    final lifetimePrice = controller.lifetimePrice;
    final isLoading = monthlyPrice == null || lifetimePrice == null;
    final isCanceled = controller.isCancelled;
    return Column(
      children: [
        if (isCanceled) ...const [
          _CanceledSubscriptionNote(),
          SizedBox(height: 6),
        ],
        BuySection(
          key: const ValueKey('subscribe-section'),
          monthlyPrice: monthlyPrice,
          lifetimePrice: lifetimePrice,
          currentPeriod: controller.selectedPurchasePeriod,
          onPeriodChanged: controller.setPeriodOption,
          isPriceLoading: isLoading,
          isPurchaseButtonLoading: controller.isPurchaseButtonLoading,
          onLetParentsBuy: () => onLetParentsBuy(context),
          showLetParentsBuyButton: controller.showLetParentsBuyButton,
          isLetParentsBuyButtonLoading: controller.isLetParentsBuyButtonLoading,
          onPurchase: () async {
            final controller = context.read<SharezonePlusPageController>();

            try {
              final isBuyingEnabled = await controller.isBuyingEnabled();

              if (!context.mounted) {
                return;
              }

              if (!isBuyingEnabled) {
                showDialog(
                  context: context,
                  builder: (context) => const BuyingDisabledDialog(),
                );
                return;
              }

              await controller.buy();
            } catch (e) {
              if (!context.mounted) {
                return;
              }

              if (e is IsTestFlightUserException) {
                showDialog(
                  context: context,
                  builder: (context) => const _ShowTestFlightDialog(),
                );
                return;
              }

              showDialog(
                context: context,
                builder: (context) => BuyingFailedDialog(error: '$e'),
              );
            }
          },
        ),
      ],
    );
  }
}

class _ShowTestFlightDialog extends StatelessWidget {
  const _ShowTestFlightDialog();

  @override
  Widget build(BuildContext context) {
    return MaxWidthConstraintBox(
      maxWidth: 450,
      child: AlertDialog(
        title: const Text('TestFlight'),
        content: const Text(
          'Du hast Sharezone über TestFlight installiert. Apple erlaubt keine In-App-Käufe über TestFlight.\n\nUm Sharezone-Plus zu kaufen, lade bitte die App aus dem App Store herunter. Dort kannst du Sharezone-Plus kaufen.\n\nDanach kannst du die App wieder über TestFlight installieren.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}

class _ShareLetParentsBuyLinkDialog extends StatelessWidget {
  const _ShareLetParentsBuyLinkDialog();

  @override
  Widget build(BuildContext context) {
    return MaxWidthConstraintBox(
      maxWidth: 450,
      child: AlertDialog(
        title: const Text('Eltern bezahlen lassen'),
        content: const SingleChildScrollView(
          child: Text(
            'Du kannst deinen Eltern einen Link schicken, damit sie Sharezone-Plus für dich kaufen können.\n\nDer Link ist nur für dich gültig und enthält die Verbindung zu deinem Account.',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Abbrechen'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Link teilen'),
          ),
        ],
      ),
    );
  }
}

class _CanceledSubscriptionNote extends StatelessWidget {
  const _CanceledSubscriptionNote();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Text(
        'Du hast dein Sharezone-Plus Abo gekündigt. Du kannst deine Vorteile noch bis zum Ende des aktuellen Abrechnungszeitraums nutzen. Solltest du es dir anders überlegen, kannst du es jederzeit wieder erneut Sharezone-Plus abonnieren.',
        textAlign: TextAlign.center,
        style: TextStyle(
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6)),
      ),
    );
  }
}
