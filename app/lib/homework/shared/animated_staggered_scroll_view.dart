// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:provider/provider.dart';
import 'package:sharezone/homework/shared/bottom_of_scrollview_visibility.dart';

class AnimatedStaggeredScrollView extends StatelessWidget {
  final List<Widget> children;
  final CrossAxisAlignment? crossAxisAlignment;

  const AnimatedStaggeredScrollView(
      {Key? key, required this.children, this.crossAxisAlignment})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    final scrollController = ScrollController();
    // Used for hiding the FAB if the User is at the bottom of the scroll view;
    Provider.of<BottomOfScrollViewInvisibilityController>(context)
        .registeredScrollController = scrollController;

    return SingleChildScrollView(
      controller: scrollController,
      child: Column(
        crossAxisAlignment: crossAxisAlignment ?? CrossAxisAlignment.start,
        children: AnimationConfiguration.toStaggeredList(
          duration: const Duration(milliseconds: 350),
          childAnimationBuilder: (widget) => SlideAnimation(
            horizontalOffset: 25,
            child: FadeInAnimation(child: widget),
          ),
          children: children,
        ),
      ),
    );
  }
}
