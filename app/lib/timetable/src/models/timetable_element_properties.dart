import 'package:quiver/core.dart';

/// Gibt Positionen für Elemente, welche in einem gemeinsamen Konflikt stehen, weil sie direkt
/// oder indirekt im zeitlichen Konflikt stehen.
class TimetableElementProperties {
  final int totalsAtThisPosition;
  final int index;

  const TimetableElementProperties(this.totalsAtThisPosition, this.index);

  static const TimetableElementProperties standard =
      TimetableElementProperties(1, 0);

  @override
  bool operator ==(other) {
    return other is TimetableElementProperties &&
        totalsAtThisPosition == other.totalsAtThisPosition &&
        index == other.index;
  }

  @override
  int get hashCode {
    return hash2(index.hashCode, totalsAtThisPosition.hashCode);
  }

  @override
  String toString() {
    return "TimetableElementProperties: index:$index, totalsAtThisPosition:$totalsAtThisPosition";
  }
}
