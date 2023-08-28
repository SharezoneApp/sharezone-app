// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'dart:async';
import '../validator.dart';

mixin BlackboardValidators {
  final validateTitle =
      StreamTransformer<String, String>.fromHandlers(handleData: (title, sink) {
    if (NotEmptyOrNullValidator(title).isValid()) {
      sink.add(title);
    } else {
      sink.addError(TextValidationException(emptyTitleUserMessage));
    }
  });

  static const emptyTitleUserMessage =
      "Bitte gib einen Titel für den Eintrag an!";
  static const emptyCourseUserMessage = "Bitte gib einen Kurs an!";
}
