// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:helper_functions/helper_functions.dart';
import 'package:platform_check/platform_check.dart';
import 'package:sharezone_localizations/sharezone_localizations.dart';
import 'package:sharezone_widgets/sharezone_widgets.dart';

class SharecodeText extends StatelessWidget {
  const SharecodeText(this.sharecode, {super.key, this.onCopied});

  final String? sharecode;

  /// Wird nach dem Kopieren des Sharecodes in die Zwischenablage aufgerufen.
  /// Darf null sein.
  final VoidCallback? onCopied;

  @override
  Widget build(BuildContext context) {
    final style = TextStyle(
      color: Theme.of(context).isDarkTheme ? Colors.white : Colors.black,
      fontSize: 22,
      fontWeight: FontWeight.w500,
    );
    if (isEmptyOrNull(sharecode)) {
      return GrayShimmer(
        child: Text(context.l10n.groupsSharecodeLoading, style: style),
      );
    }

    return Semantics(
      label: context.l10n.groupsSharecodeSemanticsLabel(
        _screenReadableSharecode(context),
      ),
      child: InkWell(
        onTap: () => _handle(context),
        onLongPress: () => _handle(context),
        child: ExcludeSemantics(
          // Für die Web-App wird keine spezielle Schriftart genommen, da es
          // aktuell zu einem Crash kommt, wenn das Widget gebuildet wird.
          child:
              PlatformCheck.isWeb
                  ? Text(
                    context.l10n.groupsSharecodeText(sharecode!),
                    style: style,
                  )
                  : Text.rich(
                    TextSpan(
                      style: style,
                      children: [
                        TextSpan(text: context.l10n.groupsSharecodePrefix),
                        TextSpan(
                          text: "$sharecode",
                          style: TextStyle(
                            fontFamily: "PT MONO",
                            fontWeight: FontWeight.bold,
                            background:
                                Paint()
                                  ..color = Theme.of(
                                    context,
                                  ).primaryColor.withValues(alpha: 0.2),
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
      text: context.l10n.groupsSharecodeCopiedToClipboard,
    );
    if (onCopied != null) {
      onCopied!();
    }
  }

  void _copySharecode() => Clipboard.setData(ClipboardData(text: sharecode!));

  /// Returns the German character-by-character spelled version of the
  /// sharecode which can be read aloud by screen readers.
  ///
  /// Example: "X6wK" --> "großes X, 6, kleines w, großes K"
  String _screenReadableSharecode(BuildContext context) {
    return sharecode!.characters
        .map((char) => _spellOutCharacter(char, context))
        .reduce((a, b) => '$a, $b');
  }

  String _spellOutCharacter(String char, BuildContext context) {
    if (_isNonNumberLowercase(char)) {
      return context.l10n.groupsSharecodeLowercaseCharacter(char);
    } else if (_isNonNumberUppercase(char)) {
      return context.l10n.groupsSharecodeUppercaseCharacter(char);
    }
    return char;
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
