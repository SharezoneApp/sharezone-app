// Copyright (c) 2023 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:flutter/material.dart';
import 'package:sharezone_widgets/src/sharezone_plus/sharezone_plus_widgets.dart';

/// Shows a dialog with information about the Sharezone Plus feature.
Future<void> showSharezonePlusFeatureInfoDialog({
  required BuildContext context,
  required VoidCallback navigateToPlusPage,
  required Widget description,
  Widget? title,
}) async {
  final shouldNavigateToPlusPage = await showDialog<bool>(
    context: context,
    builder: (_) => _SharezonePlusFeatureInfoDialog(
      title: title,
      description: description,
    ),
  );
  if (shouldNavigateToPlusPage == true) {
    navigateToPlusPage();
  }
}

class _SharezonePlusFeatureInfoDialog extends StatelessWidget {
  const _SharezonePlusFeatureInfoDialog({
    this.title,
    required this.description,
  }) : super(key: const Key('sharezone-plus-feature-info-dialog'));

  final Widget? title;
  final Widget description;

  @override
  Widget build(BuildContext context) {
    final buttonShape = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12.5),
    );
    return AlertDialog(
      title: title == null
          ? null
          : Center(
              child: DefaultTextStyle.merge(
                textAlign: TextAlign.center,
                child: title!,
              ),
            ),
      content: SharezonePlusFeatureInfoCard(
        withLearnMoreButton: false,
        child: description,
      ),
      actionsPadding: const EdgeInsets.fromLTRB(16, 0, 24, 24),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          style: TextButton.styleFrom(
            foregroundColor: Theme.of(context).primaryColor,
            shape: buttonShape,
          ),
          child: const Text('ZURÜCK'),
        ),
        ElevatedButton(
          onPressed: () => Navigator.of(context).pop(true),
          style: ElevatedButton.styleFrom(
            backgroundColor: Theme.of(context).primaryColor,
            elevation: 0,
            shadowColor: Colors.transparent,
            shape: buttonShape,
          ),
          child: const Text('MEHR ERFAHREN'),
        ),
      ],
    );
  }
}
