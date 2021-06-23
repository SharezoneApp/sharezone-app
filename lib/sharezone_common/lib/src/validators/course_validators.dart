import 'dart:async';
import '../validator.dart';

class CourseValidators {
  final validateSubject =
      StreamTransformer<String, String>.fromHandlers(handleData: (name, sink) {
    if (NotEmptyOrNullValidator(name).isValid()) {
      sink.add(name);
    } else {
      sink.addError(TextValidationException(emptySubjectUserMessage));
    }
  });

  static const emptySubjectUserMessage = "Bitte gib ein Fach an!";
}
