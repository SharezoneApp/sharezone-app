// Copyright (c) 2023 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_svg/svg.dart';
import 'package:sharezone_website/widgets/section.dart';

import '../../main.dart';
import '../home_page.dart';

class Welcome extends StatelessWidget {
  const Welcome({super.key});

  @override
  Widget build(BuildContext context) {
    final height =
        MediaQuery.of(context).size.height * (isTablet(context) ? 0.05 : 0.1);
    return Section(
      child: Column(
        children: <Widget>[
          SizedBox(height: height),
          Center(
            child: AnimationLimiter(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: AnimationConfiguration.toStaggeredList(
                  duration: const Duration(milliseconds: 375),
                  childAnimationBuilder: (widget) => SlideAnimation(
                    verticalOffset: 50.0,
                    child: FadeInAnimation(
                      child: widget,
                    ),
                  ),
                  children: <Widget>[
                    Semantics(
                      header: true,
                      label: 'Headline of the sharezone app',
                      child: Text(
                        "Simpel. Sicher. Stabil.",
                        style: TextStyle(
                          fontSize: isTablet(context) ? 64 : 85,
                          fontWeight: FontWeight.w700,
                          color: Colors.black87,
                          fontFamily: SharezoneStyle.font,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Semantics(
                      label: 'A description of the sharezone app',
                      child: Text(
                        "Sharezone ist ein vernetzter Schulplaner, um sich gemeinsam zu organisieren. Eingetragene Inhalte, wie z.B. Hausaufgaben, werden blitzschnell mit allen anderen geteilt. So bleiben viele Nerven und viel Zeit erspart.",
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: isTablet(context) ? 20 : 26,
                          fontWeight: FontWeight.w400,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(height: 50),
                    SvgPicture.asset(
                      'assets/illustrations/releax.svg',
                      height: 250,
                    )
                  ],
                ),
              ),
            ),
          ),
          SizedBox(height: height * 1.5),
        ],
      ),
    );
  }
}
