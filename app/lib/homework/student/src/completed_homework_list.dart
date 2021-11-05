import 'package:bloc_provider/bloc_provider.dart';
import 'package:flutter/material.dart';
import 'package:hausaufgabenheft_logik/hausaufgabenheft_logik.dart';
import 'package:sharezone/homework/shared/shared.dart';
import 'package:sharezone/homework/student/src/util.dart';

import 'homework_tile.dart';

class CompletedHomeworkList extends StatelessWidget {
  final CompletedHomeworkListView view;
  final HomeworkPageBloc bloc;

  const CompletedHomeworkList({
    Key key,
    @required this.view,
    @required this.bloc,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LazyLoadingHomeworkList(
      loadedAllHomeworks: view.loadedAllCompletedHomeworks,
      loadMoreHomeworksCallback: () => bloc.add(AdvanceCompletedHomeworks(10)),
      children: [
        for (final hw in view.orderedHomeworks)
          HomeworkTile(
            homework: hw,
            onChanged: (newStatus) {
              // Spamming the checkbox causes the homework to sometimes
              // get unchecked and checked again, which we do not want.
              if (newStatus == HomeworkStatus.open) {
                final bloc = BlocProvider.of<HomeworkPageBloc>(context);
                dispatchCompletionStatusChange(newStatus, hw.id, bloc);
              }
            },
          )
      ],
    );
  }
}
