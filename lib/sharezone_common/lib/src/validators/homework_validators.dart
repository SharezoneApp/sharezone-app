import 'dart:async';

import 'package:sharezone_common/validators.dart';

class HomeworkValidators {
  final validateTitle =
      StreamTransformer<String, String>.fromHandlers(handleData: (title, sink) {
    if (title != null) {
      if (NotEmptyOrNullValidator(title).isValid()) {
        sink.add(title);
      } else {
        sink.addError(TextValidationException(emptyTitleUserMessage));
      }
    }
  });

  static const emptyTitleUserMessage =
      "Bitte gib einen Titel für die Hausaufgabe an!";
  static const emptyCourseUserMessage =
      "Bitte gib einen Kurs für die Hausaufgabe an!";
}
