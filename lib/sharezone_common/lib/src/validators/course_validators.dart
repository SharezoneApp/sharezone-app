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

mixin CourseValidators {
  SharezoneLocalizations get l10n;

  late final StreamTransformer<String, String> validateSubject =
      StreamTransformer<String, String>.fromHandlers(
        handleData: (name, sink) {
          if (NotEmptyOrNullValidator(name).isValid()) {
            sink.add(name);
          } else {
            sink.addError(
              TextValidationException(l10n.commonErrorCourseSubjectMissing),
            );
          }
        },
      );
}
