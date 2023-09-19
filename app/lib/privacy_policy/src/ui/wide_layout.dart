// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../privacy_policy_src.dart';
import 'ui.dart';

class MainContentWide extends StatelessWidget {
  const MainContentWide({
    required this.privacyPolicy,
    this.showBackButton = true,
    Key? key,
  }) : super(key: key);

  final PrivacyPolicy privacyPolicy;
  final bool showBackButton;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Flexible(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 450),
            child: _TableOfContentsDesktop(privacyPolicy: privacyPolicy),
          ),
        ),
        const VerticalDivider(),
        Center(
          child: Padding(
            padding: const EdgeInsets.only(top: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (showBackButton)
                      // This button should have orignally been at the very left
                      // but since we can't use Expanded (as this causes layout
                      // issues) for now we just give it some padding relative
                      // to the heading to the right.
                      Padding(
                        padding: const EdgeInsets.only(right: 48.0),
                        child: BackButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                      ),
                    Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const PrivacyPolicyHeading(),
                          if (privacyPolicy.hasNotYetEnteredIntoForce)
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 8.0),
                              child: PrivacyPolicySubheading(
                                entersIntoForceOn:
                                    privacyPolicy.entersIntoForceOnOrNull,
                              ),
                            )
                        ],
                      ),
                    ),
                  ],
                ),
                const Divider(),
                Expanded(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(
                      maxWidth: 830,
                      minWidth: 400,
                    ),
                    child: PrivacyPolicyText(privacyPolicy: privacyPolicy),
                  ),
                ),
              ],
            ),
          ),
        )
      ],
    );
  }
}

class _TableOfContentsDesktop extends StatelessWidget {
  const _TableOfContentsDesktop({
    Key? key,
    required this.privacyPolicy,
  }) : super(key: key);

  final PrivacyPolicy privacyPolicy;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        const SizedBox(height: 50),
        Text(
          'Inhaltsverzeichnis',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 20),
        Expanded(
          child: _TocSectionHeadingListDesktop(),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 20, 0, 20),
          child: Column(
            children: [
              Text(
                'Weitere Optionen',
                style: Theme.of(context).textTheme.titleMedium,
                textAlign: TextAlign.start,
              ),
              const SizedBox(height: 13),
              const ChangeAppearanceButton(),
              const SizedBox(height: 8),
              const DownloadAsPDFButton(),
            ],
          ),
        ),
      ],
    );
  }
}

class _TocSectionHeadingListDesktop extends StatelessWidget {
  _TocSectionHeadingListDesktop({
    Key? key,
  }) : super(key: key);
  final scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    final tocController = context.watch<TableOfContentsController>();
    final visualDensity = context.ppVisualDensity;

    return _BottomFade(
      scrollController: scrollController,
      child: SingleChildScrollView(
        controller: scrollController,
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // To test scroll behavior / layout
            ...tocController.documentSections!.map(
              (section) {
                return Padding(
                  padding: EdgeInsets.only(
                    bottom: visualDensity
                        .effectiveConstraints(const BoxConstraints())
                        .constrainHeight(15 + visualDensity.vertical * 5),
                  ),
                  child: _TocHeadingDesktop(
                    key: ValueKey(section.id),
                    section: section,
                  ),
                );
              },
            ).toList(),
          ],
        ),
      ),
    );
  }
}

class _TocHeadingDesktop extends StatefulWidget {
  const _TocHeadingDesktop({
    Key? key,
    required this.section,
  }) : super(key: key);

  final TocDocumentSectionView section;

  @override
  State<_TocHeadingDesktop> createState() => _TocHeadingDesktopState();
}

class _TocHeadingDesktopState extends State<_TocHeadingDesktop>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late bool isExpanded;
  late Animation<double> _heightFactor;
  Animation<double>? expansionArrowTurns;
  final expansionDuration = const Duration(milliseconds: 300);
  final collapseDuration = const Duration(milliseconds: 200);

  @override
  void didUpdateWidget(covariant _TocHeadingDesktop oldWidget) {
    if (widget.section.isExpanded != oldWidget.section.isExpanded) {
      _changeExpansion(widget.section.isExpanded);
    }
    super.didUpdateWidget(oldWidget);
  }

  void _changeExpansion(bool newExpansion) {
    if (newExpansion) {
      _controller.forward();
    } else {
      _controller.reverse().then<void>((void value) {
        if (!mounted) return;
      });
    }
  }

  @override
  void initState() {
    isExpanded = widget.section.isExpanded;
    _controller = AnimationController(
        vsync: this,
        duration: expansionDuration,
        reverseDuration: collapseDuration,
        value: isExpanded ? 1 : 0);

    expansionArrowTurns = _controller.drive(
        Tween(begin: 0.0, end: 0.5).chain(CurveTween(curve: Curves.easeIn)));

    _heightFactor = _controller.view;
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tocController =
        Provider.of<TableOfContentsController>(context, listen: false);
    final showExpansionArrow = widget.section.isExpandable;
    final visualDensity = context.ppVisualDensity;

    return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TocSectionHighlight(
            onTap: () => tocController.scrollTo(widget.section.id),
            shouldHighlight: widget.section.shouldHighlight,
            child: Padding(
              padding: EdgeInsets.symmetric(
                vertical: (14 + visualDensity.vertical * 3)
                    .clamp(0, double.infinity)
                    .toDouble(),
                horizontal: (10 + visualDensity.horizontal)
                    .clamp(0, double.infinity)
                    .toDouble(),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      widget.section.sectionHeadingText,
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                            fontWeight: widget.section.shouldHighlight
                                ? FontWeight.w500
                                : FontWeight.normal,
                          ),
                      textAlign: TextAlign.start,
                    ),
                  ),
                  if (showExpansionArrow)
                    ExpansionArrow(
                      expansionArrowTurns: expansionArrowTurns,
                      onPressed: () {
                        Provider.of<TableOfContentsController>(context,
                                listen: false)
                            .toggleDocumentSectionExpansion(widget.section.id);

                        _changeExpansion(!isExpanded);
                      },
                    )
                ],
              ),
            ),
          ),
          if (widget.section.isExpandable)
            AnimatedBuilder(
              animation: _heightFactor,
              builder: (context, child) {
                return ClipRRect(
                  child: Align(
                    alignment: Alignment.center,
                    heightFactor: _heightFactor.value,
                    child: AnimatedOpacity(
                      opacity: _heightFactor.value,
                      curve: Curves.easeOutExpo,
                      duration: widget.section.isExpanded
                          ? expansionDuration
                          : collapseDuration,
                      child: child,
                    ),
                  ),
                );
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                // CrossAxisAlignment.start causes single line text to not be
                // aligned with multiline text. Single line text would have too
                // much space on the left.
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: widget.section.subsections.map(
                  (subsection) {
                    return Padding(
                      padding: EdgeInsets.only(
                        left: 15.0,
                        top: visualDensity
                            .effectiveConstraints(
                                const BoxConstraints(maxHeight: 20))
                            .constrainHeight(13 + visualDensity.vertical * 2.5),
                      ),
                      child: TocSectionHighlight(
                        onTap: () => tocController.scrollTo(subsection.id),
                        shouldHighlight: subsection.shouldHighlight,
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                            vertical: (12 + visualDensity.vertical * 3)
                                .clamp(0, double.infinity)
                                .toDouble(),
                            horizontal: (10 + visualDensity.horizontal)
                                .clamp(0, double.infinity)
                                .toDouble(),
                          ),
                          child: Text(
                            subsection.sectionHeadingText,
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .copyWith(
                                  fontSize: Theme.of(context)
                                          .textTheme
                                          .bodyMedium!
                                          .fontSize! -
                                      .5,
                                  fontWeight: subsection.shouldHighlight
                                      ? FontWeight.w400
                                      : FontWeight.normal,
                                ),
                            textAlign: TextAlign.start,
                          ),
                        ),
                      ),
                    );
                  },
                ).toList(),
              ),
            )
        ]);
  }
}

class _BottomFade extends StatelessWidget {
  const _BottomFade({
    Key? key,
    required this.child,
    required this.scrollController,
  }) : super(key: key);

  final Widget child;
  final ScrollController scrollController;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
        animation: scrollController,
        child: child,
        builder: (context, child) {
          final isAtBottom = scrollController.hasClients &&
              scrollController.position.pixels >=
                  scrollController.position.maxScrollExtent;
          final showBottomFade = !isAtBottom;
          return ShaderMask(
            shaderCallback: (Rect rect) {
              return LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  Colors.transparent,
                  Colors.transparent,
                  showBottomFade ? Colors.purple : Colors.transparent,
                ],
                stops: const [
                  0.0,
                  .1,
                  0.9,
                  1.0,
                ], // 10% purple, 80% transparent, 10% purple
              ).createShader(rect);
            },
            blendMode: BlendMode.dstOut,
            child: child,
          );
        });
  }
}
