import 'package:bloc_provider/bloc_provider.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:sharezone/feedback/src/bloc/feedback_bloc.dart';
import 'package:sharezone/navigation/logic/navigation_bloc.dart';
import 'package:sharezone/navigation/models/navigation_item.dart';
import 'package:sharezone/util/launch_link.dart';
import 'package:sharezone_utils/platform.dart';
import 'package:sharezone_widgets/theme.dart';
import 'package:sharezone_widgets/svg.dart';
import 'package:sharezone_widgets/widgets.dart';

Future<void> showThankYouBottomSheet(BuildContext context) async {
  await showModalBottomSheet(
    context: context,
    builder: (context) => ThankYouBottomSheetChild(),
  );
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
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: SafeArea(
        child: Column(
          children: <Widget>[
            Align(
              alignment: Alignment.centerRight,
              child: CloseIconButton(),
            ),
            PlatformSvg.asset(
              'assets/icons/thumbs_up.svg',
              width: 120,
              height: 120,
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                "Vielen Dank für dein Feedback!",
                style: Theme.of(context).textTheme.headline5,
                textAlign: TextAlign.center,
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: Text.rich(
                TextSpan(
                  children: <TextSpan>[
                    TextSpan(
                        text:
                            "Dir gefällt unsere App? Dann würden wir uns über eine Bewertung im "),
                    TextSpan(
                        text: (PlatformCheck.isIOS || PlatformCheck.isMacOS)
                            ? "AppStore"
                            : "PlayStore",
                        style: linkStyle(context, 16),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            logOpenRating(context);
                            launchURL(
                                (PlatformCheck.isIOS || PlatformCheck.isMacOS)
                                    ? "https://sharezone.net/ios"
                                    : "https://sharezone.net/android");
                          }),
                    TextSpan(
                      text: " riesig freuen! 😄",
                    ),
                  ],
                  style: TextStyle(color: Colors.grey, fontSize: 16),
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
