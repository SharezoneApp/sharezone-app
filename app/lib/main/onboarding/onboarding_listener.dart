import 'package:bloc_provider/bloc_provider.dart';
import 'package:flutter/material.dart';
import 'package:sharezone/onboarding/group_onboarding/pages/choose_name.dart';

import 'onboarding_navigator.dart';

class OnboardingListener extends StatelessWidget {
  final Widget child;

  const OnboardingListener({Key key, this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final onboardingNavigator = BlocProvider.of<OnboardingNavigator>(context);
    return StreamBuilder<bool>(
      stream: onboardingNavigator.showOnboarding,
      builder: (context, snapshot) {
        if (snapshot.data ?? false) return OnboardingChangeName();
        return child;
      },
    );
  }
}
