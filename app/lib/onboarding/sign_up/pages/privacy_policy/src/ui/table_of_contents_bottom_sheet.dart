import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:sharezone/homework/student/src/homework_bottom_action_bar.dart';
import 'package:sharezone_widgets/theme.dart';

import '../privacy_policy_src.dart';
import 'ui.dart';

void showTableOfContentsBottomSheet(BuildContext context) {
  final oldContext = context;
  // TODO: We probably shouldn't use this from the homework folder.
  // Maybe move showRoundedModalBottomSheet to some common place?
  // Or duplicate the method.
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
      child: _TableOfContentsBottomSheet(),
    ),
  );
}

class _TableOfContentsBottomSheet extends StatefulWidget {
  const _TableOfContentsBottomSheet({Key key}) : super(key: key);

  @override
  State<_TableOfContentsBottomSheet> createState() =>
      __TableOfContentsBottomSheetState();
}

class __TableOfContentsBottomSheetState
    extends State<_TableOfContentsBottomSheet> with TickerProviderStateMixin {
  // TODO:
  // with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return BottomSheet(
      constraints: BoxConstraints(maxHeight: 600),
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
                      .add(EdgeInsets.only(left: 20)),
                  child: Text(
                    'Inhaltsverzeichnis',
                    style: Theme.of(context).textTheme.headline6,
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
          Divider(thickness: 2, height: 0),
          Expanded(child: _TocSectionHeadingList())
        ],
      ),
    );
  }
}

class _TocSectionHeadingList extends StatelessWidget {
  _TocSectionHeadingList({
    Key key,
  }) : super(key: key);
  final itemScrollController = ItemScrollController();

  @override
  Widget build(BuildContext context) {
    final tocController = context.watch<TableOfContentsController>();
    int indexHighlighted = tocController.documentSections
        .indexWhere((section) => section.shouldHighlight);

    // TODO: Can we make _BottomFade work with ItemScrollController?
    // This list bounces when opening the bottom sheet and viewing the list
    // if the user is reading one of the last chapters (so
    // ScrollablePositionedList wants to scroll to the last items).
    // It seems like this has to be fixed inside ScrollablePositionedList.
    // See: https://github.com/google/flutter.widgets/issues/276
    return ScrollablePositionedList.separated(
      separatorBuilder: (context, index) => Divider(height: 1, thickness: 1),
      initialScrollIndex: indexHighlighted == -1 ? 0 : indexHighlighted,
      itemScrollController: itemScrollController,
      itemCount: tocController.documentSections.length,
      itemBuilder: (context, index) {
        final section = tocController.documentSections[index];
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
    Key key,
    @required this.section,
  }) : super(key: key);

  final TocDocumentSectionView section;

  @override
  State<_TocHeading> createState() => _TocHeadingState();
}

class _TocHeadingState extends State<_TocHeading>
    with TickerProviderStateMixin {
  // TODO: Breaks hot reload: Add later again
  // with SingleTickerProviderStateMixin {
  AnimationController _controller;
  bool isExpanded;
  Animation<double> _heightFactor;
  Animation<double> expansionArrowTurns;

  final expansionDuration = Duration(milliseconds: 200);
  final collapseDuration = Duration(milliseconds: 150);

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
    final visualDensity = context
        .watch<PrivacyPolicyThemeSettings>()
        .visualDensitySetting
        .visualDensity;

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHighlight(
          shape: ContinuousRectangleBorder(),
          onTap: () async {
            // TODO: Should probabaly be tested via widget test that it pops?
            await tocController.scrollTo(widget.section.id);
            Navigator.pop(context);
          },
          shouldHighlight: widget.section.shouldHighlight,
          backgroundColor: isDarkThemeEnabled(context)
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
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4.0),
                    child: ExpansionArrow(
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
            builder: (context, child) => ClipRRect(
              child: Align(
                alignment: Alignment.center,
                heightFactor: _heightFactor.value,
                child: child,
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
  final visualDensity =
      Provider.of<PrivacyPolicyThemeSettings>(context, listen: false)
          .visualDensitySetting
          .visualDensity;
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
        child: SizedBox(height: .5),
      ));
    }

    widgets.add(Divider(height: 0, thickness: .5));

    widgets.add(SectionHighlight(
      backgroundColor: isDarkThemeEnabled(context)
          ? Color(0xff121212)
          : Theme.of(context).scaffoldBackgroundColor,
      shape: ContinuousRectangleBorder(),
      shouldHighlight: subheading.shouldHighlight,
      onTap: () async {
        // TODO: Should probabaly be tested via widget test
        // that it pops?
        await tocController.scrollTo(subheading.id);
        Navigator.pop(context);
      },
      child: Padding(
        padding: EdgeInsets.only(
          left: 19.0,
        ).add(
          EdgeInsets.symmetric(
            vertical: visualDensity
                .effectiveConstraints(BoxConstraints(maxHeight: 20))
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
    Key key,
    @required this.subsection,
  }) : super(key: key);

  final TocDocumentSectionView subsection;

  @override
  Widget build(BuildContext context) {
    final visualDensity = context
        .watch<PrivacyPolicyThemeSettings>()
        .visualDensitySetting
        .visualDensity;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(width: 8),
        Icon(Icons.circle, size: 6),
        SizedBox(width: 10),
        Flexible(
          child: SectionHighlightOnly(
            shouldHighlight: subsection.shouldHighlight,
            backgroundColor: Theme.of(context).canvasColor,
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
                '${subsection.sectionHeadingText}',
                style: Theme.of(context).textTheme.bodyText2.copyWith(
                      fontSize:
                          Theme.of(context).textTheme.bodyText2.fontSize - .5,
                      fontWeight: subsection.shouldHighlight
                          ? FontWeight.w400
                          : FontWeight.normal,
                    ),
                textAlign: TextAlign.start,
              ),
            ),
          ),
        ),
        // So that if the highlighted text overflows there is a bit of white
        // space on the right. Else the highlight would fill the whole right
        // side which looks weird.
        SizedBox(width: 10),
      ],
    );
  }
}

// TODO: Better name
class SectionHighlightOnly extends StatelessWidget {
  const SectionHighlightOnly({
    Key key,
    @required this.child,
    @required this.shouldHighlight,
    this.backgroundColor,
    this.shape = const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(4)),
    ),
  }) : super(key: key);

  final Widget child;
  final bool shouldHighlight;
  final Color backgroundColor;
  final ShapeBorder shape;

  @override
  Widget build(BuildContext context) {
    // TODO Dont need background color then I think?
    if (!shouldHighlight) return child;
    return AnimatedContainer(
      decoration: ShapeDecoration(
        color: shouldHighlight
            ? _getHighlightColor(context)
            : backgroundColor ?? Theme.of(context).scaffoldBackgroundColor,
        shape: shape,
      ),
      duration: Duration(milliseconds: 100),
      child: child,
    );
  }
}

Color _getHighlightColor(BuildContext context) => isDarkThemeEnabled(context)
    ? Colors.blue.shade800
    : Colors.lightBlue.shade100;
