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
  const _Advantages();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: <Widget>[
              SizedBox(
                height: 100,
                child: SvgPicture.asset(
                  "assets/icons/strong.svg",
                  fit: BoxFit.fitHeight,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                context.l10n.signUpAdvantagesTitle,
                style: const TextStyle(fontSize: 26),
              ),
              MaxWidthConstraintBox(
                maxWidth: 650,
                child: Column(
                  children: AnimationConfiguration.toStaggeredList(
                    delay: const Duration(milliseconds: 100),
                    duration: const Duration(milliseconds: 1000),
                    childAnimationBuilder:
                        (widget) => SlideAnimation(
                          verticalOffset: 20,
                          child: FadeInAnimation(child: widget),
                        ),
                    children: const [
                      _AdvantageAllInOne(),
                      _AdvantageCloud(),
                      _AdvantageSaveTime(),
                      _AdvantageNotifications(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const OnboardingNavigationBar(
        action: _SignUpButton(),
      ),
    );
  }
}

class _AdvantageAllInOne extends StatelessWidget {
  const _AdvantageAllInOne();

  @override
  Widget build(BuildContext context) {
    return _AdvancedListTile(
      title: context.l10n.signUpAdvantageAllInOne,
      leading: SvgPicture.asset('assets/icons/smartphone.svg', height: 45),
    );
  }
}

class _AdvantageCloud extends StatelessWidget {
  const _AdvantageCloud();

  @override
  Widget build(BuildContext context) {
    return _AdvancedListTile(
      title: context.l10n.signUpAdvantageCloud,
      leading: SvgPicture.asset('assets/icons/cloud.svg', height: 45),
    );
  }
}

class _AdvantageSaveTime extends StatelessWidget {
  const _AdvantageSaveTime();

  @override
  Widget build(BuildContext context) {
    return _AdvancedListTile(
      title: context.l10n.signUpAdvantageSaveTime,
      leading: const EasterEggClock(dimension: 45),
    );
  }
}

class _AdvantageNotifications extends StatelessWidget {
  const _AdvantageNotifications();

  @override
  Widget build(BuildContext context) {
    return _AdvancedListTile(
      title: context.l10n.signUpAdvantageHomeworkReminder,
      leading: const SizedBox(
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
