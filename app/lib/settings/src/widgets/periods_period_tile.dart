import 'package:flutter/material.dart';
import 'package:user/user.dart';

class PeriodsPeriodTile extends StatelessWidget {
  final Period period;

  const PeriodsPeriodTile({Key key, this.period}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          Text(period.number.toString()),
          Text("${period.startTime} - ${period.endTime}"),
          TextButton(
            child: Text('Ändern'),
            onPressed: () {},
          )
        ],
      ),
    );
  }
}
