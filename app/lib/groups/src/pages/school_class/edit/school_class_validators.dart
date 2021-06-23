import 'dart:async';
import 'package:sharezone_common/api_errors.dart';
import 'package:sharezone_common/validators.dart';

class SchoolClassValidators {
  final validateName =
      StreamTransformer<String, String>.fromHandlers(handleData: (name, sink) {
    if (NotEmptyOrNullValidator(name).isValid()) {
      sink.add(name);
    } else {
      sink.addError(EmptyNameException().toString());
    }
  });
}
