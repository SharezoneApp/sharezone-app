// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:bloc_provider/bloc_provider.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:sharezone/auth/login_page.dart';
import 'package:sharezone/keys.dart';
import 'package:sharezone/onboarding/bloc/registration_bloc.dart';
import 'package:sharezone/onboarding/group_onboarding/widgets/bottom_bar_button.dart';
import 'package:sharezone/privacy_policy/privacy_policy_page.dart';
import 'package:sharezone/widgets/animation/color_fade_in.dart';
import 'package:sharezone_common/api_errors.dart';
import 'package:sharezone_widgets/sharezone_widgets.dart';
import 'package:user/user.dart';

part 'pages/advantages.dart';
part 'pages/choose_type_of_user.dart';
part 'pages/data_protection_overview.dart';
part 'pages/privacy_policy.dart';

class SignUpPage extends StatefulWidget {
  static const tag = 'sign-up-page';

  const SignUpPage({
    super.key,
    this.withLogin = true,
    this.withBackButton = false,
  });

  final bool withLogin;
  final bool withBackButton;

  @override
  State createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  Widget child = Container();

  bool isWidgetDisposed = false;
  @override
  void initState() {
    super.initState();

    // Animating to ChooseTypeOfUser-Page
    Future.delayed(const Duration(milliseconds: 350))
        .then((_) => isWidgetDisposed
            ? null
            : setState(() {
                child = ChooseTypeOfUser(
                  withBackButton: widget.withBackButton,
                  withLogin: widget.withLogin,
                );
              }));
  }

  @override
  void dispose() {
    super.dispose();
    isWidgetDisposed = true;
  }

  @override
  Widget build(BuildContext context) {
    return ColorFadeIn(
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 175),
        transitionBuilder: (widget, animation) {
          return ScaleTransition(
            scale: animation.drive(Tween<double>(begin: 0.925, end: 1)
                .chain(CurveTween(curve: Curves.easeOutQuint))),
            child: FadeTransition(
              opacity: animation,
              child: widget,
            ),
          );
        },
        child: Material(
          color: Colors.white,
          key: ValueKey(child),
          child: child,
        ),
      ),
    );
  }
}

class _AdvancedListTile extends StatelessWidget {
  const _AdvancedListTile({
    required this.title,
    this.subtitle,
    this.leading,
  });

  factory _AdvancedListTile.dataProtection({
    required String title,
    String? subtitle,
  }) {
    return _AdvancedListTile(
      leading: PlatformSvg.asset("assets/icons/correct.svg", height: 40),
      title: title,
      subtitle: subtitle,
    );
  }

  final Widget? leading;
  final String title;
  final String? subtitle;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Padding(
      padding: EdgeInsets.only(left: width > 720 ? width * 0.125 : 0, top: 16),
      child: ListTile(
        leading: leading,
        title: Text(title, style: const TextStyle(fontSize: 22)),
        subtitle: subtitle == null ? null : Text(subtitle!),
      ),
    );
  }
}

class OnboardingNavigationBar extends StatelessWidget {
  const OnboardingNavigationBar({
    super.key,
    this.action,
  });

  final Widget? action;

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        buttonTheme: const ButtonThemeData(textTheme: ButtonTextTheme.primary),
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const Divider(height: 0),
            MaxWidthConstraintBox(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    IconButton(
                      icon: const Icon(Icons.chevron_left),
                      onPressed: () => Navigator.pop(context),
                      tooltip: 'Zurück',
                      color: Colors.grey,
                    ),
                    if (action != null) action!,
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class OnboardingNavigationBarContinueButton extends StatelessWidget {
  const OnboardingNavigationBarContinueButton({
    super.key,
    required this.nextPage,
    required this.nextTag,
  });

  /// Dieses Widget wird angezeigt, sobald der Weiter-Button gedrückt wird.
  final Widget nextPage;

  /// Dies ist der Tag der nächsten Page.
  final String nextTag;

  @override
  Widget build(BuildContext context) {
    return BottomBarButton(
      text: "Weiter",
      onTap: () =>
          Navigator.push(context, FadeRoute(child: nextPage, tag: nextTag)),
    );
  }
}
