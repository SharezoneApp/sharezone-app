bool isNotEmptyOrNull(String value) => !isEmptyOrNull(value);

bool isEmptyOrNull(String value) {
  return value == null || value.isEmpty;
}

void throwIfNullOrEmpty(String string, [String name]) {
  ArgumentError.checkNotNull(string, name);
  if (string.isEmpty) {
    throw ArgumentError.value(string, name ?? 'string', "can't be empty");
  }
}
