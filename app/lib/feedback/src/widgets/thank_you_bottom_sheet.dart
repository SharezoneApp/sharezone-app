// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:bloc_provider/bloc_provider.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:platform_check/platform_check.dart';
import 'package:sharezone/feedback/src/bloc/feedback_bloc.dart';
import 'package:sharezone/navigation/logic/navigation_bloc.dart';
import 'package:sharezone/navigation/models/navigation_item.dart';
import 'package:sharezone_localizations/sharezone_localizations.dart';
import 'package:sharezone_utils/launch_link.dart';
import 'package:sharezone_widgets/sharezone_widgets.dart';

Future<void> showThankYouBottomSheet(BuildContext context) async {
  await showModalBottomSheet(
    context: context,
    builder: (context) => const ThankYouBottomSheetChild(),
  );
  if (!context.mounted) return;
  _clearFeedbackBox(context);
  _navigateToOverviewPage(context);
}

void _clearFeedbackBox(BuildContext context) {
  final bloc = BlocProvider.of<FeedbackBloc>(context);
  bloc.clearFeedbackBox();
}

void _navigateToOverviewPage(BuildContext context) {
  final navigationBloc = BlocProvider.of<NavigationBloc>(context);
  navigationBloc.navigateTo(NavigationItem.overview);
}

class ThankYouBottomSheetChild extends StatelessWidget {
  const ThankYouBottomSheetChild({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: SafeArea(
        child: Column(
          children: <Widget>[
            const Align(
              alignment: Alignment.centerRight,
              child: CloseIconButton(),
            ),
            SvgPicture.asset(
              'assets/icons/thumbs_up.svg',
              width: 120,
              height: 120,
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                context.l10n.feedbackThankYouTitle,
                style: Theme.of(context).textTheme.headlineSmall,
                textAlign: TextAlign.center,
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: Text.rich(
                TextSpan(
                  children: <TextSpan>[
                    TextSpan(
                      text: context.l10n.feedbackThankYouRatePromptPrefix,
                    ),
                    TextSpan(
                      text:
                          (PlatformCheck.isIOS || PlatformCheck.isMacOS)
                              ? "AppStore"
                              : "PlayStore",
                      style: linkStyle(context, 16),
                      recognizer:
                          TapGestureRecognizer()
                            ..onTap = () {
                              logOpenRating(context);
                              launchURL(
                                (PlatformCheck.isIOS || PlatformCheck.isMacOS)
                                    ? "https://sharezone.net/ios"
                                    : "https://sharezone.net/android",
                              );
                            },
                    ),
                    TextSpan(
                      text: context.l10n.feedbackThankYouRatePromptSuffix,
                    ),
                  ],
                  style: const TextStyle(color: Colors.grey, fontSize: 16),
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void logOpenRating(BuildContext context) {
    final analytics = BlocProvider.of<FeedbackBloc>(context).feedbackAnalytics;
    analytics.logOpenRatingOfThankYouSheet();
  }
}
