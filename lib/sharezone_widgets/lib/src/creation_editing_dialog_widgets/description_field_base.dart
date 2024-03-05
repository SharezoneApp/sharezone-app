// Copyright (c) 2024 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:flutter/material.dart';
import 'package:sharezone_widgets/sharezone_widgets.dart';

class DescriptionFieldBase extends StatelessWidget {
  const DescriptionFieldBase({
    super.key,
    required this.onChanged,
    required this.prefilledDescription,
    required this.hintText,
    this.textFieldKey,
  });

  final Function(String) onChanged;
  final String? prefilledDescription;
  final String hintText;

  /// Key for the [PrefilledTextField] (used for testing).
  ///
  /// If the key is assigned to [_DescriptionFieldBase] from the outside via
  /// this field to the [PrefilledTextField] then calling
  /// `tester.enterText(Key('description'))` will fail because of "too many
  /// elements" for the key. I don't really understand why this happens, but
  /// assigning the key to the [PrefilledTextField] fixes the problem.
  final Key? textFieldKey;

  @override
  Widget build(BuildContext context) {
    return MarkdownField(
      textFieldKey: textFieldKey,
      inputDecoration: InputDecoration(
        hintText: hintText,
        border: InputBorder.none,
        enabledBorder: InputBorder.none,
        focusedBorder: InputBorder.none,
        errorBorder: InputBorder.none,
        fillColor: Colors.transparent,
      ),
      onChanged: onChanged,
      prefilledText: prefilledDescription,
      icon: const Icon(Icons.subject),
    );
  }
}
