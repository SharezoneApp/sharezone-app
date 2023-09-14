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
  const _DataProtectionOverview({Key? key}) : super(key: key);

  static const tag = 'onboarding-data-protection-overivew';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: SafeArea(
            child: AnimationLimiter(
              child: Column(
                children: AnimationConfiguration.toStaggeredList(
                  duration: const Duration(milliseconds: 300),
                  childAnimationBuilder: (widget) => SlideAnimation(
                    verticalOffset: 20,
                    child: FadeInAnimation(child: widget),
                  ),
                  children: const <Widget>[
                    _DataProtectionLockAnimation(),
                    SizedBox(height: 10),
                    Text("Datenschutz", style: TextStyle(fontSize: 26)),
                    _DataProtectionServerLocation(),
                    _DataProtectionTLS(),
                    _DataProtectionAES(),
                    _DataProtectionAnonymousSignIn(),
                    _DataProtectionISO(),
                    _DataProtectionSOC(),
                    _DataProtectionDeleteData(),
                  ],
                ),
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

class _DataProtectionLockAnimation extends StatelessWidget {
  const _DataProtectionLockAnimation({Key? key}) : super(key: key);

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
  const _DataProtectionServerLocation({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _AdvancedListTile.dataProtection(
      title: "Standort der Server: Frankfurt (Deutschland)",
      subtitle: "Mit Ausnahme des Authentifizierungs-Server",
    );
  }
}

class _DataProtectionTLS extends StatelessWidget {
  const _DataProtectionTLS({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _AdvancedListTile.dataProtection(
      title: "TLS-Verschlüsselung bei der Übertragung",
    );
  }
}

class _DataProtectionAES extends StatelessWidget {
  const _DataProtectionAES({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _AdvancedListTile.dataProtection(
      title: "AES 256-Bit serverseitige Verschlüsselung",
    );
  }
}

class _DataProtectionAnonymousSignIn extends StatelessWidget {
  const _DataProtectionAnonymousSignIn({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _AdvancedListTile.dataProtection(
      title: "Anmeldung ohne personenbezogene Daten",
      subtitle: "IP-Adresse wird zwangsläufig temporär gespeichert",
    );
  }
}

class _DataProtectionISO extends StatelessWidget {
  const _DataProtectionISO({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _AdvancedListTile.dataProtection(
      title: "ISO27001, ISO27012 & ISO27018 zertifiziert*",
    );
  }
}

class _DataProtectionSOC extends StatelessWidget {
  const _DataProtectionSOC({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _AdvancedListTile.dataProtection(
      title: "SOC1, SOC2, & SOC3 zertifiziert*",
      subtitle: "* Zertifizierung von unserem Hosting-Anbieter",
    );
  }
}

class _DataProtectionDeleteData extends StatelessWidget {
  const _DataProtectionDeleteData({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _AdvancedListTile.dataProtection(
      title: "Einfaches Löschen der Daten",
    );
  }
}
