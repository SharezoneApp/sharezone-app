// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:bloc_provider/bloc_provider.dart';
import 'package:date/date.dart';
import 'package:flutter/material.dart';
import 'package:group_domain_models/group_domain_models.dart';
import 'package:sharezone/additional/course_permission.dart';
import 'package:sharezone/blocs/application_bloc.dart';
import 'package:sharezone/calendrical_events/models/calendrical_event.dart';
import 'package:sharezone/calendrical_events/models/calendrical_event_types.dart';
import 'package:sharezone/groups/src/pages/course/group_page.dart';
import 'package:sharezone/markdown/markdown_support.dart';
import 'package:sharezone/timetable/src/edit_date.dart';
import 'package:sharezone/timetable/src/edit_time.dart';
import 'package:sharezone/timetable/timetable_add/timetable_add_page.dart';
import 'package:sharezone/timetable/timetable_add_event/bloc/timetable_add_event_bloc.dart';
import 'package:sharezone/timetable/timetable_add_event/bloc/timetable_add_event_bloc_factory.dart';
import 'package:sharezone/timetable/timetable_page/timetable_page.dart';
import 'package:sharezone/widgets/fade_switch_between_index_with_tab_controller.dart';
import 'package:sharezone/widgets/material/list_tile_with_description.dart';
import 'package:sharezone/widgets/tabs.dart';
import 'package:sharezone_common/api_errors.dart';
import 'package:sharezone_widgets/snackbars.dart';
import 'package:sharezone_widgets/theme.dart';
import 'package:sharezone_widgets/widgets.dart';
import 'package:sharezone_widgets/wrapper.dart';
import 'package:time/time.dart';

part 'tabs/course_tab.dart';
part 'tabs/date_tab.dart';
part 'tabs/optional_tab.dart';
part 'tabs/time_tab.dart';
part 'tabs/title_tab.dart';

void _submit(BuildContext context) {
  final bloc = BlocProvider.of<TimetableAddEventBloc>(context);
  final controller = DefaultTabController.of(context);
  try {
    final event = bloc.submit(controller);
    Navigator.pop(context, TimetableEventAdded(event));
  } on Exception catch (e, s) {
    print(e);
    showSnackSec(text: handleErrorMessage(e.toString(), s), context: context);
  }
}

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

class TimetableAddEventPage extends StatefulWidget {
  static const tag = 'timetable-add-event-page';
  final bool isExam;

  const TimetableAddEventPage({Key key, @required this.isExam})
      : super(key: key);

  @override
  _TimetableAddEventPageState createState() => _TimetableAddEventPageState();
}

class _TimetableAddEventPageState extends State<TimetableAddEventPage> {
  TimetableAddEventBloc bloc;

  @override
  void initState() {
    super.initState();
    bloc ??= BlocProvider.of<TimetableAddEventBlocFactory>(context).create();
    bloc.changeEventType(widget.isExam ? Exam() : Meeting());
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => warnUserAboutLeavingForm(context),
      child: BlocProvider(
        bloc: bloc,
        child: _TimetableAddEventPage(isExam: widget.isExam),
      ),
    );
  }
}

class _TimetableAddEventPage extends StatelessWidget {
  final List<Widget> tabs;
  final bool isExam;

  factory _TimetableAddEventPage({bool isExam}) {
    return _TimetableAddEventPage._(
      isExam: isExam,
      tabs: [
        _CourseTab(),
        _TitleTab(isExam: isExam),
        _DateTab(),
        const _TimeTab(),
        _OptionalTab(isExam: isExam),
      ],
    );
  }

  const _TimetableAddEventPage._({@required this.tabs, this.isExam});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: tabs.length,
      child: Scaffold(
        backgroundColor: isDarkThemeEnabled(context) ? null : Colors.white,
        appBar: AppBar(
          title: Text("${isExam ? "Prüfung" : "Termin"} hinzufügen"),
          leading: TimetableAddAppBarLeading(),
        ),
        body: MaxWidthConstraintBox(
          child: SafeArea(
            child: Center(
              child: Column(
                children: <Widget>[
                  Expanded(child: TabBarView(children: tabs)),
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
    return IconButton(
      tooltip: 'Speichern',
      icon: const Icon(Icons.check),
      color: Colors.lightGreen,
      onPressed: () => _submit(context),
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
              "Du bist noch in keinem Kurs Mitglied ����\nErstelle einen neuen Kurs oder tritt einem bei 😃",
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
              Text(title,
                  style: Theme.of(context)
                      .textTheme
                      .headline5
                      .copyWith(fontSize: 20)),
              const SizedBox(height: 20),
              child
            ],
          ),
        ),
      ),
    );
  }
}

class TimetableEventAdded extends TimetableResult {
  final CalendricalEvent event;

  TimetableEventAdded(this.event);

  bool get isValid => event.length.isValid;
}
