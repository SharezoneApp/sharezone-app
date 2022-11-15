import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:provider/provider.dart';

import '../privacy_policy_src.dart';
import 'privacy_policy_widgets.dart';

class MainContentWide extends StatelessWidget {
  final PrivacyPolicy privacyPolicy;

  const MainContentWide({
    @required this.privacyPolicy,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Flexible(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: 450),
            child: TableOfContentsDesktop(),
          ),
        ),
        VerticalDivider(),
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
                  // TODO: Move BackButton to the very left.
                  // We can't seem to use Expanded since that conflicts with the
                  // table of contents to the left.
                  children: [
                    BackButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                    // TODO: This might also not be centered correctly (too much
                    // on the right because of the back button)
                    Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: const [
                          PrivacyPolicyHeading(),
                          Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 20, vertical: 8.0),
                            child: PrivacyPolicySubheading(),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Divider(),
                Expanded(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
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

// TODO: Make private again, after completing the UI
class TableOfContentsDesktop extends StatelessWidget {
  const TableOfContentsDesktop({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        SizedBox(height: 50),
        Text(
          'Inhaltsverzeichnis',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.headline6,
        ),
        SizedBox(height: 20),
        Expanded(
          child: _TocSectionHeadingListDesktop(),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 20, 0, 20),
          child: Column(
            children: [
              Align(
                alignment: Alignment(-.7, 0.0),
                child: Text(
                  'Weitere Optionen',
                  style: Theme.of(context).textTheme.titleMedium,
                  textAlign: TextAlign.start,
                ),
              ),
              SizedBox(height: 13),
              ChangeAppearanceButton(),
              SizedBox(height: 8),
              DownloadAsPDFButton(),
            ],
          ),
        ),
      ],
    );
  }
}

class _TocSectionHeadingListDesktop extends StatelessWidget {
  _TocSectionHeadingListDesktop({
    Key key,
  }) : super(key: key);
  final scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    final tocController = context.watch<TableOfContentsController>();
    // TODO: Create Extension?
    final visualDensity = context
        .watch<PrivacyPolicyThemeSettings>()
        .visualDensitySetting
        .visualDensity;

    return _BottomFade(
      scrollController: scrollController,
      child: SingleChildScrollView(
        controller: scrollController,
        padding: EdgeInsets.symmetric(
          horizontal: 20,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // To test scroll behavior / layout
            ...tocController.documentSections.map(
              (section) {
                return Padding(
                  padding: EdgeInsets.only(
                    bottom: visualDensity
                        .effectiveConstraints(BoxConstraints())
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
    Key key,
    @required this.section,
  }) : super(key: key);

  final TocDocumentSectionView section;

  @override
  State<_TocHeadingDesktop> createState() => _TocHeadingDesktopState();
}

// TODO: Make some base widget / merge some code with bottom sheet version
class _TocHeadingDesktopState extends State<_TocHeadingDesktop>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  bool isExpanded;
  Animation<double> _heightFactor;
  Animation<double> expansionArrowTurns;
  final expansionDuration = Duration(milliseconds: 300);
  final collapseDuration = Duration(milliseconds: 200);

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
    final visualDensity = context
        .watch<PrivacyPolicyThemeSettings>()
        .visualDensitySetting
        .visualDensity;

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHighlight(
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
                    '${widget.section.sectionHeadingText}',
                    style: Theme.of(context).textTheme.bodyText2.copyWith(
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
              // TODO: Doesn't work anymore?
              children: AnimationConfiguration.toStaggeredList(
                duration: expansionDuration,
                childAnimationBuilder: (widget) => SlideAnimation(
                  duration: expansionDuration,
                  horizontalOffset: 15,
                  child: FadeInAnimation(child: widget),
                ),
                children: widget.section.subsections.map(
                  (subsection) {
                    return Padding(
                      padding: EdgeInsets.only(
                        left: 15.0,
                        top: visualDensity
                            .effectiveConstraints(BoxConstraints(maxHeight: 20))
                            .constrainHeight(13 + visualDensity.vertical * 2.5),
                      ),
                      child: SectionHighlight(
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
                            '${subsection.sectionHeadingText}',
                            style:
                                Theme.of(context).textTheme.bodyText2.copyWith(
                                      fontSize: Theme.of(context)
                                              .textTheme
                                              .bodyText2
                                              .fontSize -
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
            ),
          ),
      ],
    );
  }
}

class _BottomFade extends StatelessWidget {
  const _BottomFade({
    Key key,
    @required this.child,
    @required this.scrollController,
  }) : super(key: key);

  final Widget child;
  final ScrollController scrollController;
  ScrollPosition get position => scrollController.position;

  // TODO: Remove?
  double get pixelsUntilBottom => position.maxScrollExtent - position.pixels;
  double get percentToBottom =>
      ((position.maxScrollExtent / pixelsUntilBottom) / 100)
          .clamp(0, 1)
          .toDouble();

  bool get isScrollable =>
      scrollController.position.maxScrollExtent !=
      scrollController.position.minScrollExtent;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
        animation: scrollController,
        child: child,
        builder: (context, _child) {
          final isAtBottom = scrollController.hasClients &&
              scrollController.position.pixels >=
                  scrollController.position.maxScrollExtent;

          // This was an approach to disable the bottom fade if the
          // SingleChildScrollView is not scrollable (the screen is big enough
          // to fit everything without scrolling). The Problem was that the code
          // below would also set "isNotScrollable" true if the scrollview size
          // changed because e.g. a chapter was expanded to show its
          // subchapters.
          //
          // final isNotScrollable = !scrollController.hasClients || !isScrollable;
          // final showBottomFade = !(isAtBottom || isNotScrollable);

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
            child: _child,
          );
        });
  }
}
