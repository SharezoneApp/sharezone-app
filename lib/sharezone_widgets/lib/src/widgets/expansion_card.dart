// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:flutter/material.dart';
import 'package:sharezone_widgets/sharezone_widgets.dart';

/// A customizable expansion card that toggles between showing and hiding
/// content.
///
/// The `ExpansionCard` is a widget that displays a header and an expandable
/// body. When tapped on, the body content is revealed or hidden. This is
/// particularly useful for FAQ sections, lists with more detailed information,
/// or anywhere where you want to present the user with summary information that
/// can be expanded to show more details.
///
/// The [header] and [body] parameters are both required. The [header]
/// represents the always-visible portion of the card, while the [body] is shown
/// or hidden based on user interaction.
///
/// The appearance of the card can be customized with [padding],
/// [backgroundColor], and other provided properties.
///
/// The card uses [openTooltip] and [closeTooltip] to provide tooltips for the
/// expand and collapse icons, respectively.
///
/// The background color defaults to [ThemeData.colorScheme.surface] if no
/// [backgroundColor] is provided.
///
/// See also:
///
///  * [ExpansionTile], a related widget in the Flutter framework which also
///    allows users to expand or collapse content.
class ExpansionCard extends StatefulWidget {
  const ExpansionCard({
    super.key,
    required this.header,
    required this.body,
    this.padding = const EdgeInsets.symmetric(
      horizontal: 20,
      vertical: 18,
    ),
    this.backgroundColor,
    this.openTooltip = 'Aufklappen',
    this.closeTooltip = 'Zuklappen',
  });

  /// The header of the card.
  ///
  /// This widget is always visible.
  final Widget header;

  /// The body of the card.
  ///
  /// This widget is only visible when the card is expanded.
  final Widget body;

  /// The padding of the card.
  ///
  /// The default value is `EdgeInsets.symmetric(horizontal: 20, vertical: 18)`.
  final EdgeInsetsGeometry padding;

  /// The background color of the card.
  ///
  /// If not set, the [ThemeData.colorScheme.surface] is used.
  final Color? backgroundColor;

  /// The tooltip for the button to open the card.
  ///
  /// The default value is `Aufklappen`.
  final String openTooltip;

  /// The tooltip for the button to close the card.
  ///
  /// The default value is `Zuklappen`.
  final String closeTooltip;

  @override
  State<ExpansionCard> createState() => ExpansionCardState();
}

class ExpansionCardState extends State<ExpansionCard> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    const borderRadius = BorderRadius.all(Radius.circular(15));
    return ClipRRect(
      borderRadius: borderRadius,
      child: InkWell(
        borderRadius: borderRadius,
        key: ValueKey(widget.header),
        onTap: () {
          setState(() => isExpanded = !isExpanded);
        },
        child: MouseRegion(
          cursor: SystemMouseCursors.click,
          child: Container(
            decoration: BoxDecoration(
              color: widget.backgroundColor ??
                  Theme.of(context).colorScheme.surface,
              borderRadius: borderRadius,
            ),
            child: AnimatedSize(
              duration: const Duration(milliseconds: 400),
              curve: Curves.easeInOutQuart,
              alignment: Alignment.topCenter,
              child: Padding(
                padding: widget.padding,
                child: DefaultTextStyle(
                  style: DefaultTextStyle.of(context).style.copyWith(
                        fontSize: 18,
                      ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(child: widget.header),
                          const SizedBox(width: 8),
                          _CloseOpenBodyIcon(
                            isExpanded: isExpanded,
                            openTooltip: widget.openTooltip,
                            closeTooltip: widget.closeTooltip,
                          ),
                        ],
                      ),
                      _AnimatedBody(
                        isExpanded: isExpanded,
                        body: widget.body,
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _CloseOpenBodyIcon extends StatelessWidget {
  const _CloseOpenBodyIcon({
    required this.isExpanded,
    required this.closeTooltip,
    required this.openTooltip,
  });

  final bool isExpanded;
  final String closeTooltip;
  final String openTooltip;

  @override
  Widget build(BuildContext context) {
    return IconTheme(
      data: Theme.of(context).iconTheme.copyWith(
            color: Colors.grey[600],
          ),
      child: AnimatedSwap(
        duration: const Duration(milliseconds: 275),
        child: isExpanded
            ? _HideBodyIcon(
                tooltip: closeTooltip,
              )
            : _ShowBodyIcon(
                tooltip: openTooltip,
              ),
      ),
    );
  }
}

class _AnimatedBody extends StatelessWidget {
  const _AnimatedBody({
    required this.isExpanded,
    required this.body,
  });

  final bool isExpanded;
  final Widget body;

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      // Adding the default transitionBuilder here fixes
      // https://github.com/flutter/flutter/issues/121336. The bug can occur
      // when clicking the card very quickly.
      transitionBuilder: (Widget child, Animation<double> animation) {
        return FadeTransition(
          opacity: animation,
          child: child,
        );
      },
      duration: Duration(milliseconds: isExpanded ? 100 : 500),
      child: Column(
        key: ValueKey(isExpanded),
        children: isExpanded
            ? [
                const SizedBox(height: 18),
                DefaultTextStyle(
                  style: DefaultTextStyle.of(context).style.copyWith(
                        fontSize: 16,
                        color: Theme.of(context).isDarkTheme
                            ? Colors.grey[400]
                            : Colors.grey[700],
                      ),
                  child: body,
                ),
              ]
            : [],
      ),
    );
  }
}

class _ShowBodyIcon extends StatelessWidget {
  const _ShowBodyIcon({
    required this.tooltip,
  });

  final String tooltip;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      key: const ValueKey('ShowAnswer'),
      message: tooltip,
      child: const Icon(Icons.keyboard_arrow_down),
    );
  }
}

class _HideBodyIcon extends StatelessWidget {
  const _HideBodyIcon({
    required this.tooltip,
  });

  final String tooltip;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      key: const ValueKey('HideAnswer'),
      message: tooltip,
      child: const Icon(Icons.keyboard_arrow_up),
    );
  }
}
