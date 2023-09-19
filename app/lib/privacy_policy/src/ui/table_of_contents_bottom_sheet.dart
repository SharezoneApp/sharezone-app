// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:sharezone_widgets/sharezone_widgets.dart';

import '../privacy_policy_src.dart';
import 'ui.dart';

void showTableOfContentsBottomSheet(BuildContext context) {
  final oldContext = context;
  showRoundedModalBottomSheet(
    isScrollControlled: true,
    context: context,
    builder: (context) => MultiProvider(
      providers: [
        // We use ListenableProvider instead of ChangeNotifierProvider because
        // ChangeNotifierProvider would auto-dispose our Controllers when the
        // bottom sheet is closed (i.e. the providers are removed from the
        // widget tree).
        ListenableProvider<TableOfContentsController>(
          create: (context) =>
              Provider.of<TableOfContentsController>(oldContext, listen: false),
        ),
        ListenableProvider<PrivacyPolicyThemeSettings>(
          create: (context) => Provider.of<PrivacyPolicyThemeSettings>(
              oldContext,
              listen: false),
        ),
      ],
      child: const _TableOfContentsBottomSheet(),
    ),
  );
}

class _TableOfContentsBottomSheet extends StatefulWidget {
  const _TableOfContentsBottomSheet({Key? key}) : super(key: key);

  @override
  State<_TableOfContentsBottomSheet> createState() =>
      __TableOfContentsBottomSheetState();
}

// TickerProviderStateMixin instead of SingleTickerProviderStateMixin because
// else we get an error if we hot reload while the bottom bar is opened.
class __TableOfContentsBottomSheetState
    extends State<_TableOfContentsBottomSheet> with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return BottomSheet(
      constraints: const BoxConstraints(maxHeight: 600),
      enableDrag: true,
      onClosing: () {},
      animationController: BottomSheet.createAnimationController(this),
      builder: (context) => Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Expanded(
                flex: 2,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0)
                      .add(const EdgeInsets.only(left: 20)),
                  child: Text(
                    'Inhaltsverzeichnis',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
              ),
              Align(
                alignment: Alignment.centerRight,
                child: IconButton(
                  icon: Icon(Icons.close, color: Colors.grey[600]),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
            ],
          ),
          const Divider(thickness: 2, height: 0),
          Expanded(child: _TocSectionHeadingList())
        ],
      ),
    );
  }
}

class _TocSectionHeadingList extends StatelessWidget {
  _TocSectionHeadingList({
    Key? key,
  }) : super(key: key);
  final itemScrollController = ItemScrollController();

  @override
  Widget build(BuildContext context) {
    final tocController = context.watch<TableOfContentsController>();
    int indexHighlighted = tocController.documentSections!
        .indexWhere((section) => section.shouldHighlight);

    // This list bounces when opening the bottom sheet and viewing the list
    // if the user is reading one of the last chapters (so
    // ScrollablePositionedList wants to scroll to the last items).
    // It seems like this has to be fixed inside ScrollablePositionedList.
    // See: https://github.com/google/flutter.widgets/issues/276
    return ScrollablePositionedList.separated(
      separatorBuilder: (context, index) =>
          const Divider(height: 1, thickness: 1),
      initialScrollIndex: indexHighlighted == -1 ? 0 : indexHighlighted,
      itemScrollController: itemScrollController,
      itemCount: tocController.documentSections!.length,
      itemBuilder: (context, index) {
        final section = tocController.documentSections![index];
        return _TocHeading(
          key: ValueKey(section.id),
          section: section,
        );
      },
    );
  }
}

class _TocHeading extends StatefulWidget {
  const _TocHeading({
    Key? key,
    required this.section,
  }) : super(key: key);

  final TocDocumentSectionView section;

  @override
  State<_TocHeading> createState() => _TocHeadingState();
}

// TickerProviderStateMixin instead of SingleTickerProviderStateMixin because
// else we get an error if we hot reload while the bottom bar is opened.
class _TocHeadingState extends State<_TocHeading>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late bool isExpanded;
  late Animation<double> _heightFactor;
  Animation<double>? expansionArrowTurns;

  final expansionDuration = const Duration(milliseconds: 200);
  final collapseDuration = const Duration(milliseconds: 150);

  @override
  void didUpdateWidget(covariant _TocHeading oldWidget) {
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
          shape: const ContinuousRectangleBorder(),
          onTap: () async {
            await tocController.scrollTo(widget.section.id);
            if (!context.mounted) return;
            Navigator.pop(context);
          },
          shouldHighlight: widget.section.shouldHighlight,
          backgroundColor: Theme.of(context).isDarkTheme
              ? Theme.of(context).canvasColor
              : Theme.of(context).scaffoldBackgroundColor,
          child: Padding(
            padding: EdgeInsets.symmetric(
              vertical: (22 + visualDensity.vertical * 3)
                  .clamp(0, double.infinity)
                  .toDouble(),
              horizontal: (25 + visualDensity.horizontal)
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
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4.0),
                    child: ExpansionArrow(
                      key: const ValueKey('toc-section-expansion-arrow-E2E'),
                      expansionArrowTurns: expansionArrowTurns,
                      onPressed: () {
                        Provider.of<TableOfContentsController>(context,
                                listen: false)
                            .toggleDocumentSectionExpansion(widget.section.id);
                      },
                    ),
                  )
              ],
            ),
          ),
        ),
        if (widget.section.isExpandable)
          AnimatedBuilder(
            animation: _heightFactor,
            builder: (context, child) => Visibility(
              // If the subsections are not visible we don't need to draw them.
              visible: _heightFactor.value != 0,
              child: ClipRRect(
                child: Align(
                  alignment: Alignment.center,
                  heightFactor: _heightFactor.value,
                  child: child,
                ),
              ),
            ),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                // CrossAxisAlignment.start causes single line text to not be
                // aligned with multiline text. Single line text would have too
                // much space on the left.
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children:
                    _buildSubheadings(context, widget.section.subsections)),
          ),
      ],
    );
  }
}

List<Widget> _buildSubheadings(
    BuildContext context, IList<TocDocumentSectionView> subheadings) {
  final visualDensity = context.ppVisualDensity;
  final tocController =
      Provider.of<TableOfContentsController>(context, listen: false);

  final widgets = <Widget>[];

  for (var subheading in subheadings) {
    if (subheading == subheadings.first) {
      // Else the first Divider appears thinner as it is partly swallowed by the
      // heading above.
      // We don't want to use Divider.height to provider the space instead of
      // this as Divider.height would make the last Subsection assymetric as
      // there is no header below.
      widgets.add(ColoredBox(
        color: subheadings.first.shouldHighlight
            ? Colors.black.withOpacity(.3)
            : Colors.transparent,
        child: const SizedBox(height: .5),
      ));
    }

    widgets.add(const Divider(height: 0, thickness: .5));

    widgets.add(TocSectionHighlight(
      backgroundColor: Theme.of(context).isDarkTheme
          ? const Color(0xff121212)
          : Theme.of(context).scaffoldBackgroundColor,
      shape: const ContinuousRectangleBorder(),
      shouldHighlight: subheading.shouldHighlight,
      onTap: () async {
        await tocController.scrollTo(subheading.id);
        if (!context.mounted) return;
        Navigator.pop(context);
      },
      child: Padding(
        padding: const EdgeInsets.only(
          left: 19.0,
        ).add(
          EdgeInsets.symmetric(
            vertical: visualDensity
                .effectiveConstraints(const BoxConstraints(maxHeight: 20))
                .constrainHeight(6 + visualDensity.vertical * 2),
          ),
        ),
        child: _Subheading(
          subsection: subheading,
        ),
      ),
    ));
  }

  return widgets;
}

class _Subheading extends StatelessWidget {
  const _Subheading({
    Key? key,
    required this.subsection,
  }) : super(key: key);

  final TocDocumentSectionView subsection;

  @override
  Widget build(BuildContext context) {
    final visualDensity = context.ppVisualDensity;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(width: 8),
        const Icon(Icons.circle, size: 6),
        const SizedBox(width: 10),
        Flexible(
          child: Padding(
            padding: EdgeInsets.symmetric(
              vertical: (16 + visualDensity.vertical * 3)
                  .clamp(0, double.infinity)
                  .toDouble(),
              horizontal: (10 + visualDensity.horizontal)
                  .clamp(0, double.infinity)
                  .toDouble(),
            ),
            child: Text(
              subsection.sectionHeadingText,
              style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    fontSize:
                        Theme.of(context).textTheme.bodyMedium!.fontSize! - .5,
                    fontWeight: subsection.shouldHighlight
                        ? FontWeight.w400
                        : FontWeight.normal,
                  ),
              textAlign: TextAlign.start,
            ),
          ),
        ),
        // So that if the highlighted text overflows there is a bit of white
        // space on the right. Else the highlight would fill the whole right
        // side which looks weird.
        const SizedBox(width: 10),
      ],
    );
  }
}
