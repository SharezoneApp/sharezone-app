// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

part of '../sign_up_page.dart';

class _PrivacyPolicy extends StatelessWidget {
  const _PrivacyPolicy({Key key}) : super(key: key);

  static const tag = 'onboarding-privacy-policy';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SafeArea(
          child: PrivacyPolicyPage(
            // Since we have the navigation bar at the bottom we don't want a
            // second back button somewhere on the page.
            showBackButton: false,
          ),
        ),
      ),
      bottomNavigationBar: OnboardingNavigationBar(action: _ContinueButton()),
    );
  }
}

class _ContinueButton extends StatefulWidget {
  const _ContinueButton({Key key}) : super(key: key);

  @override
  _ContinueButtonState createState() => _ContinueButtonState();
}

class _ContinueButtonState extends State<_ContinueButton> {
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: TextButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor: Theme.of(context).primaryColor,
        disabledForegroundColor:
            Theme.of(context).primaryColor.withOpacity(0.38),
      ),
      child: Stack(
        key: const ValueKey('SubmitButton'),
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
            child: isLoading
                ? Padding(
                    padding: const EdgeInsets.only(top: 2, left: 58),
                    child: SizedBox(
                      height: 20,
                      width: 20,
                      child: Theme(
                        data: ThemeData(
                            colorScheme: ColorScheme.fromSwatch()
                                .copyWith(secondary: Colors.white)),
                        child: CircularProgressIndicator(),
                      ),
                    ),
                  )
                : Container(),
          )
        ],
      ),
      onPressed: isLoading
          ? null
          : () async {
              final bloc = BlocProvider.of<RegistrationBloc>(context);
              try {
                setState(() => isLoading = true);
                await bloc.signUp();
                Navigator.popUntil(context, ModalRoute.withName('/'));
              } catch (e, s) {
                setState(() => isLoading = false);
                showSnackSec(
                  text: handleErrorMessage(e.toString(), s),
                  context: context,
                );
              }
            },
    );
  }
}
