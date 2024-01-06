// Copyright (c) 2024 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:sharezone_plus_page_ui/sharezone_plus_page_ui.dart';
import 'package:sharezone_website/flavor.dart';
import 'package:sharezone_website/page.dart';
import 'package:sharezone_widgets/sharezone_widgets.dart';

final isSharezonePlusPageEnabledFlag =
    kDebugMode || Flavor.fromEnvironment() == Flavor.dev;

class SharezonePlusPage extends StatelessWidget {
  const SharezonePlusPage({super.key});

  static const tag = 'plus';

  @override
  Widget build(BuildContext context) {
    return const PageTemplate(
      children: [
        MaxWidthConstraintBox(
          maxWidth: 750,
          child: Column(
            children: [
              SharezonePlusPageHeader(),
              SizedBox(height: 18),
              WhyPlusSharezoneCard(),
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
  }
}

class _SubscribeSection extends StatelessWidget {
  const _SubscribeSection();

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        SharezonePlusPrice('4,99€'),
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
