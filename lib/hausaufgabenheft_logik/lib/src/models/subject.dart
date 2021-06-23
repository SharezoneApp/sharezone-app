import 'package:hausaufgabenheft_logik/src/views/color.dart';
import 'package:optional/optional.dart';

class Subject {
  final String name;
  final Color _color;

  Subject(this.name, {Color color}) : _color = color {
    if (name == null) {
      throw ArgumentError.notNull(name);
    }
    if (name.isEmpty) {
      throw ArgumentError.value(
          name, 'name', "The subject name can't be empty");
    }
  }

  String get abbreviation => name.length >= 2 ? name.substring(0, 2) : name;
  Optional<Color> get color => Optional.ofNullable(_color);

  @override
  int get hashCode => name.hashCode;

  bool get isValid => name != null && name.isNotEmpty;

  @override
  bool operator ==(other) {
    return identical(this, other) ||
        other is Subject && name == other.name && color == other.color;
  }

  @override
  String toString() {
    return 'Subject(name: $name, color: $color)';
  }
}
