// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

part of '../sign_up_page.dart';

class ChooseTypeOfUser extends StatelessWidget {
  const ChooseTypeOfUser({
    Key key,
    this.withLogin = true,
    this.withBackButton = false,
  }) : super(key: key);

  static const tag = 'choose-type-of-user-page';

  final bool withLogin;
  final bool withBackButton;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          MaxWidthConstraintBox(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: SafeArea(
                  child: AnimationLimiter(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 48),
                      child: Column(
                        children: <Widget>[
                          Text("Ich bin...",
                              style: Theme.of(context).textTheme.headlineSmall),
                          const SizedBox(height: 12),
                          typeOfUserButtons(context),
                          if (withLogin) ...[
                            const Divider(height: 46),
                            _LoginButton(
                                key: const ValueKey('go-to-login-button-E2E')),
                          ]
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding:
                EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.12),
            child: Align(
              alignment: Alignment.topCenter,
              child: SharezoneLogo(
                logoColor: LogoColor.blue_short,
                height: 50,
                width: 150,
              ),
            ),
          )
        ],
      ),
      bottomNavigationBar: withBackButton ? OnboardingNavigationBar() : null,
    );
  }

  Widget typeOfUserButtons(BuildContext context) {
    final hasLowWidth = MediaQuery.of(context).size.width < 350;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: hasLowWidth
          ? Column(
              children: const <Widget>[
                _StudentNew(),
                SizedBox(height: 12),
                _TeacherNew(),
                SizedBox(height: 12),
                _ParentsNew(),
              ],
            )
          : Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const <Widget>[
                Expanded(
                  child: _StudentNew(),
                ),
                SizedBox(width: 4),
                Expanded(
                  child: _TeacherNew(),
                ),
                SizedBox(width: 4),
                Expanded(
                  child: _ParentsNew(),
                ),
              ],
            ),
    );
  }
}

class _StudentNew extends StatelessWidget {
  const _StudentNew({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _TypeOfUserTileNew(
      typeOfUser: TypeOfUser.student,
      iconSvgPath: "assets/icons/students.svg",
    );
  }
}

class _TeacherNew extends StatelessWidget {
  const _TeacherNew({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _TypeOfUserTileNew(
      typeOfUser: TypeOfUser.teacher,
      iconSvgPath: "assets/icons/professor.svg",
    );
  }
}

class _ParentsNew extends StatelessWidget {
  const _ParentsNew({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _TypeOfUserTileNew(
      typeOfUser: TypeOfUser.parent,
      iconSvgPath: "assets/icons/parents.svg",
    );
  }
}

class _TypeOfUserTileNew extends StatelessWidget {
  final TypeOfUser typeOfUser;
  final String iconSvgPath;

  const _TypeOfUserTileNew({
    Key key,
    this.typeOfUser,
    this.iconSvgPath,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomCard(
      onTap: () {
        final bloc = BlocProvider.of<RegistrationBloc>(context);
        bloc.setTypeOfUser(typeOfUser);

        if (_isStudent()) {
          Navigator.push(
            context,
            FadeRoute(
              child: _Advantages(),
              tag: _DataProtectionOverview.tag,
            ),
          );
        } else {
          Navigator.push(
            context,
            FadeRoute(
              child: _DataProtectionOverview(),
              tag: _DataProtectionOverview.tag,
            ),
          );
        }
      },
      padding: const EdgeInsets.all(12),
      child: getChild(context),
    );
  }

  Widget getChild(BuildContext context) {
    // Smalls Smartphones (e.g. iPhone SE)
    final hasLowWidth = MediaQuery.of(context).size.width < 350;

    // Very small devices (e.g. Smartwatch)
    final hasExtremplyLowWidth = MediaQuery.of(context).size.width < 250;

    if (hasLowWidth) {
      if (hasExtremplyLowWidth) {
        return Padding(
          padding: const EdgeInsets.all(4),
          child: PlatformSvg.asset(
            iconSvgPath,
            width: 45,
            height: 45,
          ),
        );
      } else {
        return ListTile(
          leading: PlatformSvg.asset(
            iconSvgPath,
            width: 45,
            height: 45,
          ),
          title: Text(
            typeOfUser.toReadableString(),
            textAlign: TextAlign.center,
          ),
        );
      }
    } else {
      return Column(
        children: <Widget>[
          PlatformSvg.asset(
            iconSvgPath,
            width: 60,
            height: 60,
          ),
          const SizedBox(height: 8),
          Text(
            typeOfUser.toReadableString(),
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16),
          )
        ],
      );
    }
  }

  bool _isStudent() => typeOfUser == TypeOfUser.student;
}

class _LoginButton extends StatelessWidget {
  const _LoginButton({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: TextButton(
        style: TextButton.styleFrom(
          foregroundColor: Colors.grey,
        ),
        onPressed: () => Navigator.pushNamed(context, LoginPage.tag),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: const Text(
            "Du hast bereits ein Konto? Klicke hier, um dich einzuloggen.",
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
