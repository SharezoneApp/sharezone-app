// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:flutter/material.dart' hide VerticalDivider;
import 'package:sharezone/auth/login_page.dart';
import 'package:sharezone/onboarding/mobile_welcome_page.dart';
import 'package:platform_check/platform_check.dart';

import 'sign_up/sign_up_page.dart';

/// Die [WelcomePage] ist die erste Page, die der Nutzer sieht. Bei der mobilen
/// Version wird der Fokus mehr auf die Registrierung gelegt, weswegen direkt die
/// [SignUpPage] angezeigt wird. Bei der Desktop- / Web-App liegt der Fokus mehr
/// bei dem Login, weil davon ausgegangen wird, dass sich die meisten Nutzer über die
/// mobile Version registrieren.
class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    if (PlatformCheck.isDesktopOrWeb) return const LoginPage.desktop();
    return const MobileWelcomePage();
  }
}
