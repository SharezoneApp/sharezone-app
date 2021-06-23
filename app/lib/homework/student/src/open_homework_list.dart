import 'package:bloc_provider/bloc_provider.dart';
import 'package:flutter/material.dart';
import 'package:hausaufgabenheft_logik/hausaufgabenheft_logik.dart';
import 'package:sharezone/homework/shared/shared.dart';
import 'package:sharezone/homework/student/src/completed_homework_list.dart';

import 'homework_tile.dart';
import 'mark_overdue_homework_prompt.dart';
import 'util.dart';

/// The [OpenHomeworkList] shown in the open tab of the student
/// homework page.
///
/// Instead of [CompletedHomeworkList] this list is not intended for lazy
/// loading.
class OpenHomeworkList extends StatelessWidget {
  final OpenHomeworkListView homeworkListView;
  final Color overscrollColor;

  /// Whether to show the [MarkOverdueHomeworkPrompt] to the user.
  ///
  /// Attention:
  /// Depending on the [OverdueHomeworkDialogDismissedCache] state
  /// this does not always mean that the [MarkOverdueHomeworkPrompt]
  /// is displayed to the user if [showCompleteAllOverdueCard] is true.
  final bool showCompleteAllOverdueCard;

  const OpenHomeworkList({
    Key key,
    @required this.homeworkListView,
    @required this.overscrollColor,
    this.showCompleteAllOverdueCard = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<HomeworkPageBloc>(context);

    if (_nullOrEmpty(homeworkListView.sections)) return Container();
    return GlowingOverscrollColorChanger(
      color: overscrollColor,
      child: AnimatedStaggeredScrollView(
        children: [
          if (showCompleteAllOverdueCard) MarkOverdueHomeworkPrompt(),
          for (final section in homeworkListView.sections)
            HomeworkListSection(
              title: section.title,
              children: [
                for (final hw in section.homeworks)
                  HomeworkTile(
                    key: Key('${hw.id}${hw.isCompleted}'),
                    homework: hw,
                    onChanged: (newStatus) {
                      // Spamming the checkbox causes the homework to sometimes
                      // get checked and unchecked again, which we do not want.
                      if (newStatus == HomeworkStatus.completed) {
                        dispatchCompletionStatusChange(newStatus, hw.id, bloc);
                      }
                    },
                  ),
              ],
            ),
        ],
      ),
    );
  }

  bool _nullOrEmpty(List<HomeworkSectionView> homeworkSections) =>
      homeworkSections == null || homeworkSections.isEmpty;
}
