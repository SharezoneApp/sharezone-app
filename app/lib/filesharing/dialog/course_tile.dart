import 'package:flutter/material.dart';
import 'package:sharezone/additional/course_permission.dart';
import 'package:sharezone/blocs/application_bloc.dart';
import 'package:bloc_provider/bloc_provider.dart';
import 'package:group_domain_models/group_domain_models.dart';

import 'package:sharezone/groups/group_join/group_join_page.dart';
import 'package:sharezone/groups/src/pages/course/create/course_template_page.dart';
import 'package:sharezone/util/API.dart';
import 'package:sharezone_widgets/widgets.dart';

class CourseTile extends StatelessWidget {
  const CourseTile({
    Key key,
    @required this.editMode,
    @required this.onChanged,
    @required this.courseStream,
  }) : super(key: key);

  final bool editMode;
  final ValueChanged<Course> onChanged;
  final Stream<Course> courseStream;

  Future<void> onTap(BuildContext context) async {
    final api = BlocProvider.of<SharezoneContext>(context).api;

    FocusScope.of(context).requestFocus(FocusNode());
    await Future.delayed(const Duration(milliseconds: 150));

    _showCourseListDialog(context, api);
  }

  void _showCourseListDialog(BuildContext context, SharezoneGateway api) =>
      showDialog(
        context: context,
        builder: (context) => StreamBuilder<List<Course>>(
          stream: api.course.streamCourses(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) return Container();
            final courseList = snapshot.data;
            _sortCourseListByAlphabet(courseList);
            return SimpleDialog(
              title: const Text('Wähle einen Kurs aus'),
              children: <Widget>[
                _CourseList(courseList: courseList, onChanged: onChanged),
                const Divider(),
                _JoinCreateCourseFooter(),
              ],
            );
          },
        ),
      );

  void _sortCourseListByAlphabet(List<Course> courseList) =>
      courseList.sort((a, b) => a.name.compareTo(b.name));

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Course>(
        stream: courseStream,
        builder: (context, snapshot) {
          return ListTile(
            leading: const Icon(Icons.book),
            title: const Text("Kurs"),
            subtitle: Text(
              snapshot.data?.name ?? "Keinen Kurs ausgewählt",
              style: snapshot.hasError ? TextStyle(color: Colors.red) : null,
            ),
            trailing: const Icon(Icons.keyboard_arrow_down),
            enabled: !editMode,
            onTap: () => onTap(context),
          );
        });
  }
}

class _CourseList extends StatelessWidget {
  const _CourseList({
    Key key,
    @required this.courseList,
    @required this.onChanged,
  }) : super(key: key);

  final List<Course> courseList;
  final ValueChanged<Course> onChanged;

  @override
  Widget build(BuildContext context) {
    if (courseList == null || courseList.isEmpty) return _EmptyCourseList();
    _sortCourseListByAlphabet(courseList);
    return Column(
      children: courseList.map((course) {
        final enabled = requestPermission(
          role: course.myRole,
          permissiontype: PermissionAccessType.creator,
        );
        return Theme(
          data: Theme.of(context)
              .copyWith(primaryColor: course.getDesign().color),
          child: DialogTile(
            symbolText: course.abbreviation,
            text: course.name,
            trailing: !enabled
                ? const Icon(Icons.lock, color: Colors.grey, size: 20)
                : null,
            enabled: enabled,
            onPressed: () {
              onChanged(course);
              Navigator.pop(context);
            },
          ),
        );
      }).toList(),
    );
  }

  void _sortCourseListByAlphabet(List<Course> courseList) {
    courseList.sort((a, b) => a.name.compareTo(b.name));
  }
}

class _EmptyCourseList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Text(
            "Du bist noch kein Mitglied eines Kurses 😔\nErstelle oder tritt einem Kurs bei 😃",
            style: TextStyle(color: Colors.grey[700]),
          ),
        ),
        const SizedBox(height: 8),
      ],
    );
  }
}

class _JoinCreateCourseFooter extends StatelessWidget {
  const _JoinCreateCourseFooter({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        DialogTile(
          text: "Kurs beitreten",
          symbolIconData: Icons.vpn_key,
          onPressed: () => openGroupJoinPage(context),
        ),
        DialogTile(
          symbolIconData: Icons.add,
          text: "Kurs erstellen",
          onPressed: () => Navigator.pushNamed(context, CourseTemplatePage.tag),
        )
      ],
    );
  }
}
