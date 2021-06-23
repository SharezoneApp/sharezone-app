import 'package:sharezone_common/helper_functions.dart';

enum WeekType { always, a, b }

WeekType weekTypeEnumFromString(String data) =>
    enumFromString(WeekType.values, data, orElse: WeekType.always);

String weekTypeEnumToString(WeekType weekType) => enumToString(weekType);

String weekTypeEnumToGermanString(WeekType weekType) {
  switch (weekType) {
    case WeekType.always:
      return 'Immer';
    case WeekType.a:
      return 'A-Woche';
    case WeekType.b:
      return 'B-Woche';
  }
  return "";
}
