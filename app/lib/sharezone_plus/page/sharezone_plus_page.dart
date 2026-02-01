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
import 'package:share_plus/share_plus.dart';
import 'package:sharezone/ads/ads_controller.dart';
import 'package:sharezone/legal/privacy_policy/privacy_policy_page.dart';
import 'package:sharezone/legal/terms_of_service/terms_of_service_page.dart';
import 'package:sharezone/navigation/logic/navigation_bloc.dart';
import 'package:sharezone/navigation/models/navigation_item.dart';
import 'package:sharezone/navigation/scaffold/sharezone_main_scaffold.dart';
import 'package:sharezone/sharezone_plus/page/sharezone_plus_page_controller.dart';
import 'package:sharezone/support/support_page.dart';
import 'package:sharezone_plus_page_ui/sharezone_plus_page_ui.dart';
import 'package:sharezone_localizations/sharezone_localizations.dart';
import 'package:sharezone_utils/launch_link.dart';
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
      builder:
          ((context) =>
              Scaffold(appBar: AppBar(), body: const SharezonePlusPageMain())),
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
  const SharezonePlusPageMain({super.key});

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
                    const SharezonePlusFaq(showContentCreatorQuestion: true),
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
  const _Advantages({required this.typeOfUser});

  final TypeOfUser? typeOfUser;

  @override
  Widget build(BuildContext context) {
    final areAdsVisible = context.watch<AdsController>().areAdsVisible;
    return SharezonePlusAdvantages(
      isHomeworkReminderFeatureVisible: typeOfUser == TypeOfUser.student,
      isRemoveAdsFeatureVisible: areAdsVisible,
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
      child:
          hasPlus ?? false
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
        if (!hasLifetime) ...const [SizedBox(height: 12), _UnsubscribeButton()],
      ],
    );
  }
}

class _UnsubscribeText extends StatelessWidget {
  const _UnsubscribeText({required this.hasLifetime});

  final bool hasLifetime;

  String getText(BuildContext context, bool hasLifetime) {
    if (hasLifetime) {
      return context.l10n.sharezonePlusUnsubscribeLifetimeText;
    }
    return context.l10n.sharezonePlusUnsubscribeActiveText;
  }

  @override
  Widget build(BuildContext context) {
    return MarkdownBody(
      data: getText(context, hasLifetime),
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
      text: Text(context.l10n.sharezonePlusCancelAction),
      backgroundColor: flatRed,
    );
  }
}

class _UnsubscribeFailure extends StatelessWidget {
  const _UnsubscribeFailure({required this.error});

  final String error;

  @override
  Widget build(BuildContext context) {
    return MaxWidthConstraintBox(
      maxWidth: 400,
      child: AlertDialog(
        title: Text(context.l10n.sharezonePlusCancelFailedTitle),
        content: SingleChildScrollView(
          child: Text(
            context.l10n.sharezonePlusCancelFailedContent(error),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(context.l10n.commonActionsOk),
          ),
          FilledButton(
            onPressed: () => Navigator.pushNamed(context, SupportPage.tag),
            child: Text(context.l10n.commonActionsContactSupport),
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
        title: Text(context.l10n.sharezonePlusCancelConfirmationTitle),
        content: Text(context.l10n.sharezonePlusCancelConfirmationContent),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(context.l10n.commonActionsCancel),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(context.l10n.sharezonePlusCancelConfirmAction),
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
            builder:
                (context) => BuyingFailedDialog(
                  error: context.l10n.sharezonePlusLinkTokenLoadFailed,
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
            context: context,
            text: context.l10n.sharezonePlusLinkCopiedToClipboard,
          );
        } else {
        final box = context.findRenderObject() as RenderBox?;
        Share.share(
          url,
          // See: https://github.com/fluttercommunity/plus_plugins/tree/main/packages/share_plus/share_plus#ipad
          sharePositionOrigin: box!.localToGlobal(Offset.zero) & box.size,
        );
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
          onPressedPrivacyPolicy:
              () => Navigator.pushNamed(context, PrivacyPolicyPage.tag),
          onPressedTermsOfService:
              () => Navigator.pushNamed(context, TermsOfServicePage.tag),
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
        title: Text(context.l10n.sharezonePlusTestFlightTitle),
        content: SingleChildScrollView(
          child: Text(context.l10n.sharezonePlusTestFlightContent),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(context.l10n.commonActionsOk),
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
        title: Text(context.l10n.sharezonePlusLetParentsBuyTitle),
        content: SingleChildScrollView(
          child: Text(context.l10n.sharezonePlusLetParentsBuyContent),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(context.l10n.commonActionsCancel),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(context.l10n.sharezonePlusShareLinkAction),
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
        context.l10n.sharezonePlusCanceledSubscriptionNote,
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
        ),
      ),
    );
  }
}
