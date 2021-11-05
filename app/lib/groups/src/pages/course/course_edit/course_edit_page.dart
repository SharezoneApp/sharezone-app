import 'package:analytics/analytics.dart';
import 'package:bloc_provider/bloc_provider.dart';
import 'package:flutter/material.dart';
import 'package:group_domain_models/group_domain_models.dart';
import 'package:sharezone/blocs/application_bloc.dart';
import 'package:sharezone/groups/src/pages/course/course_edit/course_edit_bloc.dart';
import 'package:sharezone_common/api_errors.dart';
import 'package:sharezone_widgets/snackbars.dart';
import 'package:sharezone_widgets/theme.dart';
import 'package:sharezone_widgets/widgets.dart';
import 'package:sharezone_widgets/wrapper.dart';

Future<void> openCourseEditPage(BuildContext context, Course course) async {
  final successful = await Navigator.push<bool>(
    context,
    MaterialPageRoute(
      builder: (context) => CourseEditPage(course: course),
      settings: RouteSettings(name: CourseEditPage.tag),
    ),
  );
  if (successful != null && successful == true) {
    _logCourseEdit(context);
    await _showCourseEditConformationSnackbarWithDelay(context);
  }
}

Future _showCourseEditConformationSnackbarWithDelay(
    BuildContext context) async {
  await waitingForPopAnimation();
  showSnackSec(
    context: context,
    text: "Der Kurs wurde erfolgreich bearbeitet!",
    seconds: 2,
  );
}

void _logCourseEdit(BuildContext context) {
  final analytics = BlocProvider.of<SharezoneContext>(context).analytics;
  analytics.log(NamedAnalyticsEvent(name: 'course_edit'));
}

Future<void> submit(BuildContext context) async {
  final bloc = BlocProvider.of<CourseEditPageBloc>(context);
  sendDataToFrankfurtSnackBar(context);
  try {
    Navigator.pop(context, await bloc.submit());
  } on Exception catch (e, s) {
    print(e);
    showSnackSec(text: handleErrorMessage(e.toString(), s), context: context);
  }
}

class CourseEditPage extends StatefulWidget {
  const CourseEditPage({Key key, this.course}) : super(key: key);

  static const String tag = "course-edit-page";
  final Course course;

  @override
  _CourseEditPageState createState() => _CourseEditPageState();
}

class _CourseEditPageState extends State<CourseEditPage> {
  CourseEditPageBloc bloc;

  @override
  void initState() {
    final api = BlocProvider.of<SharezoneContext>(context).api;
    bloc = CourseEditPageBloc(
        subject: widget.course.subject,
        abbreviation: widget.course.abbreviation,
        courseName: widget.course.name,
        design: widget.course.design,
        gateway: CourseEditBlocGateway(api.course, widget.course));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<CourseEditPageBloc>(
      bloc: bloc,
      child: _CourseEditPage(course: widget.course),
    );
  }
}

class _CourseEditPage extends StatelessWidget {
  const _CourseEditPage({Key key, @required this.course}) : super(key: key);

  final Course course;

  @override
  Widget build(BuildContext context) {
    final abbreviationNode = FocusNode();
    final courseNameNode = FocusNode();
    return Scaffold(
      appBar: AppBar(title: const Text("Kurs bearbeiten")),
      backgroundColor: isDarkThemeEnabled(context) ? null : Colors.white,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(8)
            .add(const EdgeInsets.symmetric(horizontal: 4)),
        child: MaxWidthConstraintBox(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              _SubjectField(
                  initialSubject: course.subject, nextNode: abbreviationNode),
              _AbbreviationField(
                  initialAbbreviation: course.abbreviation,
                  nextNode: courseNameNode),
              _CourseNameField(initialCourseName: course.name),
            ],
          ),
        ),
      ),
      floatingActionButton: _CourseEditPageFAB(),
    );
  }
}

class _SubjectField extends StatelessWidget {
  const _SubjectField({
    Key key,
    @required this.nextNode,
    @required this.initialSubject,
  }) : super(key: key);

  final FocusNode nextNode;
  final String initialSubject;

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<CourseEditPageBloc>(context);
    return StreamBuilder<Object>(
      stream: bloc.courseName,
      builder: (context, snapshot) {
        return PrefilledTextField(
          autofocus: true,
          onEditingComplete: () =>
              FocusScope.of(context).requestFocus(nextNode),
          textInputAction: TextInputAction.next,
          decoration: InputDecoration(
            labelText: "Fach",
            errorText: snapshot.error?.toString(),
          ),
          prefilledText: initialSubject,
          onChanged: bloc.changeSubject,
        );
      },
    );
  }
}

class _AbbreviationField extends StatelessWidget {
  const _AbbreviationField({
    Key key,
    @required this.nextNode,
    @required this.initialAbbreviation,
  }) : super(key: key);

  final FocusNode nextNode;
  final String initialAbbreviation;

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<CourseEditPageBloc>(context);
    return PrefilledTextField(
      prefilledText: initialAbbreviation,
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(labelText: "Kürzel des Fachs"),
      onEditingComplete: () => FocusScope.of(context).requestFocus(nextNode),
      onChanged: bloc.changeAbbreviation,
      maxLength: 3,
    );
  }
}

class _CourseNameField extends StatelessWidget {
  const _CourseNameField({Key key, @required this.initialCourseName})
      : super(key: key);

  final String initialCourseName;

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<CourseEditPageBloc>(context);
    return PrefilledTextField(
      prefilledText: initialCourseName,
      textInputAction: TextInputAction.done,
      decoration: InputDecoration(labelText: "Name des Kurses"),
      onEditingComplete: () => submit(context),
      onChanged: bloc.changeCourseName,
    );
  }
}

class _CourseEditPageFAB extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      tooltip: "Speichern",
      onPressed: () => submit(context),
      child: const Icon(Icons.check),
    );
  }
}
