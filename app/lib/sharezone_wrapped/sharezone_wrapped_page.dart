// Copyright (c) 2024 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:sharezone/sharezone_wrapped/sharezone_wrapped_controller.dart';
import 'package:sharezone/sharezone_wrapped/sharezone_wrapped_image.dart';
import 'package:sharezone/sharezone_wrapped/sharezone_wrapped_view.dart';
import 'package:sharezone/support/support_page.dart';
import 'package:sharezone_widgets/sharezone_widgets.dart';

class SharezoneWrappedPage extends StatefulWidget {
  const SharezoneWrappedPage({super.key});

  static const tag = "sharezone-Wrapped-page";

  @override
  State<SharezoneWrappedPage> createState() => _SharezoneWrappedPageState();
}

class _SharezoneWrappedPageState extends State<SharezoneWrappedPage> {
  Uint8List? _imageData;
  bool get hasLoaded => _imageData != null;
  String? error;

  SharezoneWrappedValues? values;
  late ScreenshotController _screenshotController;

  Future<void> fetchValues() async {
    try {
      final controller = context.read<SharezoneWrappedController>();
      values = await controller.getValues();

      setState(() {
        error = null;
      });
    } catch (e) {
      setState(() {
        error = '$e';
      });
    }
  }

  Future<void> generateWrapped() async {
    await fetchValues();

    final hasNotFailedToFetchValues = values != null;
    if (hasNotFailedToFetchValues) {
      final capture = await _screenshotController.capture();
      setState(() {
        _imageData = capture;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _screenshotController = ScreenshotController();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      generateWrapped();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Stack(
          children: [
            SingleChildScrollView(
              padding: const EdgeInsets.all(12),
              child: MaxWidthConstraintBox(
                maxWidth: 550,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Idea: when opening the page: creating an actual image and
                    // displaying it.
                    Container(
                      // add border
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: darkBlueColor,
                          width: 4,
                        ),
                      ),
                      child: InkWell(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => Theme(
                                data: getDarkTheme(),
                                child: Scaffold(
                                  appBar: AppBar(
                                    leading: const CloseButton(),
                                  ),
                                  body: Center(
                                    child: Hero(
                                      tag: 'sharezone-wrapped-image',
                                      child: Image.memory(
                                        _imageData!,
                                        fit: BoxFit.contain,
                                        semanticLabel: 'Sharezone Wrapped',
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                        child: _imageData == null
                            ? Screenshot(
                                controller: _screenshotController,
                                child: SharezoneWrappedImage(
                                  view: SharezoneWrappedView.fromValues(
                                    totalAmountOfLessonHours:
                                        values?.totalAmountOfLessonHours ?? 0,
                                    amountOfLessonHoursTopThreeCourses: values
                                            ?.amountOfLessonHoursTopThreeCourses ??
                                        [],
                                    totalAmountOfHomeworks:
                                        values?.totalAmountOfHomeworks ?? 0,
                                    amountOfHomeworksTopThreeCourses: values
                                            ?.amountOfHomeworksTopThreeCourses ??
                                        [],
                                    totalAmountOfExams:
                                        values?.totalAmountOfExams ?? 0,
                                    amountOfExamsTopThreeCourses:
                                        values?.amountOfExamsTopThreeCourses ??
                                            [],
                                  ),
                                ),
                              )
                            : Hero(
                                tag: 'sharezone-wrapped-image',
                                child: Image.memory(
                                  _imageData!,
                                  semanticLabel: 'Sharezone Wrapped',
                                  height:
                                      MediaQuery.of(context).size.height * 0.6,
                                ),
                              ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Wrapped',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const Text(
                      'Schuljahr 23/24',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Hier ist dein Schuljahr in Zahlen. Teile es mit deinen Freunden auf Instagram, TikTok und Co.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        color: Theme.of(context)
                            .colorScheme
                            .onSurface
                            .withOpacity(0.6),
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    const SizedBox(height: 12),
                    ElevatedButton.icon(
                      icon: const Icon(Icons.share),
                      onPressed: () async {
                        // final capture = await _screenshotController.capture();

                        // setState(() {
                        //   _imageData = capture;
                        //   print("Saved!");
                        // });
                      },
                      label: const Text("Teilen"),
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            if (!hasLoaded) const _LoadingScreen(),
            if (error != null)
              _ErrorScreen(
                error: error!,
                onRetryPressed: () => generateWrapped(),
              )
          ],
        ),
      ),
    );
  }
}

class _LoadingScreen extends StatelessWidget {
  const _LoadingScreen();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      color: Theme.of(context).scaffoldBackgroundColor,
      child: const Center(
        child: SingleChildScrollView(
          child: MaxWidthConstraintBox(
            maxWidth: 300,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 16),
                Text(
                  "Dein Sharezone Wrapped wird erstellt 👩‍🍳 Das kann ein paar Sekunden dauern...",
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ErrorScreen extends StatelessWidget {
  const _ErrorScreen({
    required this.error,
    required this.onRetryPressed,
  });

  final String error;
  final VoidCallback onRetryPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      color: Theme.of(context).scaffoldBackgroundColor,
      child: Center(
        child: MaxWidthConstraintBox(
          // The column is a workaround to avoid that the error card takes the
          // full width of the screen.
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ErrorCard(
                message: Text(error),
                onRetryPressed: onRetryPressed,
                onContactSupportPressed: () =>
                    Navigator.pushNamed(context, SupportPage.tag),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
