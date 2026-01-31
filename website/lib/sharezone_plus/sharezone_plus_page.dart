// Copyright (c) 2024 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:go_router/go_router.dart';
import 'package:legal/legal.dart';
import 'package:sharezone_localizations/sharezone_localizations.dart';
import 'package:sharezone_plus_page_ui/sharezone_plus_page_ui.dart';
import 'package:sharezone_website/flavor.dart';
import 'package:sharezone_website/page.dart';
import 'package:sharezone_website/utils.dart';
import 'package:sharezone_widgets/sharezone_widgets.dart';

typedef UserData = ({String username, String userId});

String getFirebaseProjectId() {
  return switch (Flavor.fromEnvironment()) {
    Flavor.dev => 'sharezone-debug',
    Flavor.prod => 'sharezone-c2bd8',
  };
}

Future<UserData?> fetchUserData(String? token) async {
  if (token == null) {
    return null;
  }
  final link =
      "https://europe-west1-${getFirebaseProjectId()}.cloudfunctions.net/getDataForPlusWebsiteBuyToken";
  final response = await Dio().post(link, data: {'token': token});
  final dataMap = response.data as Map;
  final username = dataMap['username'] as String;
  final userId = dataMap['userId'] as String;
  return (username: username, userId: userId);
}

Future<Uri> getStripeCheckoutSessionUrl(
  String userId,
  PurchasePeriod period,
) async {
  final link =
      "https://europe-west1-${getFirebaseProjectId()}.cloudfunctions.net/createStripeCheckoutSession";
  final response = await Dio().post(
    link,
    data: {
      'buysFor': userId,
      'successUrl': '${Uri.base.origin + Uri.base.path}/success',
      'cancelUrl': Uri.base.toString(),
      'period': period.name,
    },
  );
  final dataMap = response.data as Map;
  return Uri.parse(dataMap['url'] as String);
}

class SharezonePlusPage extends StatelessWidget {
  const SharezonePlusPage({super.key});

  static const tag = 'plus';

  @override
  Widget build(BuildContext context) {
    final map = ModalRoute.of(context)!.settings.arguments as Map;
    final urlToken = map['token'] as String?;
    return FutureBuilder<UserData?>(
      future: fetchUserData(urlToken),
      builder: (context, snapshot) {
        final l10n = context.l10n;
        final data = snapshot.data;
        var purchasePeriod = PurchasePeriod.monthly;
        var isPurchaseButtonLoading = false;
        final hasToken = urlToken != null;
        return PageTemplate(
          children: [
            MaxWidthConstraintBox(
              maxWidth: 750,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  children: [
                    const SizedBox(height: 50),
                    if (snapshot.hasError)
                      Text(
                        l10n.websiteSharezonePlusLoadError(
                          '${snapshot.error}',
                        ),
                      ),
                    if (hasToken)
                      DecoratedBox(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(17.5),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              l10n.websiteSharezonePlusPurchaseForTitle,
                              style: const TextStyle(fontSize: 26),
                            ),
                            const SizedBox(height: 6),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                CircleAvatar(
                                  backgroundColor:
                                      Theme.of(context).colorScheme.primary,
                                  child: const Icon(Icons.person),
                                ),
                                const SizedBox(width: 12),
                                Flexible(
                                  child: Text(
                                    data?.username ??
                                        l10n.websiteSharezonePlusLoadingName,
                                    style: const TextStyle(fontSize: 20),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 18),
                            StatefulBuilder(
                              builder: (context, setState) {
                                return BuySection(
                                  monthlyPrice: '1,99€',
                                  lifetimePrice: '19,99€',
                                  onPressedPrivacyPolicy:
                                      () => context.push(
                                        '/${PrivacyPolicyPage.tag}',
                                      ),
                                  onPressedTermsOfService:
                                      () => context.push(
                                        '/${TermsOfServicePage.tag}',
                                      ),
                                  onPurchase:
                                      data?.userId != null
                                          ? () async {
                                            setState(() {
                                              isPurchaseButtonLoading = true;
                                            });
                                            final url =
                                                await getStripeCheckoutSessionUrl(
                                                  data!.userId,
                                                  purchasePeriod,
                                                );
                                            await launchUrl(
                                              url.toString(),
                                              // Since the request for creating the checkout session is asynchronous, we
                                              // can't open the checkout in a new tab due to the browser security
                                              // policy.
                                              //
                                              // See https://github.com/flutter/flutter/issues/78524.
                                              webOnlyWindowName: "_self",
                                            );
                                            if (context.mounted) {
                                              setState(() {
                                                isPurchaseButtonLoading = false;
                                              });
                                            }
                                          }
                                          : null,
                                  currentPeriod: purchasePeriod,
                                  isPurchaseButtonLoading:
                                      isPurchaseButtonLoading,
                                  onPeriodChanged: (p) {
                                    setState(() {
                                      purchasePeriod = p;
                                    });
                                  },
                                  bottom: const _ManageSubscriptionText(),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    const SizedBox(height: 25),
                    Text(
                      l10n.websiteSharezonePlusAdvantagesTitle,
                      style: const TextStyle(fontSize: 23),
                    ),
                    const SizedBox(height: 18),
                    const SharezonePlusAdvantages(
                      isHomeworkReminderFeatureVisible: true,
                    ),
                    const SizedBox(height: 18),
                    if (!hasToken) ...[
                      StatefulBuilder(
                        builder: (context, setState) {
                          return BuySection(
                            monthlyPrice: '1,99€',
                            lifetimePrice: '19,99€',
                            onPurchase: () async {
                              showDialog(
                                context: context,
                                builder: (context) => const _BuyDialog(),
                              );
                            },
                            currentPeriod: purchasePeriod,
                            onPeriodChanged: (p) {
                              setState(() {
                                purchasePeriod = p;
                              });
                            },
                            bottom: const _ManageSubscriptionText(),
                            onPressedPrivacyPolicy:
                                () => context.push('/${PrivacyPolicyPage.tag}'),
                            onPressedTermsOfService:
                                () =>
                                    context.push('/${TermsOfServicePage.tag}'),
                          );
                        },
                      ),
                      const SizedBox(height: 32),
                    ],
                    const SharezonePlusFaq(),
                    const SizedBox(height: 18),
                    const SharezonePlusSupportNote(),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _BuyDialog extends StatelessWidget {
  const _BuyDialog();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return MaxWidthConstraintBox(
      maxWidth: 450,
      child: AlertDialog(
        title: Text(l10n.websiteSharezonePlusPurchaseDialogTitle),
        content: MarkdownBody(
          data: l10n.websiteSharezonePlusPurchaseDialogContent,
          onTapLink: (text, href, title) async {
            if (href == null) return;
            await launchUrl(href);
          },
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(l10n.commonActionsCancel),
          ),
          FilledButton(
            child: Text(l10n.websiteSharezonePlusPurchaseDialogToWebApp),
            onPressed: () => launchUrl('https://web.sharezone.net'),
          ),
        ],
      ),
    );
  }
}

class _ManageSubscriptionText extends StatelessWidget {
  const _ManageSubscriptionText();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 12),
      child: MarkdownBody(
        data: context.l10n.websiteSharezonePlusManageSubscriptionText,
        styleSheet: MarkdownStyleSheet(
          a: TextStyle(
            color: Theme.of(context).primaryColor,
            decoration: TextDecoration.underline,
          ),
          textAlign: WrapAlignment.center,
        ),
        onTapLink: (text, href, title) async {
          if (href == null) return;
          showDialog(
            context: context,
            builder: (context) => _CustomerPortalDialog(url: href),
          );
        },
      ),
    );
  }
}

class _CustomerPortalDialog extends StatelessWidget {
  const _CustomerPortalDialog({required this.url});

  final String url;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return MaxWidthConstraintBox(
      maxWidth: 450,
      child: AlertDialog(
        title: Text(l10n.websiteSharezonePlusCustomerPortalTitle),
        content: SingleChildScrollView(
          child: Text(
            l10n.websiteSharezonePlusCustomerPortalContent,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(l10n.commonActionsCancel),
          ),
          FilledButton(
            child: Text(l10n.websiteSharezonePlusCustomerPortalOpen),
            onPressed: () async {
              await launchUrl(url);
              if (context.mounted) {
                Navigator.of(context).pop();
              }
            },
          ),
        ],
      ),
    );
  }
}
