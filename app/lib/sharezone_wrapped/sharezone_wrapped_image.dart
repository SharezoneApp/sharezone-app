// Copyright (c) 2024 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:sharezone/sharezone_wrapped/sharezone_wrapped_view.dart';
import 'package:sharezone_widgets/sharezone_widgets.dart';

class SharezoneWrappedImage extends StatelessWidget {
  const SharezoneWrappedImage({
    super.key,
    required this.view,
  });

  final SharezoneWrappedView view;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 960,
      width: 540,
      child: Material(
        color: blueColor,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Center(
            child: DefaultTextStyle.merge(
              textAlign: TextAlign.center,
              style: const TextStyle(height: 1.2),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const _Icon(),
                  const _MySchoolYearTitle(),
                  const _CreatedWithSharezoneText(),
                  const SizedBox(height: 32),
                  Container(
                    padding: const EdgeInsets.all(12),
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        AutoSizeText(
                          view.totalAmountOfLessonHours,
                          maxLines: 1,
                          style: const TextStyle(
                            fontSize: 120,
                            fontWeight: FontWeight.w500,
                            color: Colors.black,
                          ),
                        ),
                        const Text(
                          'Stunden im Schulunterricht verbracht',
                          style: TextStyle(
                            fontSize: 32,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          view.amountOfLessonHoursTopThreeCourses.join('\n'),
                          style: const TextStyle(
                            fontSize: 18,
                            color: Colors.grey,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Container(
                        width: (540 / 2) - 18,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            AutoSizeText(
                              view.totalAmountOfHomeworks,
                              maxLines: 1,
                              style: const TextStyle(
                                fontSize: 80,
                                fontWeight: FontWeight.w500,
                                color: Colors.black,
                              ),
                            ),
                            const Text(
                              'Hausaufgaben',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 20,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              view.amountOfHomeworksTopThreeCourses.join('\n'),
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                color: Colors.grey,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      Container(
                        width: (540 / 2) - 18,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            AutoSizeText(
                              view.totalAmountOfExams,
                              maxLines: 1,
                              style: const TextStyle(
                                fontSize: 80,
                                fontWeight: FontWeight.w500,
                                color: Colors.black,
                              ),
                            ),
                            const Text(
                              'Prüfungen',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 20,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              view.amountOfExamsTopThreeCourses.join('\n'),
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                color: Colors.grey,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),
                  const SharezoneLogo(
                    logoColor: LogoColor.white,
                    height: 45,
                    width: 100,
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _CreatedWithSharezoneText extends StatelessWidget {
  const _CreatedWithSharezoneText();

  @override
  Widget build(BuildContext context) {
    return const Text(
      'Erstellt mit der App "Sharezone"',
      style: TextStyle(
        fontSize: 16,
        color: Colors.white70,
      ),
      textAlign: TextAlign.center,
    );
  }
}

class _MySchoolYearTitle extends StatelessWidget {
  const _MySchoolYearTitle();

  @override
  Widget build(BuildContext context) {
    return const Text(
      'Mein Schuljahr 23/24',
      style: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.w500,
        color: Colors.white,
      ),
      textAlign: TextAlign.center,
    );
  }
}

class _Icon extends StatelessWidget {
  const _Icon();

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      'assets/icons/graduation-cap.svg',
      width: 140,
      height: 140,
    );
  }
}
