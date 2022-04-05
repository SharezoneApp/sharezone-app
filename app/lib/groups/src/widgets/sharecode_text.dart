// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:characters/characters.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sharezone_utils/platform.dart';
import 'package:sharezone_widgets/additional.dart';
import 'package:sharezone_widgets/snackbars.dart';
import 'package:sharezone_widgets/theme.dart';

class SharecodeText extends StatelessWidget {
  const SharecodeText(this.sharecode, {this.onCopied});

  final String sharecode;

  /// Wird nach dem Kopieren des Sharecodes in die Zwischenablage aufgerufen.
  /// Darf null sein.
  final VoidCallback onCopied;

  @override
  Widget build(BuildContext context) {
    final style = TextStyle(
      color: isDarkThemeEnabled(context) ? Colors.white : Colors.black,
      fontSize: 22,
      fontWeight: FontWeight.w500,
    );
    if (sharecode == null || sharecode.isEmpty) {
      return GrayShimmer(
        child: Text("Sharecode wird geladen...", style: style),
      );
    }

    return Semantics(
      label: 'Sharecode: $_screenReadableSharecode',
      child: InkWell(
        onTap: () => _handle(context),
        onLongPress: () => _handle(context),
        child: ExcludeSemantics(
          // Für die Web-App wird keine spezielle Schriftart genommen, da es
          // aktuell zu einem Crash kommt, wenn das Widget gebuildet wird.
          child: PlatformCheck.isWeb
              ? Text("Sharecode: $sharecode", style: style)
              : Text.rich(
                  TextSpan(
                    style: style,
                    children: [
                      const TextSpan(text: "Sharecode: "),
                      TextSpan(
                        text: "$sharecode",
                        style: TextStyle(
                          fontFamily: "PT MONO",
                          fontWeight: FontWeight.bold,
                          background: Paint()
                            ..color =
                                Theme.of(context).primaryColor.withOpacity(0.2),
                        ),
                      ),
                    ],
                  ),
                ),
        ),
      ),
    );
  }

  void _handle(BuildContext context) {
    _copySharecode();
    showSnackSec(
      context: context,
      seconds: 2,
      text: 'Sharecode wurde in die Zwischenablage kopiert.',
    );
    if (onCopied != null) {
      onCopied();
    }
  }

  void _copySharecode() => Clipboard.setData(ClipboardData(text: sharecode));

  /// Returns the German character-by-character spelled version of the
  /// sharecode which can be read aloud by screen readers.
  ///
  /// Example: "X6wK" --> "großes X, 6, kleines w, großes K"
  String get _screenReadableSharecode {
    return sharecode.characters
        .map(_spellOutCharacter)
        .reduce((a, b) => '$a, $b');
  }

  String _spellOutCharacter(String char) {
    if (_isNonNumberLowercase(char)) {
      return 'kleines $char';
    } else if (_isNonNumberUppercase(char)) {
      return 'großes $char';
    }
    return '$char';
  }

  bool _isNonNumberLowercase(String currentChar) {
    return !currentChar.isNumber && currentChar.isLowercase;
  }

  bool _isNonNumberUppercase(String currentChar) {
    return !currentChar.isNumber && currentChar.isUppercase;
  }
}

extension on String {
  bool get isNumber {
    assert(length == 1);
    return '0123456789'.contains(this);
  }

  bool get isLowercase => toLowerCase() == this;
  bool get isUppercase => toUpperCase() == this;
}
