// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:sharezone/auth/login_page.dart';
import 'package:sharezone/keys.dart';
import 'package:sharezone/onboarding/sign_up/sign_up_page.dart';
import 'package:sharezone_widgets/sharezone_widgets.dart';

class MobileWelcomePage extends StatelessWidget {
  const MobileWelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Color(0xFFE7EBED),
      body: Stack(
        children: [
          _BackgroundImage(),
          _Bottom(),
        ],
      ),
    );
  }
}

class _BackgroundImage extends StatelessWidget {
  const _BackgroundImage();

  @override
  Widget build(BuildContext context) {
    final isTablet = MediaQuery.of(context).size.shortestSide >= 600;
    final isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;
    return Positioned.fill(
      child: Stack(
        children: [
          Align(
            alignment: Alignment.topCenter,
            child: Image.asset(
              'assets/images/welcome-page-background.png',
              fit: BoxFit.cover,
              height:
                  MediaQuery.of(context).size.height * (isTablet ? 0.9 : 0.8),
              semanticLabel:
                  'Hintergrundbild der Willkommens-Seite mit 5 Handys, die die Sharezone-App zeigen.',
            ),
          ),
          Positioned.fill(
            child: Container(
              // Add white (bottom) to transparent (top) gradient that is placed at
              // the bottom of the screen. It should have a height of 30% of the
              // screen height.
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    Colors.white,
                    // We shouldn't use `Colors.transparent` here, because it
                    // will destroy the gradient effect.
                    Colors.white.withOpacity(0.0),
                  ],
                  stops: [
                    if (isTablet) isPortrait ? 0.15 : 0.22 else 0.3,
                    0.5,
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Bottom extends StatelessWidget {
  const _Bottom();

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: DefaultTextStyle.merge(
            textAlign: TextAlign.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: AnimationConfiguration.toStaggeredList(
                duration: const Duration(milliseconds: 1250),
                childAnimationBuilder: (widget) => SlideAnimation(
                  verticalOffset: 20,
                  child: FadeInAnimation(child: widget),
                ),
                children: const [
                  _Headline(),
                  _SubHeadline(),
                  _NewAtSharezoneButton(),
                  _AlreadyHaveAnAccountButton(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _Headline extends StatelessWidget {
  const _Headline();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.only(bottom: 4),
      child: Text(
        'Gemeinsam den\nSchulalltag organisieren 🚀',
        style: TextStyle(
          fontSize: 22,
          height: 1.1,
          color: Colors.black,
        ),
      ),
    );
  }
}

class _SubHeadline extends StatelessWidget {
  const _SubHeadline();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.only(bottom: 20),
      child: Text(
        'Optional kannst du Sharezone auch komplett alleine verwenden.',
        style: TextStyle(
          color: Colors.grey,
          fontSize: 12,
        ),
      ),
    );
  }
}

class _NewAtSharezoneButton extends StatelessWidget {
  const _NewAtSharezoneButton();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: _BaseButton(
        text: const Text(
          'Ich bin neu bei Sharezone 👋',
          textAlign: TextAlign.center,
        ),
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const SignUpPage(
              withLogin: false,
              withBackButton: true,
            ),
            settings: const RouteSettings(name: SignUpPage.tag),
          ),
        ),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
      ),
    );
  }
}

class _AlreadyHaveAnAccountButton extends StatelessWidget {
  const _AlreadyHaveAnAccountButton();

  @override
  Widget build(BuildContext context) {
    return _BaseButton(
      key: K.goToLoginButton,
      text: const Column(
        children: [
          Text(
            'Anmelden',
            style: TextStyle(
              fontSize: 18,
              color: Colors.black,
            ),
          ),
          Text(
            'Mit existierendem Konto anmelden',
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey,
            ),
          ),
        ],
      ),
      onPressed: () => Navigator.pushNamed(context, LoginPage.tag),
      foregroundColor: Colors.grey,
      backgroundColor: Colors.white,
      borderSide: BorderSide(
        color: Colors.grey[300]!,
        width: 1,
      ),
    );
  }
}

class _BaseButton extends StatelessWidget {
  const _BaseButton({
    super.key,
    required this.text,
    required this.onPressed,
    required this.backgroundColor,
    required this.foregroundColor,
    this.borderSide = BorderSide.none,
  });

  final Widget text;
  final VoidCallback onPressed;
  final BorderSide borderSide;
  final Color backgroundColor;
  final Color foregroundColor;

  @override
  Widget build(BuildContext context) {
    const textStyle = TextStyle(
      fontWeight: FontWeight.normal,
      fontSize: 18,
    );
    return ConstrainedBox(
      constraints: BoxConstraints(
        minWidth:
            MediaQuery.of(context).textScaler.scale(textStyle.fontSize!) * 18,
        minHeight:
            MediaQuery.of(context).textScaler.scale(textStyle.fontSize!) * 3.2,
      ),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: borderSide,
          ),
          foregroundColor: foregroundColor,
          backgroundColor: backgroundColor,
          textStyle: textStyle,
          elevation: 0,
          shadowColor: Colors.transparent,
        ),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: DefaultTextStyle.merge(
            // Even though the text is already centered with `DefaultTextStyle`
            // of the `_Bottom` widget`, we need to set `textAlign` to `center`
            // here, because otherwise the text will be aligned to the left.
            textAlign: TextAlign.center,
            child: text,
            style: const TextStyle(
              // For the golden tests we need to set the font family again,
              // because otherwise 'Ahem' will be used.
              //
              // Can be removed when the following bug is resolved:
              // https://github.com/eBay/flutter_glove_box/issues/103.
              fontFamily: rubik,
            ),
          ),
        ),
      ),
    );
  }
}
