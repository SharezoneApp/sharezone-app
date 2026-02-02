// Copyright (c) 2024 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:flutter/material.dart';
import 'package:sharezone_localizations/sharezone_localizations.dart';
import 'package:sharezone_widgets/sharezone_widgets.dart';

class ErrorCard extends StatelessWidget {
  const ErrorCard({
    super.key,
    required this.message,
    this.onRetryPressed,
    this.onContactSupportPressed,
  });

  final Widget message;

  /// Called presses the retry button.
  ///
  /// If `null`, the retry button is not shown.
  final VoidCallback? onRetryPressed;

  /// Called when the user presses the contact support button.
  ///
  /// If `null`, the contact support button is not shown.
  final VoidCallback? onContactSupportPressed;

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.error;
    return CustomCard(
      padding: const EdgeInsets.all(12),
      color: color.withValues(alpha: 0.1),
      borderColor: color.withValues(alpha: 0.2),
      child: Row(
        children: [
          Icon(
            Icons.error,
            size: 40,
            color: Theme.of(context).colorScheme.error,
          ),
          const SizedBox(width: 12),
          Flexible(
            child: DefaultTextStyle.merge(
              style: TextStyle(color: color),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 12),
                    child: SelectionArea(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            context.l10n.sharezoneWidgetsErrorCardTitle,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 12),
                          message,
                        ],
                      ),
                    ),
                  ),
                  if (onRetryPressed != null ||
                      onContactSupportPressed != null) ...[
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      children: [
                        if (onRetryPressed != null)
                          _RetryButton(onPressed: onRetryPressed!),
                        if (onContactSupportPressed != null)
                          _ContactSupport(onPressed: onContactSupportPressed!),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _RetryButton extends StatelessWidget {
  const _RetryButton({required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return _ErrorActionButtons(
      key: const Key('retry-button'),
      onPressed: onPressed,
      child: Text(context.l10n.sharezoneWidgetsErrorCardRetry),
    );
  }
}

class _ContactSupport extends StatelessWidget {
  const _ContactSupport({required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return _ErrorActionButtons(
      key: const Key('contact-support-button'),
      onPressed: onPressed,
      child: Text(context.l10n.sharezoneWidgetsErrorCardContactSupport),
    );
  }
}

class _ErrorActionButtons extends StatelessWidget {
  const _ErrorActionButtons({
    super.key,
    required this.onPressed,
    required this.child,
  });

  final VoidCallback onPressed;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        foregroundColor: Theme.of(context).colorScheme.error,
      ),
      child: child,
    );
  }
}
