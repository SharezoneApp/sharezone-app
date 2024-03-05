import 'package:flutter/material.dart';
import 'package:sharezone_widgets/sharezone_widgets.dart';

class ErrorCard extends StatelessWidget {
  const ErrorCard({
    super.key,
    required this.message,
    this.onRetry,
    this.onContactSupport,
  });

  final Widget message;

  /// Called presses the retry button.
  ///
  /// If `null`, the retry button is not shown.
  final VoidCallback? onRetry;

  /// Called when the user presses the contact support button.
  ///
  /// If `null`, the contact support button is not shown.
  final VoidCallback? onContactSupport;

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.error;
    return SelectionArea(
      child: CustomCard(
        padding: const EdgeInsets.all(12),
        color: color.withOpacity(0.1),
        borderColor: color.withOpacity(0.2),
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
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Es ist ein Fehler aufgetreten!',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 12),
                          message,
                        ],
                      ),
                    ),
                    if (onRetry != null || onContactSupport != null) ...[
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 8,
                        children: [
                          if (onRetry != null)
                            _RetryButton(onPressed: onRetry!),
                          if (onContactSupport != null)
                            _ContactSupport(onPressed: onContactSupport!),
                        ],
                      ),
                    ]
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RetryButton extends StatelessWidget {
  const _RetryButton({
    required this.onPressed,
  });

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return _ErrorActionButtons(
      key: const Key('retry-button'),
      onPressed: onPressed,
      child: const Text('ERNEUT VERSUCHEN'),
    );
  }
}

class _ContactSupport extends StatelessWidget {
  const _ContactSupport({
    required this.onPressed,
  });

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return _ErrorActionButtons(
      key: const Key('contact-support-button'),
      onPressed: onPressed,
      child: const Text('SUPPORT KONTAKTIEREN'),
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
