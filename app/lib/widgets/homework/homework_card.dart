import 'package:common_domain_models/common_domain_models.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:group_domain_models/group_domain_models.dart';

import 'package:intl/intl.dart';
import 'package:analytics/analytics.dart';
import 'package:sharezone/blocs/application_bloc.dart';
import 'package:bloc_provider/bloc_provider.dart';
import 'package:sharezone/blocs/homework/homework_card_bloc.dart';
import 'package:sharezone/dashboard/models/homework_view.dart';
import 'package:firebase_hausaufgabenheft_logik/firebase_hausaufgabenheft_logik.dart';
import 'package:sharezone/groups/src/pages/course/course_card.dart';
import 'package:sharezone/homework/teacher/homework_done_by_users_list/homework_completion_user_list_page.dart';
import 'package:sharezone/pages/homework/homework_details/homework_details.dart';
import 'package:sharezone/pages/homework/homework_details/homework_details_view_factory.dart';
import 'package:sharezone/pages/homework/homework_details/submissions/homework_list_submissions_page.dart';
import 'package:sharezone/pages/homework/homework_permissions.dart';
import 'package:sharezone/pages/homework_page.dart';
import 'package:sharezone/report/page/report_page.dart';
import 'package:sharezone/report/report_icon.dart';
import 'package:sharezone/report/report_item.dart';
import 'package:sharezone/util/api/connectionsGateway.dart';
import 'package:sharezone/util/navigation_service.dart';
import 'package:sharezone_widgets/adaptive_dialog.dart';
import 'package:sharezone_widgets/theme.dart';
import 'package:sharezone/widgets/homework/delete_homework.dart';
import 'package:sharezone_widgets/widgets.dart';
import 'package:sharezone_widgets/snackbars.dart';
import 'package:user/user.dart';

enum _HomeworkTileLongPressModelSheetOption { delete, edit, done, report }

class HomeworkCard extends StatelessWidget {
  const HomeworkCard({
    this.homework,
    this.typeOfUser = TypeOfUser.student,
    this.markedDate = true,
  });

  final HomeworkDto homework;
  final TypeOfUser typeOfUser;
  final bool markedDate;

  @override
  Widget build(BuildContext context) {
    final api = BlocProvider.of<SharezoneContext>(context).api;
    final bloc = HomeworkCardBloc(api, homework);
    final analytics = BlocProvider.of<SharezoneContext>(context).analytics;

    DateTime tomorrowWithoutTime = DateTime(
        DateTime.now().year, DateTime.now().month, DateTime.now().day + 1);
    DateTime todoUntilWithoutTime = DateTime(homework.todoUntil.year,
        homework.todoUntil.month, homework.todoUntil.day);

    return BlocProvider(
      bloc: bloc,
      child: CustomCard(
        onTap: () async {
          final detailsViewFactory =
              BlocProvider.of<HomeworkDetailsViewFactory>(context);
          final detailsView = await detailsViewFactory.fromHomeworkDb(homework);

          return pushWithDefault<bool>(
            context,
            HomeworkDetails(detailsView),
            defaultValue: false,
            name: HomeworkDetails.tag,
          ).then((value) {
            if (value) showDataArrivalConfirmedSnackbar(context: context);
          });
        },
        onLongPress: () async {
          final detailsViewFactory =
              BlocProvider.of<HomeworkDetailsViewFactory>(context);
          final detailsView = await detailsViewFactory.fromHomeworkDb(homework);

          _logHomeworkCardLongPress(analytics);

          final isStudent = typeOfUser == TypeOfUser.student;
          final longPressList =
              <LongPress<_HomeworkTileLongPressModelSheetOption>>[
            if (isStudent)
              LongPress(
                title: 'Als erledigt markieren',
                icon: const Icon(Icons.done),
                popResult: _HomeworkTileLongPressModelSheetOption.done,
              ),
            LongPress(
              title: "Melden",
              popResult: _HomeworkTileLongPressModelSheetOption.report,
              icon: reportIcon,
            ),
            if (detailsView.hasPermission) ...[
              LongPress(
                title: 'Bearbeiten',
                icon: const Icon(Icons.edit),
                popResult: _HomeworkTileLongPressModelSheetOption.edit,
              ),
              LongPress(
                title: 'Löschen',
                icon: const Icon(Icons.delete),
                popResult: _HomeworkTileLongPressModelSheetOption.delete,
              )
            ]
          ];
          final result = await showLongPressAdaptiveDialog<
              _HomeworkTileLongPressModelSheetOption>(
            context: context,
            longPressList: longPressList,
            title: "Hausaufgabe: ${homework.title}",
          );

          switch (result) {
            case _HomeworkTileLongPressModelSheetOption.done:
              _logHomeworkDoneViaCardLongPress(analytics);
              bloc.toggleIsDone.add(true);
              break;
            case _HomeworkTileLongPressModelSheetOption.edit:
              _logHomeworkEditViaCardLongPress(analytics);
              openHomeworkDialogAndShowConfirmationIfSuccessful(
                context,
                homework: homework,
              );
              break;
            case _HomeworkTileLongPressModelSheetOption.delete:
              _logHomeworkDeleteViaCardLongPress(analytics);
              await deleteHomeworkDialogsEntry(context, homework,
                  popTwice: false);
              break;
            case _HomeworkTileLongPressModelSheetOption.report:
              _logHomeworkReportViaCardLongPress(analytics);
              final reportItem = ReportItemReference.homework(homework.id);
              openReportPage(context, reportItem);
              break;
          }
        },
        child: ListTile(
          title: Text(
            homework.title,
            overflow: TextOverflow.ellipsis,
            maxLines: 2,
          ),
          isThreeLine: true,
          subtitle: Text.rich(
            TextSpan(children: <TextSpan>[
              TextSpan(text: "${homework.courseName}\n"),
              TextSpan(
                  text:
                      "${_formatTodoUntil(homework.todoUntil, homework.withSubmissions)}",
                  style: markedDate
                      ? tomorrowWithoutTime
                                  .isAtSameMomentAs(todoUntilWithoutTime) ||
                              todoUntilWithoutTime.isBefore(tomorrowWithoutTime)
                          ? TextStyle(color: Colors.red)
                          : null
                      : null),
            ], style: TextStyle(color: Colors.grey[600])),
          ),
          leading: CourseCircleAvatar(
            courseId: homework.courseID,
            heroTag: homework.id,
            abbreviation: homework.subjectAbbreviation,
          ),
          trailing: _getTrailingWidget(context),
        ),
      ),
    );
  }

  String _formatTodoUntil(DateTime todoUntil, bool withSubmissions) {
    final dateString = DateFormat.yMMMd().format(todoUntil);
    if (!withSubmissions) return dateString;
    return '$dateString - ${todoUntil.hour}:${_getMinute(todoUntil.minute)} Uhr';
  }

  String _getMinute(int minute) {
    if (minute >= 10) return minute.toString();
    return '0$minute';
  }

  Widget _getTrailingWidget(BuildContext context) {
    final api = BlocProvider.of<SharezoneContext>(context).api;
    final bloc = HomeworkCardBloc(api, homework);
    final analytics = BlocProvider.of<SharezoneContext>(context).analytics;

    if (typeOfUser == TypeOfUser.parent) return null;
    if (typeOfUser == TypeOfUser.student) {
      return StreamBuilder<bool>(
        stream: bloc.isDone,
        builder: (context, snapshot) {
          if (!snapshot.hasData) return Text("");
          return Checkbox(
            value: snapshot.data,
            onChanged: (value) {
              if (value)
                analytics.log(AnalyticsEvent("homework_done"));
              else
                analytics.log(AnalyticsEvent("homework_undone"));
              bloc.toggleIsDone.add(value);
            },
            tristate: false,
          );
        },
      );
    } else {
      return IconButton(
        iconSize: 50,
        icon: Chip(
          label: Text(
            '${homework.withSubmissions ? homework?.submitters?.length ?? 0 : homework.assignedUserArrays.completedStudentUids.length ?? 0}',
          ),
        ),
        onPressed: () {
          if (_isAdmin(context, homework.courseID)) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => homework.withSubmissions
                    ? HomeworkUserSubmissionsPage(homeworkId: homework.id)
                    : HomeworkCompletionUserListPage(
                        homeworkId: HomeworkId(homework.id),
                      ),
              ),
            );
          } else {
            if (homework.withSubmissions) {
              showTeacherMustBeAdminDialogToViewSubmissions(context);
            } else {
              showTeacherMustBeAdminDialogToViewCompletionList(context);
            }
          }
        },
      );
    }
  }

  MemberRole _getMemberRole(ConnectionsGateway gateway, String courseID) {
    final connectionsData = gateway.current();
    if (connectionsData != null) {
      final courses = connectionsData.courses;
      if (courses != null) {
        return courses[courseID]?.myRole;
      }
    }
    return MemberRole.none;
  }

  bool _isAdmin(BuildContext context, String courseID) {
    final connectionsGateway =
        BlocProvider.of<SharezoneContext>(context).api.connectionsGateway;
    final role = _getMemberRole(connectionsGateway, courseID);
    return role == MemberRole.admin || role == MemberRole.owner;
  }
}

class HomeworkCardRedesigned extends StatelessWidget {
  const HomeworkCardRedesigned({
    Key key,
    this.homeworkView,
    this.withUrgentText = true,
    this.width,
    this.forceIsDone,
    this.padding,
  }) : super(key: key);

  final HomeworkView homeworkView;
  final bool withUrgentText;
  final double width;
  final EdgeInsets padding;

  /// This bool is to forcing the homework to be marked as done
  /// in the ui.
  final bool forceIsDone;

  @override
  Widget build(BuildContext context) {
    final api = BlocProvider.of<SharezoneContext>(context).api;
    final bloc = HomeworkCardBloc(api, homeworkView.homework);
    return BlocProvider<HomeworkCardBloc>(
      bloc: bloc,
      child: StreamBuilder<TypeOfUser>(
        stream: api.user.userStream.map((user) => user.typeOfUser),
        builder: (context, snapshot) {
          final typeOfUser = snapshot.data ?? TypeOfUser.student;
          return Padding(
            padding: padding ?? EdgeInsets.only(left: 12),
            child: CustomCard(
              size: Size(
                  115, width ?? (MediaQuery.of(context).size.width / 2) - 36),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      _Checkbox(isDone: forceIsDone, typeOfUser: typeOfUser),
                      _CourseName(
                        courseName: homeworkView.courseName,
                        color: homeworkView.courseNameColor,
                        typeOfUser: typeOfUser,
                      )
                    ],
                  ),
                  _Title(homeworkView.title, isDone: forceIsDone),
                  _TodoUntil(
                    date: homeworkView.todoUntilText,
                    color: homeworkView.todoUntilColor,
                  )
                ],
              ),
              onTap: () async {
                final detailsViewFactory =
                    BlocProvider.of<HomeworkDetailsViewFactory>(context);
                final homeworkDetailsView = await detailsViewFactory
                    .fromHomeworkDb(homeworkView.homework);
                pushWithDefault<bool>(
                  context,
                  HomeworkDetails(homeworkDetailsView),
                  defaultValue: false,
                  name: HomeworkDetails.tag,
                ).then((value) {
                  if (value) showDataArrivalConfirmedSnackbar(context: context);
                });
              },
              onLongPress: () => showLongPressIfUserHasPermissions(
                  context, bloc.toggleIsDone.add, homeworkView),
            ),
          );
        },
      ),
    );
  }
}

void _logHomeworkCardLongPress(Analytics analytics) {
  analytics.log(AnalyticsEvent("homework_card_long_press"));
}

void _logHomeworkDoneViaCardLongPress(Analytics analytics) {
  analytics.log(AnalyticsEvent("homework_done_via_card_long_press"));
}

void _logHomeworkDeleteViaCardLongPress(Analytics analytics) {
  analytics.log(AnalyticsEvent("homework_delete_via_card_long_press"));
}

void _logHomeworkEditViaCardLongPress(Analytics analytics) {
  analytics.log(AnalyticsEvent("homework_edit_via_card_long_press"));
}

void _logHomeworkReportViaCardLongPress(Analytics analytics) {
  analytics.log(AnalyticsEvent("homework_report_via_card_long_press"));
}

Future showLongPressIfUserHasPermissions(
    BuildContext context,
    void Function(bool newHomeworkStatus) setHomeworkStatus,
    HomeworkView homeworkView) async {
  final sharezoneContext = BlocProvider.of<SharezoneContext>(context);
  final api = sharezoneContext.api;
  final analytics = sharezoneContext.analytics;
  final typeOfUser = api.user.data.typeOfUser;

  _logHomeworkCardLongPress(analytics);

  final isAuthor = api.uID == homeworkView.homework.authorID;
  final hasPermission = hasPermissionToManageHomeworks(
    api.course
        .getRoleFromCourseNoSync(homeworkView.homework.courseReference.id),
    isAuthor,
  );
  final isStudent = typeOfUser == TypeOfUser.student;

  final longPressList = <LongPress<_HomeworkTileLongPressModelSheetOption>>[
    if (isStudent)
      LongPress(
        title: 'Als erledigt markieren',
        icon: const Icon(Icons.done),
        popResult: _HomeworkTileLongPressModelSheetOption.done,
      ),
    LongPress(
      title: "Melden",
      popResult: _HomeworkTileLongPressModelSheetOption.report,
      icon: reportIcon,
    ),
    if (hasPermission) ...[
      LongPress(
        title: 'Bearbeiten',
        icon: const Icon(Icons.edit),
        popResult: _HomeworkTileLongPressModelSheetOption.edit,
      ),
      LongPress(
        title: 'Löschen',
        icon: const Icon(Icons.delete),
        popResult: _HomeworkTileLongPressModelSheetOption.delete,
      )
    ]
  ];
  final result =
      await showLongPressAdaptiveDialog<_HomeworkTileLongPressModelSheetOption>(
    context: context,
    longPressList: longPressList,
    title: "Hausaufgabe: ${homeworkView.title}",
  );

  switch (result) {
    case _HomeworkTileLongPressModelSheetOption.done:
      _logHomeworkDoneViaCardLongPress(analytics);
      final result =
          await confirmToMarkHomeworkAsDoneWithoutSubmission(context);
      if (result) setHomeworkStatus(true);
      break;
    case _HomeworkTileLongPressModelSheetOption.edit:
      _logHomeworkEditViaCardLongPress(analytics);
      openHomeworkDialogAndShowConfirmationIfSuccessful(
        context,
        homework: homeworkView.homework,
      );
      break;
    case _HomeworkTileLongPressModelSheetOption.delete:
      _logHomeworkDeleteViaCardLongPress(analytics);
      await deleteHomeworkDialogsEntry(context, homeworkView.homework,
          popTwice: false);
      break;
    case _HomeworkTileLongPressModelSheetOption.report:
      _logHomeworkReportViaCardLongPress(analytics);
      final reportItem = ReportItemReference.homework(homeworkView.homework.id);
      await openReportPage(context, reportItem);
      break;
  }
}

class _Checkbox extends StatelessWidget {
  const _Checkbox({Key key, this.isDone, this.typeOfUser}) : super(key: key);

  final bool isDone;
  final TypeOfUser typeOfUser;

  @override
  Widget build(BuildContext context) {
    if (typeOfUser != TypeOfUser.student) return Container();
    final bloc = BlocProvider.of<HomeworkCardBloc>(context);
    return StreamBuilder<bool>(
      stream: bloc.isDone,
      builder: (context, snapshot) {
        final isDone = this.isDone ?? snapshot.data;
        if (isDone == null) return Container(width: 15);
        return Checkbox(
          value: isDone,
          onChanged: (value) {
            bloc.toggleIsDone.add(value);
          },
        );
      },
    );
  }
}

class _CourseName extends StatelessWidget {
  const _CourseName({
    Key key,
    @required this.courseName,
    @required this.color,
    @required this.typeOfUser,
  }) : super(key: key);

  final String courseName;
  final Color color;
  final TypeOfUser typeOfUser;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: EdgeInsets.only(
            top: 16,
            right: 6,
            left: typeOfUser == TypeOfUser.student ? 0 : 11.5),
        child: Text(
          courseName ?? "",
          style: TextStyle(color: color),
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }
}

class _TodoUntil extends StatelessWidget {
  const _TodoUntil({
    Key key,
    @required this.date,
    @required this.color,
  }) : super(key: key);

  final String date;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.only(left: 12, bottom: 8),
        child: Align(
          alignment: Alignment.bottomLeft,
          child: Text(
            date,
            style: TextStyle(color: color, fontSize: 12),
          ),
        ),
      ),
    );
  }
}

class _Title extends StatelessWidget {
  const _Title(this.title, {Key key, this.isDone}) : super(key: key);

  final String title;
  final bool isDone;

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<HomeworkCardBloc>(context);
    return StreamBuilder<bool>(
      stream: bloc.isDone,
      builder: (context, snapshot) {
        final isDone = this.isDone ?? snapshot.data ?? false;
        return Padding(
          padding: const EdgeInsets.fromLTRB(12, 0, 12, 0),
          child: Text(
            title,
            style: TextStyle(
              color: isDarkThemeEnabled(context)
                  ? Colors.lightBlue[100]
                  : const Color(0xFF254D71),
              fontSize: 16,
              fontWeight: FontWeight.w500,
              decoration: isDone ? TextDecoration.lineThrough : null,
            ),
            overflow: TextOverflow.ellipsis,
            maxLines: 2,
          ),
        );
      },
    );
  }
}
