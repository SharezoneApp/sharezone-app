// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'dart:async';

import 'package:sharezone_localizations/sharezone_localizations.dart';

import '../validator.dart';

mixin BlackboardValidators {
  SharezoneLocalizations get l10n;

  late final StreamTransformer<String, String> validateTitle =
      StreamTransformer<String, String>.fromHandlers(
        handleData: (title, sink) {
          if (NotEmptyOrNullValidator(title).isValid()) {
            sink.add(title);
          } else {
            sink.addError(
              TextValidationException(l10n.blackboardErrorTitleMissing),
            );
          }
        },
      );

  String get emptyCourseUserMessage => l10n.blackboardErrorCourseMissing;
}
