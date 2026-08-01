// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

part of '../sign_up_page.dart';

/// Shows the user a quick overview of the privacy policy. This page is
/// basically designed for teacher and parents.
class _DataProtectionOverview extends StatelessWidget {
  const _DataProtectionOverview();

  static const tag = 'onboarding-data-protection-overivew';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: SafeArea(
            child: Column(
              children: [
                const _DataProtectionLockAnimation(),
                const SizedBox(height: 10),
                Text(
                  context.l10n.signUpDataProtectionTitle,
                  style: const TextStyle(fontSize: 26),
                ),
                MaxWidthConstraintBox(
                  maxWidth: 600,
                  child: Column(
                    children: AnimationConfiguration.toStaggeredList(
                      delay: const Duration(milliseconds: 100),
                      duration: const Duration(milliseconds: 1000),
                      childAnimationBuilder:
                          (widget) => SlideAnimation(
                            verticalOffset: 20,
                            child: FadeInAnimation(child: widget),
                          ),
                      children: [
                        const _DataProtectionServerLocation(),
                        const _DataProtectionTLS(),
                        const _DataProtectionAES(),
                        const _DataProtectionAnonymousSignIn(),
                        const _DataProtectionISO(),
                        const _DataProtectionSOC(),
                        const _DataProtectionDeleteData(),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: const OnboardingNavigationBar(
        action: _SignUpButton(),
      ),
    );
  }
}

class _DataProtectionLockAnimation extends StatelessWidget {
  const _DataProtectionLockAnimation();

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      height: 150,
      child: FlareActor(
        "assets/flare/privacy.flr",
        animation: "Lock",
        fit: BoxFit.fitHeight,
      ),
    );
  }
}

class _DataProtectionServerLocation extends StatelessWidget {
  const _DataProtectionServerLocation();

  @override
  Widget build(BuildContext context) {
    return _AdvancedListTile.dataProtection(
      title: context.l10n.signUpDataProtectionServerLocationTitle,
      subtitle: context.l10n.signUpDataProtectionServerLocationSubtitle,
    );
  }
}

class _DataProtectionTLS extends StatelessWidget {
  const _DataProtectionTLS();

  @override
  Widget build(BuildContext context) {
    return _AdvancedListTile.dataProtection(
      title: context.l10n.signUpDataProtectionTlsTitle,
    );
  }
}

class _DataProtectionAES extends StatelessWidget {
  const _DataProtectionAES();

  @override
  Widget build(BuildContext context) {
    return _AdvancedListTile.dataProtection(
      title: context.l10n.signUpDataProtectionAesTitle,
    );
  }
}

class _DataProtectionAnonymousSignIn extends StatelessWidget {
  const _DataProtectionAnonymousSignIn();

  @override
  Widget build(BuildContext context) {
    return _AdvancedListTile.dataProtection(
      title: context.l10n.signUpDataProtectionAnonymousSignInTitle,
      subtitle: context.l10n.signUpDataProtectionAnonymousSignInSubtitle,
    );
  }
}

class _DataProtectionISO extends StatelessWidget {
  const _DataProtectionISO();

  @override
  Widget build(BuildContext context) {
    return _AdvancedListTile.dataProtection(
      title: context.l10n.signUpDataProtectionIsoTitle,
    );
  }
}

class _DataProtectionSOC extends StatelessWidget {
  const _DataProtectionSOC();

  @override
  Widget build(BuildContext context) {
    return _AdvancedListTile.dataProtection(
      title: context.l10n.signUpDataProtectionSocTitle,
      subtitle: context.l10n.signUpDataProtectionSocSubtitle,
    );
  }
}

class _DataProtectionDeleteData extends StatelessWidget {
  const _DataProtectionDeleteData();

  @override
  Widget build(BuildContext context) {
    return _AdvancedListTile.dataProtection(
      title: context.l10n.signUpDataProtectionDeleteDataTitle,
    );
  }
}
