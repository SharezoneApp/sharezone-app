import 'package:flutter/material.dart';

class SharezoneTimeOfDay extends TimeOfDay {
  const SharezoneTimeOfDay({@required int hour, @required int minute})
      : super(hour: hour, minute: minute);

  String toStringShort() {
    final hour = _ifNecessaryAddZeroCharacter(this.hour);
    final minute = _ifNecessaryAddZeroCharacter(this.minute);

    return "$hour:$minute";
  }

  String _ifNecessaryAddZeroCharacter(int timeUnit) {
    final stringVal = timeUnit.toString();
    if (timeUnit == 0) return "${stringVal}0";
    if (timeUnit > 0 && timeUnit < 10) return "0$stringVal";
    return stringVal;
  }
}