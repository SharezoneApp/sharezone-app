// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:bloc_provider/bloc_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:sharezone/onboarding/group_onboarding/logic/group_onboarding_bloc.dart';
import 'package:sharezone/onboarding/group_onboarding/widgets/title.dart';
import 'package:sharezone_common/helper_functions.dart';
import 'package:sharezone_widgets/sharezone_widgets.dart';

class GroupOnboardingPageTemplate extends StatelessWidget {
  const GroupOnboardingPageTemplate({
    Key key,
    this.title,
    this.children = const [],
    this.bottomNavigationBar,
    this.padding = const EdgeInsets.all(8),
    this.top,
    this.topPadding = 60,
  }) : super(key: key);

  final String title;
  final List<Widget> children;
  final Widget bottomNavigationBar;
  final EdgeInsets padding;
  final Widget top;
  final double topPadding;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: MaxWidthConstraintBox(
          child: Stack(
            children: [
              Align(
                  alignment: Alignment.topCenter, child: top ?? _SkipButton()),
              Padding(
                padding: EdgeInsets.only(top: topPadding),
                child: Center(
                  child: SingleChildScrollView(
                    padding: padding,
                    child: AnimationLimiter(
                      child: Column(
                        children: AnimationConfiguration.toStaggeredList(
                          childAnimationBuilder: (widget) => SlideAnimation(
                            verticalOffset: 25,
                            child: FadeInAnimation(child: widget),
                          ),
                          children: [
                            if (isNotEmptyOrNull(title))
                              GroupOnboardingTitle(title),
                            SizedBox(height: 12),
                            ...children
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
      bottomNavigationBar: bottomNavigationBar,
    );
  }
}

class _SkipButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<GroupOnboardingBloc>(context);
    return TextButton(
      onPressed: () {
        bloc.skipOnboarding();
        Navigator.popUntil(context, ModalRoute.withName('/'));
      },
      style: TextButton.styleFrom(
        foregroundColor: Theme.of(context).primaryColor,
      ),
      child: Text("Überspringen".toUpperCase()),
    );
  }
}
