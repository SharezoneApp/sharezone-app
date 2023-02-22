// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:bloc_provider/bloc_provider.dart';
import 'package:date/weekday.dart';
import 'package:date/weektype.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:group_domain_models/group_domain_models.dart';
import 'package:sharezone/blocs/application_bloc.dart';
import 'package:sharezone/groups/group_permission.dart';
import 'package:sharezone/groups/src/pages/course/group_page.dart';
import 'package:sharezone/pages/settings/timetable_settings/timetable_settings_page.dart';
import 'package:sharezone/timetable/src/bloc/timetable_bloc.dart';
import 'package:sharezone/timetable/src/edit_time.dart';
import 'package:sharezone/timetable/src/edit_weekday.dart';
import 'package:sharezone/timetable/src/edit_weektype.dart';
import 'package:sharezone/timetable/src/models/lesson.dart';
import 'package:sharezone/timetable/src/models/time_type.dart';
import 'package:sharezone/timetable/timetable_add/bloc/timetable_add_bloc.dart';
import 'package:sharezone/timetable/timetable_add/bloc/timetable_add_bloc_factory.dart';
import 'package:sharezone/timetable/timetable_page/timetable_page.dart';
import 'package:sharezone/widgets/fade_switch_between_index_with_tab_controller.dart';
import 'package:sharezone/widgets/tabs.dart';
import 'package:sharezone_common/api_errors.dart';
import 'package:sharezone_widgets/snackbars.dart';
import 'package:sharezone_widgets/theme.dart';
import 'package:sharezone_widgets/widgets.dart';
import 'package:sharezone_widgets/wrapper.dart';
import 'package:time/time.dart';
import 'package:user/user.dart';

part 'tabs/course_tab.dart';
part 'tabs/room_tab.dart';
part 'tabs/time_tab.dart';
part 'tabs/weekday_tab.dart';
part 'tabs/weektype_tab.dart';

void navigateToNextTab(BuildContext context) {
  final controller = DefaultTabController.of(context);
  if (controller.index + 1 < controller.length) {
    controller.animateTo(controller.index + 1);
  }
}

void navigateToBackTab(BuildContext context) {
  final controller = DefaultTabController.of(context);
  if (controller.index - 1 >= 0) {
    controller.animateTo(controller.index - 1);
  }
}

class TimetableAddPage extends StatefulWidget {
  static const tag = 'timetable-add-page';

  @override
  _TimetableAddPageState createState() => _TimetableAddPageState();
}

class _TimetableAddPageState extends State<TimetableAddPage> {
  TimetableAddBloc bloc;

  @override
  Widget build(BuildContext context) {
    bloc ??= BlocProvider.of<TimetableAddBlocFactory>(context).create();
    final timetableBloc = BlocProvider.of<TimetableBloc>(context);
    return WillPopScope(
      onWillPop: () => warnUserAboutLeavingForm(context),
      child: BlocProvider(
        bloc: bloc,
        child: _TimetableAddPage(
          abWeekEnabled: timetableBloc.current.isABWeekEnabled(),
        ),
      ),
    );
  }
}

class _TimetableAddPage extends StatelessWidget {
  final List<Widget> tabs;
  final bool abWeekEnabled;

  factory _TimetableAddPage({@required bool abWeekEnabled}) {
    return _TimetableAddPage._(
      tabs: [
        _CourseTab(),
        _WeekDayTab(),
        if (abWeekEnabled) _WeekTypeTab(),
        _TimeTab(index: abWeekEnabled ? 4 : 3),
        _RoomTab(index: abWeekEnabled ? 5 : 4),
      ],
      abWeekEnabled: abWeekEnabled,
    );
  }

  const _TimetableAddPage._(
      {@required this.tabs, @required this.abWeekEnabled});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: tabs.length,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Schulstunde hinzufügen"),
          leading: TimetableAddAppBarLeading(),
        ),
        body: MaxWidthConstraintBox(
          child: SafeArea(
            child: Center(
              child: Column(
                children: <Widget>[
                  Expanded(child: TabBarView(children: tabs)),
                  _TimetableAddInfoMsg(abWeekEnabled: abWeekEnabled),
                  _BottomNaviagtionBar(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class TimetableAddAppBarLeading extends StatelessWidget {
  const TimetableAddAppBarLeading({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FadeSwitchBetweenIndexWithTabController(
      startWidget: CloseIconButton(),
      endWidget: Builder(
          builder: (context) => IconButton(
                icon: Icon(themeIconData(Icons.arrow_back,
                    cupertinoIcon: Icons.arrow_back_ios)),
                onPressed: () => navigateToBackTab(context),
              )),
      transitionPoint: BetweenIndex(0, 1),
    );
  }
}

class _TimetableAddInfoMsg extends StatelessWidget {
  const _TimetableAddInfoMsg({Key key, @required this.abWeekEnabled})
      : super(key: key);

  final bool abWeekEnabled;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(24, 16, 32, 0),
      child: Text.rich(
        TextSpan(
          children: <TextSpan>[
            const TextSpan(
                text:
                    "Schulstunden werden automatisch auch für die nächsten Wochen eingetragen."),
            if (!abWeekEnabled) ...[
              const TextSpan(text: " A/B Wochen kannst du in den "),
              TextSpan(
                text: "Einstellungen",
                style: linkStyle(context, 12),
                recognizer: TapGestureRecognizer()
                  ..onTap = () =>
                      Navigator.pushNamed(context, TimetableSettingsPage.tag),
              ),
              const TextSpan(text: " aktivieren."),
            ]
          ],
          style: const TextStyle(fontSize: 12, color: Colors.grey),
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}

class _BottomNaviagtionBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: const <Widget>[
          _NavigateBackButton(),
          _TabPageSelector(),
          _NavigateNextButton(),
        ],
      ),
    );
  }
}

class _TabPageSelector extends StatelessWidget {
  const _TabPageSelector({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SharezoneTabPageSelector(
      color: Colors.grey[400],
      indicatorSize: 10,
      selectedColor: Theme.of(context).primaryColor,
    );
  }
}

class _NavigateNextButton extends StatelessWidget {
  const _NavigateNextButton({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = DefaultTabController.of(context);
    final length = controller.length;
    return FadeSwitchBetweenIndexWithTabController(
      controller: controller,
      startWidget: nextButton(context),
      endWidget: _FinishButton(),
      transitionPoint: BetweenIndex(length - 2, length - 1),
    );
  }

  Widget nextButton(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.keyboard_arrow_right),
      color: Colors.grey,
      onPressed: () => navigateToNextTab(context),
    );
  }
}

class _FinishButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<TimetableAddBloc>(context);
    final controller = DefaultTabController.of(context);
    return IconButton(
      tooltip: 'Speichern',
      icon: const Icon(Icons.check),
      color: Colors.lightGreen,
      onPressed: () {
        try {
          final lesson = bloc.submit(controller);
          if (lesson == null) {
            showSnackSec(
              context: context,
              text:
                  "Es ist ein unbekannter Fehler aufgetreten. Bitte kontaktiere den Support!",
            );
          } else {
            Navigator.pop(context, TimetableLessonAdded(lesson));
          }
        } on Exception catch (e, s) {
          print(e);
          showSnackSec(
            text: handleErrorMessage(e.toString(), s),
            context: context,
          );
        }
      },
    );
  }
}

class _NavigateBackButton extends StatelessWidget {
  const _NavigateBackButton({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final controller = DefaultTabController.of(context);
    return FadeSwitchBetweenIndexWithTabController(
      controller: controller,
      startWidget: placeholder(),
      endWidget: backButton(context),
      transitionPoint: BetweenIndex(0, 1),
    );
  }

  Widget backButton(BuildContext context) {
    return IconButton(
      tooltip: 'Zurück',
      icon: const Icon(Icons.keyboard_arrow_left),
      color: Colors.grey,
      onPressed: () => navigateToBackTab(context),
    );
  }

  Widget placeholder() => Container(width: 48);
}

class _RectangleButton extends StatelessWidget {
  const _RectangleButton(
      {Key key, this.onTap, this.leading, this.title, this.backgroundColor})
      : super(key: key);

  final VoidCallback onTap;
  final Widget leading;
  final String title;
  final Color backgroundColor;

  @override
  Widget build(BuildContext context) {
    final borderRadius = BorderRadius.all(Radius.circular(14));
    return InkWell(
      borderRadius: borderRadius,
      child: Container(
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: borderRadius,
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(10, 12, 2, 12),
          child: Row(
            children: <Widget>[
              leading,
              const SizedBox(width: 10),
              Flexible(child: SingleChildScrollView(child: Text(title)))
            ],
          ),
        ),
      ),
      onTap: onTap,
    );
  }
}

class _EmptyCourseList extends StatelessWidget {
  const _EmptyCourseList({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Column(
        children: <Widget>[
          _LineWithTwoWidgets(
            first: _JoinCourse(),
            second: _CreateCourse(),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Text(
              "Du bist noch in keinem Kurs Mitglied 😔\nErstelle einen neuen Kurs oder tritt einem bei 😃",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey[700]),
            ),
          ),
        ],
      ),
    );
  }
}

class _TimetableAddSection extends StatelessWidget {
  const _TimetableAddSection({
    Key key,
    @required this.title,
    @required this.index,
    @required this.child,
  }) : super(key: key);

  final String title;
  final int index;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(top: 8),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Text('$index. Schritt', style: TextStyle(color: Colors.grey)),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Text(
                  title,
                  style: Theme.of(context)
                      .textTheme
                      .headlineSmall
                      .copyWith(fontSize: 20),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 20),
              child
            ],
          ),
        ),
      ),
    );
  }
}

class TimetableLessonAdded extends TimetableResult {
  final Lesson lesson;

  TimetableLessonAdded(this.lesson);

  bool get isValid => lesson.length.isValid;
}
