// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

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
    super.key,
    required this.view,
    required this.bloc,
  });

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
