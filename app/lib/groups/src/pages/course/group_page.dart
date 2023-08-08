// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:bloc_provider/bloc_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:group_domain_models/group_domain_models.dart';
import 'package:sharezone/blocs/application_bloc.dart';
import 'package:sharezone/groups/group_join/group_join_page.dart';
import 'package:sharezone/groups/src/pages/course/course_card.dart';
import 'package:sharezone/groups/src/pages/course/course_details.dart';
import 'package:sharezone/groups/src/pages/course/create/course_template_page.dart';
import 'package:sharezone/groups/src/pages/school_class/card/school_class_card.dart';
import 'package:sharezone/groups/src/pages/school_class/my_school_class_bloc.dart';
import 'package:sharezone/groups/src/pages/school_class/school_class_create.dart';
import 'package:sharezone/navigation/logic/navigation_bloc.dart';
import 'package:sharezone/navigation/models/navigation_item.dart';
import 'package:sharezone/navigation/scaffold/app_bar_configuration.dart';
import 'package:sharezone/navigation/scaffold/sharezone_main_scaffold.dart';
import 'package:sharezone_widgets/sharezone_widgets.dart';

enum CourseDialogOption {
  groupJoin,
  courseCreate,
  schoolClassCreate,
}

Future<dynamic> handleCourseDialogOption(
    BuildContext context, CourseDialogOption dialogOptions) async {
  if (dialogOptions != null) {
    final gateway = BlocProvider.of<SharezoneContext>(context).api;
    switch (dialogOptions) {
      case CourseDialogOption.schoolClassCreate:
        openMySchoolClassCreateDialog(
            context, MySchoolClassBloc(gateway: gateway));
        break;
        break;
      case CourseDialogOption.courseCreate:
        return Navigator.pushNamed(context, CourseTemplatePage.tag);
        break;
      case CourseDialogOption.groupJoin:
        return await openGroupJoinPage(context);
        break;
    }
  }
  return null;
}

class GroupPage extends StatefulWidget {
  const GroupPage({Key key}) : super(key: key);

  static const String tag = "course-page";

  @override
  GroupPageState createState() => GroupPageState();
}

class GroupPageState extends State<GroupPage> {
  ScrollController _hideButtonController;
  bool _isVisible = true;
  bool _isAtEdge = false;

  final globalKey = GlobalKey<ScaffoldState>();

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
    final gateway =
        BlocProvider.of<SharezoneContext>(context).api.connectionsGateway;
    return WillPopScope(
      onWillPop: () => popToOverview(context),
      child: SharezoneMainScaffold(
        scaffoldKey: globalKey,
        // backgroundColor: Color(0xFFF6F7FB),
        body: StreamBuilder<ConnectionsData>(
          initialData: gateway.current(),
          stream: gateway.streamConnectionsData(),
          builder: (context, snapshot) {
            final data = snapshot.hasData ? snapshot.data : null;
            final isEmpty = (data?.courses == null || data.courses.isEmpty) &&
                (data?.schoolClass == null || data.schoolClass.isEmpty);

            if (isEmpty) return _EmptyGroupList();
            return SingleChildScrollView(
              padding: const EdgeInsets.only(left: 12, top: 12, right: 4),
              controller: _hideButtonController,
              child: SafeArea(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    if (data.schoolClass != null)
                      _SchoolClassList(
                          schoolClasses: data.schoolClass.values.toList()),
                    _CourseList(data.courses.values.toList()),
                  ],
                ),
              ),
            );
          },
        ),
        floatingActionButton: AnimatedSwitcher(
          duration: const Duration(milliseconds: 175),
          transitionBuilder: (child, animation) =>
              ScaleTransition(child: child, scale: animation),
          child: _isVisible ? _CoursePageFAB(visible: _isVisible) : Text(""),
        ),
        navigationItem: NavigationItem.group,
        appBarConfiguration: AppBarConfiguration(
          title: "Gruppen",
          actions: const [HelpCoursePageIconButton()],
        ),
      ),
    );
  }
}

class _SchoolClassList extends StatelessWidget {
  const _SchoolClassList({Key key, this.schoolClasses}) : super(key: key);

  final List<SchoolClass> schoolClasses;

  @override
  Widget build(BuildContext context) {
    if (schoolClasses.isEmpty) return Container();
    schoolClasses.sort((a, b) => a?.name?.compareTo(b?.name));
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text("Meine Klasse${schoolClasses.length == 1 ? "" : "n"}:",
            style: TextStyle(color: Colors.grey)),
        AnimationLimiter(
          child: Column(
            children: AnimationConfiguration.toStaggeredList(
              duration: const Duration(milliseconds: 225),
              childAnimationBuilder: (widget) => SlideAnimation(
                horizontalOffset: 25,
                child: FadeInAnimation(
                  child: widget,
                ),
              ),
              children: <Widget>[
                for (int i = 0; i < schoolClasses.length; i++)
                  Padding(
                    padding: EdgeInsets.only(top: i == 0 ? 4 : 8, right: 12),
                    child: SchoolClassCard(schoolClasses[i]),
                  ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),
      ],
    );
  }
}

class _CourseList extends StatelessWidget {
  const _CourseList(this.courseList);

  final List<Course> courseList;

  @override
  Widget build(BuildContext context) {
    if (courseList == null || courseList.isEmpty) return Container();
    courseList.sort((a, b) => a.name.compareTo(b.name));
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const Text("Meine Kurse:", style: TextStyle(color: Colors.grey)),
        const SizedBox(height: 4),
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 0, 2, 8),
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
            child: AnimationLimiter(
              child: Wrap(
                children: AnimationConfiguration.toStaggeredList(
                  duration: const Duration(milliseconds: 225),
                  childAnimationBuilder: (widget) => SlideAnimation(
                    horizontalOffset: 20,
                    child: FadeInAnimation(
                      child: widget,
                    ),
                  ),
                  children: courseList
                      .map((course) => Padding(
                            padding:
                                const EdgeInsets.only(right: 8, bottom: 10),
                            child: CourseCardRedesign(course),
                          ))
                      .toList(),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _CoursePageFAB extends StatelessWidget {
  const _CoursePageFAB({Key key, this.visible}) : super(key: key);

  final bool visible;

  Future<void> _openCreateOrJoinCourseSheet(BuildContext context) async {
    final courseDialogOption = await showModalBottomSheet<CourseDialogOption>(
      context: context,
      builder: (BuildContext contextSheet) => _ModelBottomSheetContent(context),
    );
    handleCourseDialogOption(context, courseDialogOption);
  }

  @override
  Widget build(BuildContext context) {
    return ModalFloatingActionButton(
      heroTag: 'sharezone-fab',
      onPressed: () => _openCreateOrJoinCourseSheet(context),
      tooltip: "Gruppe beitreten/erstellen",
      icon: const Icon(Icons.add),
    );
  }
}

class _ModelBottomSheetContent extends StatelessWidget {
  const _ModelBottomSheetContent(this.scaffoldContext);

  final BuildContext scaffoldContext;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: true,
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _JoinGroup(),
            const Divider(height: 0),
            _CreateSchoolClass(),
            _CreateCourse(),
          ],
        ),
      ),
    );
  }
}

class _JoinGroup extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return _JoinGroupTile(
      title: "Kurs/Klasse beitreten",
      description:
          "Falls einer deiner Mitschüler schon eine Klasse oder einen Kurs erstellt hat, kannst du diesem einfach beitreten.",
      onTap: () => Navigator.pop(context, CourseDialogOption.groupJoin),
      iconData: Icons.vpn_key,
    );
  }
}

class _CreateSchoolClass extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return _JoinGroupTile(
      title: "Schulklasse erstellen",
      description:
          "Eine Klasse besteht aus mehreren Kursen. Jedes Mitglied tritt beim Betreten der Klasse automatisch allen dazugehörigen Kursen bei.",
      onTap: () => Navigator.pop(context, CourseDialogOption.schoolClassCreate),
      iconData: Icons.group_add,
    );
  }
}

class _CreateCourse extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return _JoinGroupTile(
      title: "Kurs erstellen",
      description:
          "Einen Kurs kannst du dir wie ein Schulfach vorstellen. Jedes Fach wird mit einem Kurs abgebildet.",
      onTap: () => Navigator.pop(context, CourseDialogOption.courseCreate),
      iconData: Icons.add_circle_outline,
    );
  }
}

class _JoinGroupTile extends StatelessWidget {
  const _JoinGroupTile(
      {Key key, this.description, this.title, this.iconData, this.onTap})
      : super(key: key);

  final String description, title;
  final IconData iconData;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const SizedBox(height: 12),
          Row(
            children: <Widget>[
              const SizedBox(width: 16),
              Icon(iconData,
                  color: isDarkThemeEnabled(context)
                      ? Colors.white54
                      : Colors.grey[600]),
              const SizedBox(width: 22),
              Text(title, style: TextStyle(fontSize: 16)),
              const SizedBox(width: 16),
            ],
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(62, 0, 12, 12),
            child: Text(
              description,
              style:
                  TextStyle(color: Colors.grey.withOpacity(0.85), fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptyGroupList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final gateway = BlocProvider.of<SharezoneContext>(context).api;
    return PlaceholderWidgetWithAnimation(
      iconSize: const Size(175, 175),
      title: "Du bist noch keinem Kurs, bzw. keiner Klasse beigetreten!",
      svgPath: 'assets/icons/ghost.svg',
      animateSVG: true,
      description: Padding(
        padding: const EdgeInsets.only(top: 8),
        child: Column(
          children: <Widget>[
            _EmptyGroupListAction(
              icon: Icon(Icons.vpn_key),
              title: "Kurs/Klasse beitreten",
              subtitle:
                  "Falls einer deiner Mitschüler schon eine Klasse oder einen Kurs erstellt hat, kannst du diesem einfach beitreten.",
              onTap: () => openGroupJoinPage(context),
            ),
            _EmptyGroupListAction(
              icon: Icon(Icons.group_add),
              title: "Schulklasse erstellen",
              subtitle:
                  "Eine Klasse besteht aus mehreren Kursen. Jedes Mitglied tritt beim Betreten der Klasse automatisch allen dazugehörigen Kursen bei.",
              onTap: () => openMySchoolClassCreateDialog(
                  context, MySchoolClassBloc(gateway: gateway)),
            ),
            _EmptyGroupListAction(
              icon: Icon(Icons.add_circle_outline),
              title: "Kurs erstellen",
              subtitle:
                  "Einen Kurs kannst du dir wie ein Schulfach vorstellen. Jedes Fach wird mit einem Kurs abgebildet.",
              onTap: () => Navigator.pushNamed(context, CourseTemplatePage.tag),
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyGroupListAction extends StatelessWidget {
  const _EmptyGroupListAction(
      {Key key, this.icon, this.title, this.subtitle, this.onTap})
      : super(key: key);

  final Widget icon;
  final String title, subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: CardListTile(
        leading: icon,
        title: Text(title),
        subtitle: Text(subtitle),
        onTap: onTap,
      ),
    );
  }
}
