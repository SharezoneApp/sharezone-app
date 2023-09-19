// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

part of '../sign_up_page.dart';

/// Shows the user the advantages of sharezone. This page is basically
/// designed for students.
class _Advantages extends StatelessWidget {
  const _Advantages({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: AnimationLimiter(
            child: Column(
              children: AnimationConfiguration.toStaggeredList(
                duration: const Duration(milliseconds: 300),
                childAnimationBuilder: (widget) => SlideAnimation(
                  verticalOffset: 20,
                  child: FadeInAnimation(child: widget),
                ),
                children: <Widget>[
                  SizedBox(
                    height: 100,
                    child: PlatformSvg.asset(
                      "assets/icons/strong.svg",
                      fit: BoxFit.fitHeight,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text("Vorteile von Sharezone",
                      style: TextStyle(fontSize: 26)),
                  const _AdvantageAllInOne(),
                  const _AdvantageCloud(),
                  const _AdvantageSaveTime(),
                  const _AdvantageNotifications(),
                ],
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: const OnboardingNavigationBar(
        action: OnboardingNavigationBarContinueButton(
          nextPage: _PrivacyPolicy(),
          nextTag: _PrivacyPolicy.tag,
        ),
      ),
    );
  }
}

class _AdvantageAllInOne extends StatelessWidget {
  const _AdvantageAllInOne({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _AdvancedListTile(
      title: "All-In-One-App für die Schule",
      leading: PlatformSvg.asset('assets/icons/smartphone.svg', height: 45),
    );
  }
}

class _AdvantageCloud extends StatelessWidget {
  const _AdvantageCloud({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _AdvancedListTile(
      title: "Schulplaner über die Cloud mit der Klasse teilen",
      leading: PlatformSvg.asset('assets/icons/cloud.svg', height: 45),
    );
  }
}

class _AdvantageSaveTime extends StatelessWidget {
  const _AdvantageSaveTime({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _AdvancedListTile(
      title: "Große Zeitersparnis durch gemeinsames organisieren",
      leading: PlatformSvg.asset('assets/icons/clock.svg', height: 45),
    );
  }
}

class _AdvantageNotifications extends StatelessWidget {
  const _AdvantageNotifications({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const _AdvancedListTile(
      title: "Erinnerungen an offene Hausaufgaben",
      leading: SizedBox(
        height: 45,
        width: 45,
        child: FlareActor(
          "assets/flare/notification-animation.flr",
          animation: "Notification",
          fit: BoxFit.fitHeight,
        ),
      ),
    );
  }
}
