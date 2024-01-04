// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:flutter/material.dart';
import 'package:sharezone_widgets/sharezone_widgets.dart';

class OverlayCard extends StatelessWidget {
  final Widget? title;
  final Widget? content;

  final VoidCallback? onClose;

  final String? actionText;
  final VoidCallback? onAction;

  const OverlayCard({
    super.key,
    this.title,
    this.content,
    this.onClose,
    this.actionText,
    this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Align(
        alignment: Alignment.bottomRight,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 400),
          child: Material(
            elevation: 10,
            color: Theme.of(context).isDarkTheme
                ? ElevationColors.dp4
                : Colors.white,
            shadowColor: Colors.black.withOpacity(0.6),
            borderRadius: BorderRadius.circular(10),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (title != null) _Title(title: title),
                  const SizedBox(height: 8),
                  if (content != null) _Content(content: content),
                  const SizedBox(height: 14),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Wrap(
                      alignment: WrapAlignment.end,
                      children: [
                        _Close(onClose: onClose),
                        const SizedBox(width: 8),
                        if (actionText != null)
                          _Action(onAction: onAction, actionText: actionText),
                      ],
                    ),
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

class _Action extends StatelessWidget {
  const _Action({
    required this.onAction,
    required this.actionText,
  });

  final VoidCallback? onAction;
  final String? actionText;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: actionText,
      button: true,
      enabled: true,
      onTap: onAction,
      child: TextButton(
        onPressed: onAction,
        style: TextButton.styleFrom(
          foregroundColor: Theme.of(context).primaryColor,
          backgroundColor: Theme.of(context).primaryColor.withOpacity(0.15),
        ),
        child: Text(actionText!),
      ),
    );
  }
}

class _Close extends StatelessWidget {
  const _Close({required this.onClose});

  final VoidCallback? onClose;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'Schließe die Karte',
      button: true,
      enabled: true,
      onTap: onClose,
      child: TextButton(
        onPressed: onClose,
        style: TextButton.styleFrom(
          foregroundColor: Colors.grey,
        ),
        child: const Text("SCHLIESSEN"),
      ),
    );
  }
}

class _Content extends StatelessWidget {
  const _Content({required this.content});

  final Widget? content;

  @override
  Widget build(BuildContext context) {
    return DefaultTextStyle(
      style: const TextStyle(
        color: Colors.grey,
        fontFamily: rubik,
      ),
      child: content!,
    );
  }
}

class _Title extends StatelessWidget {
  const _Title({required this.title});

  final Widget? title;

  @override
  Widget build(BuildContext context) {
    return DefaultTextStyle(
      style: TextStyle(
        fontSize: 18,
        fontFamily: rubik,
        color: Theme.of(context).isDarkTheme ? Colors.white : Colors.black,
        fontWeight: FontWeight.w600,
      ),
      child: title!,
    );
  }
}
