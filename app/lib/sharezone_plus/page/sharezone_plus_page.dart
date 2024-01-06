// Copyright (c) 2023 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:bloc_provider/bloc_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:provider/provider.dart';
import 'package:sharezone/navigation/logic/navigation_bloc.dart';
import 'package:sharezone/navigation/models/navigation_item.dart';
import 'package:sharezone/navigation/scaffold/sharezone_main_scaffold.dart';
import 'package:sharezone/sharezone_plus/page/sharezone_plus_page_controller.dart';
import 'package:sharezone/util/launch_link.dart';
import 'package:sharezone_plus_page_ui/sharezone_plus_page_ui.dart';
import 'package:sharezone_widgets/sharezone_widgets.dart';
import 'package:user/user.dart';

Future<void> navigateToSharezonePlusPage(BuildContext context) async {
  final navigationBloc = BlocProvider.of<NavigationBloc>(context);
  Navigator.popUntil(context, ModalRoute.withName('/'));
  navigationBloc.navigateTo(NavigationItem.sharezonePlus);
}

class SharezonePlusPage extends StatelessWidget {
  static String tag = 'sharezone-plus-page';

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
                    SharezonePlusAdvantages(
                      isHomeworkDoneListsFeatureVisible:
                          typeOfUser == TypeOfUser.teacher,
                      isHomeworkReminderFeatureVisible:
                          typeOfUser == TypeOfUser.student,
                    ),
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
          : const _SubscribeSection(),
    );
  }
}

class _UnsubscribeSection extends StatelessWidget {
  const _UnsubscribeSection();

  @override
  Widget build(BuildContext context) {
    final price = context.watch<SharezonePlusPageController>().price;
    final priceIsLoading = price == null;

    return Column(
      key: const ValueKey('unsubscribe-section'),
      children: [
        priceIsLoading
            ? const SharezonePlusPriceLoadingIndicator()
            : SharezonePlusPrice(price),
        const SizedBox(height: 12),
        const _UnsubscribeText(),
        const SizedBox(height: 12),
        const _UnsubscribeButton(),
      ],
    );
  }
}

class _UnsubscribeText extends StatelessWidget {
  const _UnsubscribeText();

  @override
  Widget build(BuildContext context) {
    return MarkdownBody(
      data:
          'Du hast aktuell das Sharezone-Plus Abo. Solltest du nicht zufrieden sein, würden wir uns über ein [Feedback](#feedback) freuen! Natürlich kannst du dich jederzeit dafür entscheiden, das Abo zu kündigen.',
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
        final controller = context.read<SharezonePlusPageController>();
        await controller.cancelSubscription();
      },
      text: const Text('Kündigen'),
      backgroundColor: flatRed,
    );
  }
}

class _SubscribeSection extends StatelessWidget {
  const _SubscribeSection();

  @override
  Widget build(BuildContext context) {
    final price = context.watch<SharezonePlusPageController>().price;
    final priceIsLoading = price == null;

    return Column(
      key: const ValueKey('subscribe-section'),
      children: [
        priceIsLoading
            ? const SharezonePlusPriceLoadingIndicator()
            : SharezonePlusPrice(price),
        const SizedBox(height: 12),
        _SubscribeButton(loading: priceIsLoading),
        const SizedBox(height: 12),
        const SharezonePlusLegalText(),
      ],
    );
  }
}

class _SubscribeButton extends StatelessWidget {
  const _SubscribeButton({this.loading = false});

  final bool loading;

  @override
  Widget build(BuildContext context) {
    // When using [GrayShimmer] the text inside the [_CallToActionButton]
    // disappears. Using a [Stack] fixes this issue (I don't know why).
    return Stack(
      alignment: Alignment.center,
      children: [
        GrayShimmer(
          enabled: loading,
          child: CallToActionButton(
            text: const Text('Abonnieren'),
            onPressed: loading
                ? null
                : () async {
                    final controller =
                        context.read<SharezonePlusPageController>();
                    await controller.buySubscription();
                  },
            backgroundColor: Theme.of(context).primaryColor,
          ),
        )
      ],
    );
  }
}
