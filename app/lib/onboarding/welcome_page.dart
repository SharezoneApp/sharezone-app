import 'package:flutter/material.dart' hide VerticalDivider;
import 'package:sharezone/auth/login_page.dart';
import 'package:sharezone_utils/platform.dart';
import 'sign_up/sign_up_page.dart';

/// Die [WelcomePage] ist die erste Page, die der Nutzer sieht. Bei der mobilen
/// Version wird der Fokus mehr auf die Registrierung gelegt, weswegen direkt die
/// [SignUpPage] angezeigt wird. Bei der Desktop- / Web-App liegt der Fokus mehr
/// bei dem Login, weil davon ausgegangen wird, dass sich die meisten Nutzer über die
/// mobile Version registrieren.
class WelcomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    if (PlatformCheck.isDesktopOrWeb) return LoginPage.desktop();
    return SignUpPage(withLogin: true, withBackButton: false);
  }
}
