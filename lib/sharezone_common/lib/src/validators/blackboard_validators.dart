import 'dart:async';
import '../validator.dart';

class BlackboardValidators {
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
      "Bitte gib einen Titel für den Eintrag an!";
  static const emptyCourseUserMessage = "Bitte gib einen Kurs an!";
}
