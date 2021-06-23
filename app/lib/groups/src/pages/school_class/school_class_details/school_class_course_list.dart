import 'package:bloc_provider/bloc_provider.dart';
import 'package:flutter/material.dart';
import 'package:group_domain_models/group_domain_models.dart';
import 'package:sharezone/additional/course_permission.dart';
import 'package:sharezone/blocs/application_bloc.dart';
import 'package:sharezone/groups/src/pages/course/course_card.dart';
import 'package:sharezone/groups/src/pages/school_class/create_course/school_class_course_template_page.dart';
import 'package:sharezone/groups/src/pages/school_class/my_school_class_bloc.dart';
import 'package:sharezone_widgets/snackbars.dart';
import 'package:sharezone_widgets/state_sheet.dart';
import 'package:sharezone_widgets/widgets.dart';

class SchoolClassCoursesList extends StatelessWidget {
  const SchoolClassCoursesList({Key key, @required this.schoolClassID})
      : super(key: key);

  final String schoolClassID;

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<MySchoolClassBloc>(context);
    final isAdmin = bloc.isAdmin();
    return Column(
      children: <Widget>[
        CustomCard(
          child: StreamBuilder<List<Course>>(
            stream: bloc.streamCourses(schoolClassID),
            builder: (context, snapshot) {
              List<Course> courses = snapshot.data ?? [];
              return _List(
                courses: courses,
                schoolClassId: schoolClassID,
                isAdmin: isAdmin,
              );
            },
          ),
        ),
        const SizedBox(height: 16.0),
      ],
    );
  }
}

class _List extends StatelessWidget {
  final String schoolClassId;
  final List<Course> courses;
  final bool isAdmin;

  const _List({
    Key key,
    this.courses,
    this.schoolClassId,
    this.isAdmin,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(left: 16, top: 16),
          child: Text("Kurse", style: Theme.of(context).textTheme.headline6),
        ),
        const SizedBox(height: 4),
        for (final course in courses)
          SchoolClassVariantCourseTile(
            course: course,
            schoolClassId: schoolClassId,
          ),
        if (courses.isEmpty)
          ListTile(
            title: const Text(
                "Es wurden noch keine Kurse zu dieser Klasse hinzugefügt.\n\nErstelle jetzt einen Kurs, der mit der Klasse verknüpft ist."),
          ),
        if (isAdmin) _AddExistingCourse(schoolClassId),
        if (isAdmin) _AddNewCourse(schoolClassId),
      ],
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
    );
  }
}

class _SchoolCoursesActions extends StatelessWidget {
  const _SchoolCoursesActions({Key key, this.title, this.onTap, this.iconData})
      : super(key: key);

  final String title;
  final VoidCallback onTap;
  final IconData iconData;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.fromLTRB(18, 0, 16, 4),
      leading: CircleAvatar(
        child: Icon(iconData),
        foregroundColor: Theme.of(context).primaryColor,
        backgroundColor: Colors.grey[200],
      ),
      title: Text(title),
      onTap: onTap,
    );
  }
}

class _AddExistingCourse extends StatelessWidget {
  const _AddExistingCourse(this.schoolClassID, {Key key}) : super(key: key);

  final String schoolClassID;

  @override
  Widget build(BuildContext context) {
    final api = BlocProvider.of<SharezoneContext>(context).api;
    return StreamBuilder<List<Course>>(
      stream: api.course.streamCourses(),
      builder: (context, snapshot) {
        return _SchoolCoursesActions(
          iconData: Icons.group_add,
          title: "Existierenden Kurs hinzufügen",
          onTap: () async {
            if (snapshot.hasData) {
              final courseList = snapshot.data;
              final futureResult =
                  await _showCourseListDialog(context, courseList);
              if (futureResult != null) {
                showSimpleStateDialog(context, futureResult);
              }
            } else {
              showSnackSec(
                context: context,
                text: 'Bitte warten einen kurzen Augenblick.',
                seconds: 2,
              );
            }
          },
        );
      },
    );
  }

  Future<Future<bool>> _showCourseListDialog(
      BuildContext context, List<Course> courseList) async {
    return showDialog<Future<bool>>(
        context: context,
        builder: (context) {
          _sortCourseListByAlphabet(courseList);
          return SimpleDialog(
            title: const Text("Wähle einen Kurs aus"),
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 0, 24, 6),
                child: const Text(
                    "Du kannst nur Kurse hinzufügen, in denen du auch Administrator bist.",
                    style: TextStyle(color: Colors.grey, fontSize: 12)),
              ),
              Column(
                children: courseList
                    .map((course) => _CourseTile(
                        course: course, schoolClassID: schoolClassID))
                    .toList(),
              ),
            ],
          );
        });
  }

  void _sortCourseListByAlphabet(List<Course> courseList) {
    courseList.sort((a, b) => a.name.compareTo(b.name));
  }
}

class _CourseTile extends StatelessWidget {
  const _CourseTile({
    Key key,
    @required this.course,
    @required this.schoolClassID,
  }) : super(key: key);

  final Course course;
  final String schoolClassID;

  @override
  Widget build(BuildContext context) {
    final schoolClassGatewy =
        BlocProvider.of<SharezoneContext>(context).api.schoolClassGateway;
    final enabled = requestPermission(
      role: course.myRole,
      permissiontype: PermissionAccessType.admin,
    );
    return DialogTile(
      symbolText: course.abbreviation.toUpperCase(),
      enabled: enabled,
      text: course.name,
      trailing: !enabled
          ? const Icon(Icons.lock, color: Colors.grey, size: 20)
          : null,
      onPressed: () {
        final futureResult = schoolClassGatewy
            .addCourse(schoolClassID, course.id)
            .then((result) => result.hasData && result.data == true);
        Navigator.pop(context, futureResult);
      },
    );
  }
}

class _AddNewCourse extends StatelessWidget {
  const _AddNewCourse(
    this.schoolClassID, {
    Key key,
  }) : super(key: key);

  final String schoolClassID;

  @override
  Widget build(BuildContext context) {
    return _SchoolCoursesActions(
      iconData: Icons.add,
      title: "Neuen Kurs hinzufügen",
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              SchoolClassCourseTemplatePage(schoolClassID: schoolClassID),
          settings: RouteSettings(name: SchoolClassCourseTemplatePage.tag),
        ),
      ),
    );
  }
}
