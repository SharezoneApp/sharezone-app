import 'package:bloc_provider/bloc_provider.dart';
import 'package:flutter/material.dart';
import 'package:sharezone/widgets/common/picker.dart';
import 'package:user/user.dart';

import 'bloc/timetable_bloc.dart';

Future<Period> selectPeriod(BuildContext context, {Period selected}) {
  final bloc = BlocProvider.of<TimetableBloc>(context);
  final periods = bloc.current.getPeriods();
  return selectItem<Period>(
    context: context,
    items: periods.getPeriods(),
    builder: (context, item) {
      bool isSelected = selected == item;
      return ListTile(
        leading: Text(
          item.number.toString(),
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 18,
          ),
        ),
        title: Text("${item.startTime} - ${item.endTime}"),
        trailing: isSelected
            ? Icon(
                Icons.done,
                color: Colors.green,
              )
            : null,
        onTap: () {
          Navigator.pop(context, item);
        },
      );
    },
  );
}
