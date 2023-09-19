// Copyright (c) 2023 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:flutter/material.dart';
import 'package:sharezone_widgets/sharezone_widgets.dart';

class SharezonePlusBadge extends StatelessWidget {
  const SharezonePlusBadge({
    super.key,
    this.color,
  });

  final Color? color;

  @override
  Widget build(BuildContext context) {
    final color = this.color ??
        (Theme.of(context).isDarkTheme
            ? Theme.of(context).primaryColor
            : darkBlueColor);
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          Icons.star_rounded,
          color: color,
        ),
        const SizedBox(width: 6),
        Text(
          'PLUS',
          style: TextStyle(
            fontWeight: FontWeight.w500,
            color: color,
            letterSpacing: 0.5,
          ),
        )
      ],
    );
  }
}

class SharezonePlusChip extends StatelessWidget {
  const SharezonePlusChip({
    super.key,
    this.backgroundColor,
    this.foregroundColor,
  });

  final Color? backgroundColor;
  final Color? foregroundColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color:
            backgroundColor ?? Theme.of(context).primaryColor.withOpacity(0.2),
        borderRadius: BorderRadius.circular(7.5),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(8, 4, 10, 4),
        child: SharezonePlusBadge(
          color: foregroundColor,
        ),
      ),
    );
  }
}

/// A card that displays the [SharezonePlusBadge] at the top center and a "Learn
/// more" button at the bottom center.
///
/// This card is typically used when the user tries to access a Sharezone Plus
/// feature without having Sharezone Plus.
class SharezonePlusFeatureInfoCard extends StatelessWidget {
  const SharezonePlusFeatureInfoCard({
    super.key,
    required this.child,
    this.withSharezonePlusBadge = true,
    this.withLearnMoreButton = false,
    this.onLearnMorePressed,
    this.maxWidth = 400,
    this.underlayColor,
  }) : assert(withLearnMoreButton == false || onLearnMorePressed != null);

  /// Whether the card should display the [SharezonePlusBadge] at the top
  /// center.
  final bool withSharezonePlusBadge;

  /// Weather the card should display the "Learn more" button at the bottom
  /// center.
  final bool withLearnMoreButton;

  /// The callback that is called when the "Learn more" button is pressed.
  ///
  /// Typically, this should navigate to the Sharezone Plus page. We can't
  /// provide a default implementation, because our current navigation
  /// implementation is in the app package.
  ///
  /// If [withLearnMoreButton] is `true`, this must not be `null`.
  final VoidCallback? onLearnMorePressed;

  /// The widget that is displayed below the [SharezonePlusBadge] and above the
  /// "Learn more" button.
  final Widget child;

  /// The maximum width of the card.
  final double maxWidth;

  /// The color displayed behind the card's semi-transparent background.
  ///
  /// This color serves as an underlay to the card, helping to maintain the
  /// visibility and integrity of the card's content by providing a solid
  /// background color. It can be useful when the card is displayed over varied
  /// or busy backgrounds, preventing the content behind the card from
  /// interfering visually with the card's content. In this case, you may want
  /// to use `Theme.of(context).scaffoldBackgroundColor` as the underlay color.
  ///
  /// When null, no underlay color is applied, and the card will blend with its
  /// background based on its existing opacity setting.
  final Color? underlayColor;

  @override
  Widget build(BuildContext context) {
    final fontColor = Theme.of(context).isDarkTheme
        ? Theme.of(context).primaryColor
        : darkPrimaryColor;
    final baseTheme = Theme.of(context);
    final borderRadius = BorderRadius.circular(12.5);
    return ConstrainedBox(
      constraints: BoxConstraints(
        maxWidth: maxWidth,
      ),
      child: Container(
        // Adding a base color to avoid that the card is a bit transparent
        // because the card color has a low opacity.
        decoration: BoxDecoration(
          borderRadius: borderRadius,
          color: underlayColor,
        ),
        child: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor.withOpacity(0.2),
            borderRadius: borderRadius,
          ),
          child: Theme(
            data: Theme.of(context).copyWith(
              textTheme: baseTheme.textTheme.copyWith(
                // Modifying also the `bodyMedium` style besides
                // `DefaultTextStyle` to update the text color for p elements in
                // the `MarkdownBody` widget of `flutter_markdown`.
                bodyMedium: baseTheme.textTheme.bodyMedium?.copyWith(
                  color: fontColor,
                ),
              ),
            ),
            child: DefaultTextStyle.merge(
              style: TextStyle(
                color: fontColor,
              ),
              textAlign: TextAlign.center,
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    if (withSharezonePlusBadge)
                      const Padding(
                        padding: EdgeInsets.fromLTRB(8, 4, 10, 4),
                        child: SharezonePlusBadge(),
                      ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: child,
                    ),
                    if (withLearnMoreButton)
                      Padding(
                        padding: const EdgeInsets.fromLTRB(8, 4, 10, 4),
                        child: TextButton(
                          onPressed: onLearnMorePressed,
                          style: TextButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            foregroundColor: fontColor,
                          ),
                          child: const Text(
                            'MEHR ERFAHREN',
                            style: TextStyle(
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
