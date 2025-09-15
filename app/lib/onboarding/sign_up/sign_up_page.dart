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
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:sharezone/auth/login_page.dart';
import 'package:sharezone/keys.dart';
import 'package:sharezone/legal/privacy_policy/privacy_policy_page.dart';
import 'package:sharezone/legal/terms_of_service/terms_of_service_page.dart';
import 'package:sharezone/onboarding/bloc/registration_bloc.dart';
import 'package:sharezone/onboarding/group_onboarding/widgets/bottom_bar_button.dart';
import 'package:sharezone/onboarding/sign_up/widgets/easter_egg_clock.dart';
import 'package:sharezone/widgets/animation/color_fade_in.dart';
import 'package:sharezone_common/api_errors.dart';
import 'package:sharezone_widgets/sharezone_widgets.dart';
import 'package:user/user.dart';

part 'pages/advantages.dart';
part 'pages/choose_type_of_user.dart';
part 'pages/data_protection_overview.dart';

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
    Future.delayed(const Duration(milliseconds: 350)).then(
      (_) =>
          isWidgetDisposed
              ? null
              : setState(() {
                child = ChooseTypeOfUser(
                  withBackButton: widget.withBackButton,
                  withLogin: widget.withLogin,
                );
              }),
    );
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
            scale: animation.drive(
              Tween<double>(
                begin: 0.925,
                end: 1,
              ).chain(CurveTween(curve: Curves.easeOutQuint)),
            ),
            child: FadeTransition(opacity: animation, child: widget),
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
  const _AdvancedListTile({required this.title, this.subtitle, this.leading});

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
    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: ListTile(
        leading: leading,
        title: Text(title, style: const TextStyle(fontSize: 22)),
        subtitle: subtitle == null ? null : Text(subtitle!),
      ),
    );
  }
}

class OnboardingNavigationBar extends StatelessWidget {
  const OnboardingNavigationBar({super.key, this.action});

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
      onTap:
          () =>
              Navigator.push(context, FadeRoute(child: nextPage, tag: nextTag)),
    );
  }
}

class _SignUpButton extends StatefulWidget {
  const _SignUpButton();

  @override
  _SignUpButtonState createState() => _SignUpButtonState();
}

class _SignUpButtonState extends State<_SignUpButton> {
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: TextButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor: Theme.of(context).primaryColor,
        disabledForegroundColor: Theme.of(
          context,
        ).primaryColor.withValues(alpha: 0.38),
      ),
      onPressed:
          isLoading
              ? null
              : () async {
                final bloc = BlocProvider.of<RegistrationBloc>(context);
                try {
                  setState(() => isLoading = true);
                  await bloc.signUp();
                  if (!context.mounted) return;
                  Navigator.popUntil(context, ModalRoute.withName('/'));
                } catch (e, s) {
                  setState(() => isLoading = false);
                  showSnackSec(
                    text: handleErrorMessage(e.toString(), s),
                    context: context,
                  );
                }
              },
      child: Stack(
        key: const ValueKey('SubmitButton'),
        alignment: Alignment.center,
        children: [
          Text(
            "Weiter".toUpperCase(),
            style: TextStyle(
              fontSize: 20,
              color: isLoading ? Colors.transparent : Colors.white,
            ),
          ),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 275),
            child:
                isLoading
                    ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(color: Colors.white),
                    )
                    : Container(),
          ),
        ],
      ),
    );
  }
}
