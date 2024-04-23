// Copyright (c) 2024 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:sharezone_plus_page_ui/sharezone_plus_page_ui.dart';
import 'package:sharezone_website/flavor.dart';
import 'package:sharezone_website/page.dart';
import 'package:sharezone_website/utils.dart';
import 'package:sharezone_widgets/sharezone_widgets.dart';

final isSharezonePlusPageEnabledFlag =
    kDebugMode || Flavor.fromEnvironment() == Flavor.dev;

typedef UserData = ({String username, String userId});

Future<UserData?> fetchUserData(String? token) async {
  if (token == null) {
    return null;
  }
  const link =
      "https://europe-west1-sharezone-debug.cloudfunctions.net/getDataForPlusWebsiteBuyToken";
  final response = await Dio().post(link, data: {'token': token});
  final dataMap = response.data as Map;
  final username = dataMap['username'] as String;
  final userId = dataMap['userId'] as String;
  return (username: username, userId: userId);
}

Future<Uri> getStripeCheckoutSessionUrl(
    String userId, PurchasePeriod period) async {
  const link =
      "https://europe-west1-sharezone-debug.cloudfunctions.net/createStripeCheckoutSession";
  final response = await Dio().post(link, data: {
    'buysFor': userId,
    'successUrl': '${Uri.base.origin + Uri.base.path}/success',
    'cancelUrl': Uri.base.toString(),
    'period': period.name,
  });
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
        final data = snapshot.data;
        var purchasePeriod = PurchasePeriod.monthly;
        return PageTemplate(
          children: [
            MaxWidthConstraintBox(
              maxWidth: 750,
              child: Column(
                children: [
                  SizedBox(height: 50),
                  if (snapshot.hasError) Text('Error: ${snapshot.error}'),
                  if (urlToken != null)
                    DecoratedBox(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(17.5),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text('Sharezone Plus kaufen für',
                              style: TextStyle(fontSize: 26)),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              PlatformSvg.asset(
                                "assets/icons/students.svg",
                                width: 180,
                                height: 180,
                              ),
                              SizedBox(width: 30),
                              Column(
                                children: [
                                  Text(
                                    data?.username ?? 'Lädt...',
                                    style: Theme.of(context)
                                        .textTheme
                                        .headlineSmall,
                                  ),
                                  Text(data?.userId ?? '',
                                      style: TextStyle(
                                          fontSize: 10,
                                          color: Colors.grey.withOpacity(.8))),
                                ],
                              ),
                            ],
                          ),
                          SizedBox(height: 18),
                          StatefulBuilder(builder: (context, setState) {
                            return BuySection(
                              monthlyPrice: '1,99€',
                              lifetimePrice: '19,99€',
                              onPurchase: data?.userId != null
                                  ? () async {
                                      final url =
                                          await getStripeCheckoutSessionUrl(
                                              data!.userId, purchasePeriod);
                                      await launchUrl(url.toString());
                                    }
                                  : null,
                              currentPeriod: purchasePeriod,
                              onPeriodChanged: (p) {
                                setState(() {
                                  purchasePeriod = p;
                                });
                              },
                            );
                          }),
                        ],
                      ),
                    ),
                  SizedBox(height: 25),
                  Text('Vorteile von Sharezone Plus',
                      style: TextStyle(fontSize: 23)),
                  SizedBox(height: 18),
                  SharezonePlusAdvantages(
                    isHomeworkDoneListsFeatureVisible: true,
                    isHomeworkReminderFeatureVisible: true,
                  ),
                  SizedBox(height: 18),
                  _SubscribeSection(),
                  SizedBox(height: 32),
                  SharezonePlusFaq(),
                  SizedBox(height: 18),
                  SharezonePlusSupportNote(),
                  SizedBox(height: 32),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}

class _SubscribeSection extends StatelessWidget {
  const _SubscribeSection();

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        Text('4,99€'),
        SizedBox(height: 12),
        _SubscribeButton(),
        SizedBox(height: 12),
        SharezonePlusLegalText(),
      ],
    );
  }
}

class _SubscribeButton extends StatelessWidget {
  const _SubscribeButton();

  @override
  Widget build(BuildContext context) {
    return CallToActionButton(
      text: const Text('Abonnieren'),
      onPressed: () {},
    );
  }
}
