class Title implements Comparable<Title> {
  final String value;

  const Title(this.value);

  @override
  bool operator ==(other) {
    return identical(this, other) || other is Title && value == other.value;
  }

  @override
  int get hashCode => value.hashCode;

  @override
  int compareTo(Title other) {
    return value.compareTo(other.value);
  }

  @override
  String toString() {
    return 'Title(value: $value)';
  }
}
