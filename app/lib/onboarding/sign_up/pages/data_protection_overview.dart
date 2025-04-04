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
                const Text("Datenschutz", style: TextStyle(fontSize: 26)),
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
      title: "Standort der Server: Frankfurt (Deutschland)",
      subtitle: "Mit Ausnahme des Authentifizierungs-Server",
    );
  }
}

class _DataProtectionTLS extends StatelessWidget {
  const _DataProtectionTLS();

  @override
  Widget build(BuildContext context) {
    return _AdvancedListTile.dataProtection(
      title: "TLS-Verschlüsselung bei der Übertragung",
    );
  }
}

class _DataProtectionAES extends StatelessWidget {
  const _DataProtectionAES();

  @override
  Widget build(BuildContext context) {
    return _AdvancedListTile.dataProtection(
      title: "AES 256-Bit serverseitige Verschlüsselung",
    );
  }
}

class _DataProtectionAnonymousSignIn extends StatelessWidget {
  const _DataProtectionAnonymousSignIn();

  @override
  Widget build(BuildContext context) {
    return _AdvancedListTile.dataProtection(
      title: "Anmeldung ohne personenbezogene Daten",
      subtitle: "IP-Adresse wird zwangsläufig temporär gespeichert",
    );
  }
}

class _DataProtectionISO extends StatelessWidget {
  const _DataProtectionISO();

  @override
  Widget build(BuildContext context) {
    return _AdvancedListTile.dataProtection(
      title: "ISO27001, ISO27012 & ISO27018 zertifiziert*",
    );
  }
}

class _DataProtectionSOC extends StatelessWidget {
  const _DataProtectionSOC();

  @override
  Widget build(BuildContext context) {
    return _AdvancedListTile.dataProtection(
      title: "SOC1, SOC2, & SOC3 zertifiziert*",
      subtitle: "* Zertifizierung von unserem Hosting-Anbieter",
    );
  }
}

class _DataProtectionDeleteData extends StatelessWidget {
  const _DataProtectionDeleteData();

  @override
  Widget build(BuildContext context) {
    return _AdvancedListTile.dataProtection(
      title: "Einfaches Löschen der Daten",
    );
  }
}
