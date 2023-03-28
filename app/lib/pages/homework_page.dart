// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'dart:async';
import 'dart:developer';

import 'package:analytics/analytics.dart';
import 'package:bloc_provider/bloc_provider.dart';
import 'package:firebase_hausaufgabenheft_logik/firebase_hausaufgabenheft_logik.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:sharezone/blocs/application_bloc.dart';
import 'package:sharezone/blocs/dashbord_widgets_blocs/holiday_bloc.dart';
import 'package:sharezone/blocs/homework/homework_dialog_bloc.dart';
import 'package:sharezone/blocs/homework/homework_page_bloc.dart';
import 'package:sharezone/homework/homework_page_new.dart';
import 'package:sharezone/navigation/logic/navigation_bloc.dart';
import 'package:sharezone/navigation/models/navigation_item.dart';
import 'package:sharezone/navigation/scaffold/app_bar_configuration.dart';
import 'package:sharezone/navigation/scaffold/sharezone_main_scaffold.dart';
import 'package:sharezone/pages/homework/homework_archived.dart';
import 'package:sharezone/pages/homework/homework_dialog.dart';
import 'package:sharezone/util/next_lesson_calculator/next_lesson_calculator.dart';
import 'package:sharezone/widgets/homework/homework_card.dart';
import 'package:sharezone_common/translations.dart';
import 'package:sharezone_widgets/adaptive_dialog.dart';
import 'package:sharezone_widgets/placeholder.dart';
import 'package:sharezone_widgets/snackbars.dart';
import 'package:sharezone_widgets/theme.dart';
import 'package:sharezone_widgets/widgets.dart';
import 'package:user/user.dart';

enum SortBy { date, subject }

Map<SortBy, String> sortByAsString = {
  SortBy.date: "Datum",
  SortBy.subject: "Fach",
};

Future<void> openHomeworkDialogAndShowConfirmationIfSuccessful(
  BuildContext context, {
  HomeworkDto homework,
}) async {
  final api = BlocProvider.of<SharezoneContext>(context).api;
  final nextLessonCalculator = NextLessonCalculator(
    timetableGateway: api.timetable,
    userGateway: api.user,
    holidayManager: BlocProvider.of<HolidayBloc>(context).holidayManager,
  );

  final successful = await Navigator.push<bool>(
    context,
    IgnoreWillPopScopeWhenIosSwipeBackRoute(
      builder: (context) => HomeworkDialog(
        homeworkDialogApi: HomeworkDialogApi(api, nextLessonCalculator),
        homework: homework,
      ),
      settings: RouteSettings(name: HomeworkDialog.tag),
    ),
  );
  if (successful != null && successful) {
    await showUserConfirmationOfHomeworkArrival(context: context);
  }
}

/// Gibt alle Hausaufgaben zurück, bei welchen das Ablaufdatum nicht schon abgelaufen ist, sprich das
/// Datum entweder heute oder in der Zukunft ist.
List<HomeworkDto> getNotArchived(List<HomeworkDto> homeworkList) {
  final List<HomeworkDto> notArchivedHomeworks = <HomeworkDto>[];
  homeworkList.forEach((HomeworkDto homework) {
    final int dif = homework.todoUntil.difference(DateTime.now()).inDays;
    if (dif > -1) {
      notArchivedHomeworks.add(homework);
    }
  });
  return notArchivedHomeworks;
}

class HomeworkPage extends StatelessWidget {
  const HomeworkPage({Key key}) : super(key: key);
  static const String tag = 'homework-page';

  @override
  Widget build(BuildContext context) {
    final api = BlocProvider.of<SharezoneContext>(context).api;
    final typeOfUser = api.user.data?.typeOfUser ??
        TypeOfUser
            .student; // PROBLEM: BEIM HOTRELOAD IST MAN DADURCH IMMER EIN SCHÜLER
    return _HomeworkPage(typeOfUser: typeOfUser);
  }
}

class _HomeworkPage extends StatefulWidget {
  const _HomeworkPage({Key key, this.typeOfUser}) : super(key: key);

  final TypeOfUser typeOfUser;

  @override
  _HomeworkPageState createState() => _HomeworkPageState();
}

class _HomeworkPageState extends State<_HomeworkPage> {
  SortBy sortBy = SortBy.date;

  ScrollController _hideButtonController;
  bool _isVisible = true;
  bool _isAtEdge = false;

  @override
  void initState() {
    super.initState();
    _hideButtonController = ScrollController();
    _hideButtonController.addListener(() {
      if (_hideButtonController.position.pixels != 0 &&
          _hideButtonController.position.maxScrollExtent -
                  _hideButtonController.position.pixels <
              5) {
        _isAtEdge = true;
        setState(() {
          _isVisible = false;
        });
      } else {
        if (_isAtEdge) {
          _isAtEdge = false;
          setState(() {
            _isVisible = true;
          });
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<HomeworkPageBloc>(context);
    // Placeholder, may be turned to true for local development or might be
    // replaced with a feature flag system later.
    const newTeacherPageActivated = false;
    if (widget.typeOfUser == TypeOfUser.student ||
        (widget.typeOfUser == TypeOfUser.teacher && newTeacherPageActivated)) {
      /// We translate [TypeOfUser] (legacy) to [HomeworkPageTypeOfUser] because
      /// [TypeOfUser] has types of users where no homework page exists for
      /// (e.g [TypeOfUser.tutor]).
      /// NewHomeworkPage only takes the types of users it knows so that there
      /// is less cases to test and it is explicit that a normal [TypeOfUser]
      /// can't be passed.
      return NewHomeworkPage(
          currentUserType:
              typeOfUserToHomeworkPageTypeOfUserOrThrow(widget.typeOfUser));
    }
    return WillPopScope(
      onWillPop: () => popToOverview(context),
      child: DefaultTabController(
        length: 2,
        child: SharezoneMainScaffold(
          appBarConfiguration: AppBarConfiguration(
            actions: <Widget>[
              _PopupMenu(
                onChangedSortBy: (SortBy changedSortBy) =>
                    setState(() => sortBy = changedSortBy),
                typeOfUser: widget.typeOfUser,
              )
            ],
            bottom: widget.typeOfUser == TypeOfUser.student
                ? TabBar(
                    indicatorColor: Theme.of(context).primaryColor,
                    tabs: [
                      // @formatter:off
                      Tab(
                          icon: const Icon(Icons.cancel),
                          text: HomeworkPageMessages.offeneHausaufgaben()
                              .toUpperCase()),
                      Tab(
                          icon: const Icon(Icons.check_circle),
                          text: HomeworkPageMessages.gemachteHausaufgaben()
                              .toUpperCase()),
                      // @formatter:on
                    ],
                  )
                : null,
          ),
          navigationItem: NavigationItem.homework,
          // @formatter:off
          body: StreamBuilder<List<HomeworkDto>>(
              stream: bloc.homeworkNotDone,
              builder: (context, snapshotHomeworkNotDone) {
                if (!snapshotHomeworkNotDone.hasData) return Container();
                if (snapshotHomeworkNotDone.hasError)
                  return ShowCenteredError(
                    error: snapshotHomeworkNotDone.error.toString(),
                  );
                return Builder(
                  builder: (context) {
                    return StreamBuilder<List<HomeworkDto>>(
                      stream: bloc.homeworkDone,
                      builder: (context, snapshotHomeworkDone) {
                        log("HomeworkNotDone length: ${snapshotHomeworkNotDone?.data?.length ?? 0}");
                        if (!snapshotHomeworkDone.hasData) return Container();
                        if (snapshotHomeworkDone.hasError)
                          return ShowCenteredError(
                              error: snapshotHomeworkDone.error.toString());

                        List<HomeworkDto> homeworkListNotDone =
                            snapshotHomeworkNotDone.data;
                        List<HomeworkDto> homeworkListDone =
                            snapshotHomeworkDone.data;

                        if (widget.typeOfUser == TypeOfUser.teacher)
                          return _TeacherScaffoldBody(
                            homeworkList: getNotArchived(homeworkListNotDone),
                            hideButtonController: _hideButtonController,
                            sortBy: sortBy,
                          );
                        if (widget.typeOfUser == TypeOfUser.parent)
                          return _ParentsScaffoldBody(
                            homeworkList: getNotArchived(homeworkListNotDone),
                            hideButtonController: _hideButtonController,
                            sortBy: sortBy,
                          );
                        return _StudentScaffoldBody(
                          homeworkDoneList: homeworkListDone,
                          homeworkNotDoneList: homeworkListNotDone,
                          hideButtonController: _hideButtonController,
                          sortBy: sortBy,
                        );
                      },
                    );
                  },
                );
              }),
          floatingActionButton: AnimatedSwitcher(
            duration: const Duration(milliseconds: 175),
            transitionBuilder: (child, animation) =>
                ScaleTransition(child: child, scale: animation),
            child:
                _isVisible ? _HomeworkPageFAB(visible: _isVisible) : Text(""),
          ),
        ),
      ),
    );
  }
}

class _PopupMenu extends StatelessWidget {
  const _PopupMenu({Key key, this.onChangedSortBy, this.typeOfUser})
      : super(key: key);

  final ValueChanged<SortBy> onChangedSortBy;
  final TypeOfUser typeOfUser;

  void onPopupSortTap({BuildContext context, SortBy sortBy}) {
    onChangedSortBy(sortBy);
    showSnackSec(
      text: "Hausaufgaben werden nach dem ${sortByAsString[sortBy]} sortiert.",
      context: context,
    );
  }

  @override
  Widget build(BuildContext context) {
    final analytics = BlocProvider.of<SharezoneContext>(context).analytics;
    final bloc = BlocProvider.of<HomeworkPageBloc>(context);
    return PopupMenuButton(
      onSelected: (String value) async {
        switch (value) {
          case "AddHomework":
            _logHomeworkAddViaPopupMenu(analytics);
            openHomeworkDialogAndShowConfirmationIfSuccessful(context);
            break;
          case "ArchivedHomework":
            Navigator.pushNamed(context, HomeworkArchivedPage.tag);
            break;
          case "SortByDate":
            analytics.log(NamedAnalyticsEvent(name: "homework_sort_by_date"));
            onPopupSortTap(context: context, sortBy: SortBy.date);
            break;
          case "SortBySubject":
            analytics
                .log(NamedAnalyticsEvent(name: "homework_sort_by_subject"));
            onPopupSortTap(context: context, sortBy: SortBy.subject);
            break;
          case "MarkAllOpenHomeworks":
            bool isConfirmed =
                await confirmToCheckAllOverdueHomeworkDialog(context);
            if (isConfirmed != null && isConfirmed) {
              bloc.checkAllOverdueHomeworks();
              showSnackSec(
                  context: context,
                  text: "Alle überfälligen Hausaufgen wurden abgehakt!",
                  seconds: 2);
            }
            break;
          default:
            log("Fehler! $value wurde beim PopupMenuButton nicht gefunden!");
        }
      },
      itemBuilder: (BuildContext context) {
        List<PopupMenuItem<String>> items = <PopupMenuItem<String>>[
          const PopupMenuItem<String>(
            value: 'SortByDate',
            child: Text("Sortiere nach Datum"),
          ),
          const PopupMenuItem<String>(
            value: 'SortBySubject',
            child: Text("Sortiere nach Fach"),
          ),
          const PopupMenuItem<String>(
            value: 'ArchivedHomework',
            child: Text("Archivierte Hausaufgaben"),
          ),
        ];
        if (typeOfUser == TypeOfUser.student) {
          items.add(const PopupMenuItem<String>(
            value: 'MarkAllOpenHomeworks',
            child: Align(
                alignment: Alignment.topLeft,
                child: Text("Überfällige abhaken")),
          ));
        }
        if (typeOfUser == TypeOfUser.student ||
            typeOfUser == TypeOfUser.teacher) {
          items.add(const PopupMenuItem<String>(
            value: 'AddHomework',
            child: Text("Hausaufgabe hinzufügen"),
          ));
        }
        return items;
      },
    );
  }

  void _logHomeworkAddViaPopupMenu(Analytics analytics) {
    analytics.log(NamedAnalyticsEvent(name: "homework_add_via_popup_menu"));
  }

  Future<bool> confirmToCheckAllOverdueHomeworkDialog(BuildContext context) {
    return showLeftRightAdaptiveDialog<bool>(
      context: context,
      defaultValue: false,
      content: !ThemePlatform.isCupertino
          ? Text(
              "Möchtest du wirklich alle überfälligen Hausaufgaben als erledigt markieren?")
          : null,
      title: ThemePlatform.isCupertino
          ? "Möchtest du wirklich alle überfälligen Hausaufgaben als erledigt markieren?"
          : null,
      right: AdaptiveDialogAction(
        title: "Ja",
        popResult: true,
        isDefaultAction: true,
      ),
    );
  }
}

class _ParentsScaffoldBody extends StatelessWidget {
  const _ParentsScaffoldBody(
      {Key key, this.homeworkList, this.sortBy, this.hideButtonController})
      : super(key: key);

  final List<HomeworkDto> homeworkList;
  final SortBy sortBy;
  final ScrollController hideButtonController;

  @override
  Widget build(BuildContext context) {
    return _ParentsHomeworkPageView(
      homeworkList: homeworkList,
      hideButtonController: hideButtonController,
      sortBy: sortBy,
    );
  }
}

class _TeacherScaffoldBody extends StatelessWidget {
  const _TeacherScaffoldBody(
      {Key key, this.homeworkList, this.sortBy, this.hideButtonController})
      : super(key: key);

  final List<HomeworkDto> homeworkList;
  final SortBy sortBy;
  final ScrollController hideButtonController;

  @override
  Widget build(BuildContext context) {
    return _TeacherHomeworkPageView(
      homeworkList: homeworkList,
      hideButtonController: hideButtonController,
      sortBy: sortBy,
    );
  }
}

class _StudentScaffoldBody extends StatelessWidget {
  const _StudentScaffoldBody({
    @required this.homeworkDoneList,
    @required this.homeworkNotDoneList,
    Key key,
    this.hideButtonController,
    this.sortBy,
  }) : super(key: key);

  final List<HomeworkDto> homeworkDoneList;
  final List<HomeworkDto> homeworkNotDoneList;
  final ScrollController hideButtonController;
  final SortBy sortBy;

  @override
  Widget build(BuildContext context) {
    return TabBarView(children: [
      _HomeworkPageLogic(
        homeworkNotDoneList: homeworkNotDoneList,
        typeOfUser: TypeOfUser.student,
        hideButtonController: hideButtonController,
        sortBy: sortBy,
      ),
      _HomeworkPageLogic(
        homeworkDoneList: getNotArchived(homeworkDoneList),
        homeworkNotDoneList: homeworkNotDoneList,
        typeOfUser: TypeOfUser.student,
        hideButtonController: hideButtonController,
        sortBy: sortBy,
      )
    ]);
  }
}

class _ParentsHomeworkPageView extends StatelessWidget {
  const _ParentsHomeworkPageView(
      {Key key,
      @required this.homeworkList,
      this.sortBy,
      this.hideButtonController})
      : super(key: key);

  final List<HomeworkDto> homeworkList;
  final SortBy sortBy;
  final ScrollController hideButtonController;

  @override
  Widget build(BuildContext context) {
    if (homeworkList.isEmpty) return _SleepingSmileyParents();
    return _HomeworkListWithCards(
      homeworkList: homeworkList,
      typeOfUser: TypeOfUser.parent,
      hideButtonController: hideButtonController,
    );
  }
}

class _TeacherHomeworkPageView extends StatelessWidget {
  const _TeacherHomeworkPageView(
      {Key key,
      @required this.homeworkList,
      this.sortBy,
      this.hideButtonController})
      : super(key: key);

  final List<HomeworkDto> homeworkList;
  final SortBy sortBy;
  final ScrollController hideButtonController;

  @override
  Widget build(BuildContext context) {
    if (homeworkList.isEmpty) return _SleepingSmileyTeacher();
    return _HomeworkListWithCards(
      homeworkList: homeworkList,
      typeOfUser: TypeOfUser.teacher,
      hideButtonController: hideButtonController,
      sortBy: sortBy,
    );
  }
}

void logHomeworkAddViaHomeworkPage(BuildContext context) {
  final analytics = BlocProvider.of<SharezoneContext>(context).analytics;
  analytics.log(NamedAnalyticsEvent(name: "homework_add_via_fab"));
}

class _HomeworkPageFAB extends StatelessWidget {
  const _HomeworkPageFAB({Key key, this.visible}) : super(key: key);

  final bool visible;

  @override
  Widget build(BuildContext context) {
    if (!visible) return Container();
    return ModalFloatingActionButton(
      heroTag: 'sharezone-fab',
      onPressed: () async {
        logHomeworkAddViaHomeworkPage(context);
        await openHomeworkDialogAndShowConfirmationIfSuccessful(context);
      },
      tooltip: "Hausaufgabe hinzufügen",
      icon: const Icon(Icons.add),
    );
  }
}

Future<void> showUserConfirmationOfHomeworkArrival(
    {@required BuildContext context}) async {
  await waitingForPopAnimation();
  showDataArrivalConfirmedSnackbar(context: context);
}

class _HomeworkPageLogic extends StatelessWidget {
  final List<HomeworkDto> homeworkDoneList, homeworkNotDoneList;
  final TypeOfUser typeOfUser;
  final ScrollController hideButtonController;
  final SortBy sortBy;

  const _HomeworkPageLogic(
      {this.homeworkDoneList,
      this.homeworkNotDoneList,
      Key key,
      this.typeOfUser,
      this.hideButtonController,
      this.sortBy})
      : super(key: key);

  // @formatter:off
  @override
  Widget build(BuildContext context) {
    if (homeworkDoneList == null) {
      // Show open homeworks
      if (homeworkNotDoneList.isEmpty) return GameController();
      return _HomeworkListWithCards(
        homeworkList: homeworkNotDoneList,
        typeOfUser: typeOfUser,
        hideButtonController: hideButtonController,
        sortBy: sortBy,
      );
    } else {
      // Show done homeworks
      if (homeworkDoneList.isEmpty) {
        // Show Motivation-Widgets
        if (homeworkNotDoneList.isEmpty)
          return GameController(); // User has not done all homeworks
        return FireMotivation(); // User done all homeworks
      }
      return _HomeworkListWithCards(
        homeworkList: homeworkDoneList,
        typeOfUser: typeOfUser,
        hideButtonController: hideButtonController,
        sortBy: sortBy,
      ); // Show done homework list
    }
  }
  // @formatter:on
}

class _HomeworkListWithCards extends StatelessWidget {
  const _HomeworkListWithCards({
    Key key,
    this.homeworkList,
    this.typeOfUser,
    @required this.hideButtonController,
    this.sortBy,
  }) : super(key: key);

  final List<HomeworkDto> homeworkList;
  final TypeOfUser typeOfUser;
  final ScrollController hideButtonController;
  final SortBy sortBy;

  static const padding = EdgeInsets.fromLTRB(8, 10, 8, 8);

  @override
  Widget build(BuildContext context) {
    List<Widget> children = <Widget>[];
    if (sortBy == SortBy.date) {
      homeworkList.sort((HomeworkDto a, HomeworkDto b) {
        var r = a.todoUntil.compareTo(b.todoUntil);
        if (r != 0) return r;
        return a.subject.compareTo(b.subject);
      });

      final List<HomeworkDto> overdoueList = <HomeworkDto>[];
      final List<HomeworkDto> todayList = <HomeworkDto>[];
      final List<HomeworkDto> tomorrowList = <HomeworkDto>[];
      final List<HomeworkDto> dayAfterTomorrowList = <HomeworkDto>[];
      final List<HomeworkDto> severalDaysList = <HomeworkDto>[];

      DateTime today = DateTime(
          DateTime.now().year, DateTime.now().month, DateTime.now().day);
      homeworkList.forEach((HomeworkDto homework) {
        DateTime homeworkDate = DateTime(homework.todoUntil.year,
            homework.todoUntil.month, homework.todoUntil.day);

        if (today.isAfter(homeworkDate))
          overdoueList.add(homework);
        else if (today.isAtSameMomentAs(homeworkDate))
          todayList.add(homework);
        else if (homeworkDate == today.add(const Duration(days: 1)))
          tomorrowList.add(homework);
        else if (homeworkDate == today.add(const Duration(days: 2)))
          dayAfterTomorrowList.add(homework);
        else
          severalDaysList.add(homework);
      });

      children = [
        _HomeworkViewerInCategories(
          homeworkList: overdoueList,
          typeOfUser: typeOfUser,
          title: "Überfällig:",
        ),
        _HomeworkViewerInCategories(
          homeworkList: todayList,
          typeOfUser: typeOfUser,
          title: "Heute fällig:",
        ),
        _HomeworkViewerInCategories(
          homeworkList: tomorrowList,
          typeOfUser: typeOfUser,
          title: "Morgen fällig:",
        ),
        _HomeworkViewerInCategories(
          homeworkList: dayAfterTomorrowList,
          typeOfUser: typeOfUser,
          title: "Übermorgen fällig:",
        ),
        _HomeworkViewerInCategories(
          homeworkList: severalDaysList,
          typeOfUser: typeOfUser,
          title: "In mehreren Tagen fällig:",
        ),
      ];
    } else {
      homeworkList.sort((HomeworkDto a, HomeworkDto b) {
        var r = a.subject.compareTo(b.subject);
        if (r != 0) return r;
        return a.todoUntil.compareTo(b.todoUntil);
      });

      final homeworkSplittedIntoSubjects = <String, List<HomeworkDto>>{};

      homeworkList.forEach((HomeworkDto homework) {
        if (homeworkSplittedIntoSubjects[homework.courseID] == null) {
          homeworkSplittedIntoSubjects[homework.courseID] = <HomeworkDto>[];
        }

        homeworkSplittedIntoSubjects[homework.courseID].add(homework);
      });

      homeworkSplittedIntoSubjects.forEach((ref, list) {
        children.add(
          _HomeworkViewerInCategories(
            typeOfUser: typeOfUser,
            homeworkList: list,
            title: list.first.subject,
          ),
        );
      });
    }
    return SingleChildScrollView(
      controller: hideButtonController,
      padding: padding,
      child: SafeArea(child: Column(children: children)),
    );
  }
}

class _HomeworkViewerInCategories extends StatelessWidget {
  const _HomeworkViewerInCategories(
      {Key key, this.homeworkList, this.typeOfUser, this.title})
      : super(key: key);

  final List<HomeworkDto> homeworkList;
  final TypeOfUser typeOfUser;
  final String title;

  @override
  Widget build(BuildContext context) {
    return homeworkList.isNotEmpty
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                title,
                style: const TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 6),
              AnimationLimiter(
                child: Column(
                  children: AnimationConfiguration.toStaggeredList(
                    duration: const Duration(milliseconds: 350),
                    childAnimationBuilder: (widget) => SlideAnimation(
                      horizontalOffset: 25,
                      child: FadeInAnimation(child: widget),
                    ),
                    children: homeworkList
                        .map(
                          (homework) => Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: HomeworkCard(
                              homework: homework,
                              typeOfUser: typeOfUser,
                            ),
                          ),
                        )
                        .toList(),
                  ),
                ),
              ),
              const SizedBox(height: 4),
            ],
          )
        : Container();
  }
}

class _SleepingSmileyParents extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 48),
      child: PlaceholderWidgetWithAnimation(
        iconSize: const Size(175, 175),
        title:
            "Jetzt haben die Schüler Zeit für die wirklich wichtigen Dinge! 😉😍",
        description: const Text(
            "Die Schüler und Schülerinnen haben aktuell keine Hausaufgaben auf."),
        svgPath: 'assets/icons/sleeping.svg',
        animateSVG: true,
      ),
    );
  }
}

class _SleepingSmileyTeacher extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return PlaceholderWidgetWithAnimation(
      iconSize: const Size(175, 175),
      title: "Keine Hausaufgaben für die Schüler und Schülerinnen? 😮😍",
      description: Padding(
        padding: const EdgeInsets.only(top: 8),
        child: _EmptyHomeworkListAddHomeworkCard(),
      ),
      svgPath: 'assets/icons/sleeping.svg',
      animateSVG: true,
    );
  }
}

/// Show animated Game Controller
class GameController extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return PlaceholderWidgetWithAnimation(
      iconSize: const Size(175, 175),
      title: "Jetzt ist Zeit für die wirklich wichtigen Dinge im Leben! 🤘💪",
      description: Column(
        children: const <Widget>[
          Text("Sehr gut! Du hast keine Hausaufgaben zu erledigen"),
          SizedBox(height: 12),
          _EmptyHomeworkListAddHomeworkCard(),
        ],
      ),
      svgPath: 'assets/icons/game-controller.svg',
      animateSVG: true,
    );
  }
}

class _EmptyHomeworkListAddHomeworkCard extends StatelessWidget {
  const _EmptyHomeworkListAddHomeworkCard({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CardListTile(
      leading: Icon(Icons.add_circle_outline),
      centerTitle: true,
      title: Text("Hausaufgabe eintragen"),
      onTap: () => openHomeworkDialogAndShowConfirmationIfSuccessful(context),
    );
  }
}

/// Show animated fire --> user should be motivated to do his homeworks
class FireMotivation extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return PlaceholderWidgetWithAnimation(
      iconSize: const Size(175, 175),
      title: "AUF GEHTS! 💥👊",
      description: const Text(
          "Du musst noch die Hausaufgaben erledigen! Also schau mich nicht weiter an und erledige die Aufgaben! Do it!"),
      svgPath: 'assets/icons/fire.svg',
      animateSVG: true,
    );
  }
}
