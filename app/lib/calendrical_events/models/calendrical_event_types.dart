import 'package:flutter/material.dart';
import 'package:sharezone/widgets/common/picker.dart';

abstract class CalendricalEventType {
  String get key;
  String get name;
  IconData get iconData;
  Color get color;

  @override
  bool operator ==(other) {
    return other.runtimeType == runtimeType && other.key == key;
  }

  @override
  int get hashCode {
    return key.hashCode;
  }
}

List<CalendricalEventType> getEventTypes() {
  return [
    Excursion(),
    Exam(),
    Meeting(),
    OtherEventType(),
  ];
}

CalendricalEventType getEventTypeFromString(String data) {
  switch (data) {
    case 'excursion':
      return Excursion();
    case 'exam':
      return Exam();
    case 'meeting':
      return Meeting();
    case 'other':
      return OtherEventType();
    default:
      return OtherEventType();
  }
}

String getEventTypeToString(CalendricalEventType eventType) {
  return (eventType ?? OtherEventType()).key;
}

class Excursion extends CalendricalEventType {
  @override
  Color color = Colors.blue;

  @override
  IconData iconData = Icons.trip_origin;

  @override
  String key = "excursion";

  @override
  String name = "Ausflug";
}

class Exam extends CalendricalEventType {
  @override
  Color color = Colors.red;

  @override
  IconData iconData = Icons.note;

  @override
  String key = "exam";

  @override
  String name = "Prüfung";
}

class Meeting extends CalendricalEventType {
  @override
  Color color = Colors.orange;

  @override
  IconData iconData = Icons.note;

  @override
  String key = "meeting";

  @override
  String name = "Veranstaltung";
}

class OtherEventType extends CalendricalEventType {
  @override
  Color color = Colors.purple;

  @override
  IconData iconData = Icons.more_vert;

  @override
  String key = "other";

  @override
  String name = "Anderes";
}

Future<CalendricalEventType> selectEventType(BuildContext context, {CalendricalEventType selected}) {
  return selectItem<CalendricalEventType>(
    context: context,
    items: getEventTypes(),
    builder: (context, item) {
      bool isSelected = selected == item;
      return ListTile(
        leading: Icon(
          item.iconData,
          color: item.color,
        ),
        title: Text(item.name),
        trailing: isSelected
            ? Icon(
                Icons.done,
                color: Colors.green,
              )
            : null,
        onTap: () => Navigator.pop(context, item),
      );
    },
  );
}
