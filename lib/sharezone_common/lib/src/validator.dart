// ignore: one_member_abstracts
abstract class Validator {
  bool isValid();
}

class NotEmptyOrNullValidator implements Validator {
  final String _string;

  NotEmptyOrNullValidator(this._string);

  @override
  bool isValid() {
    if (_string != null && _string.isNotEmpty) return true;
    return false;
  }
}

class NotNullValidator implements Validator {
  final dynamic object;

  NotNullValidator(this.object);

  @override
  bool isValid() {
    if (object != null) return true;
    return false;
  }
}

abstract class Input {
  final List<Validator> validators;

  Input(this.validators);

  bool isValid() {
    return !validators.any((validator) => !validator.isValid());
  }
}

class TextValidationException implements Exception {
  final String message;

  TextValidationException([this.message]);

  @override
  String toString() => message ?? "TextValidationException";
}
