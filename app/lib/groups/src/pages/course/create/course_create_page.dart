import 'package:bloc_provider/bloc_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:group_domain_models/group_domain_models.dart';
import 'package:sharezone/groups/src/pages/course/create/src/bloc/course_create_bloc.dart';
import 'package:sharezone/groups/src/pages/course/create/src/bloc/course_create_bloc_factory.dart';
import 'package:sharezone_common/api_errors.dart';
import 'package:sharezone_widgets/snackbars.dart';
import 'package:sharezone_widgets/theme.dart';
import 'package:sharezone_widgets/widgets.dart';

Future<Course> openCourseCreatePage(BuildContext context,
    {Course course, String schoolClassId}) async {
  final createdCourse = await Navigator.push<dynamic>(
    context,
    IgnoreWillPopScopeWhenIosSwipeBackRoute(
      builder: (context) => _CourseCreatePage(
        course: course,
        schoolClassId: schoolClassId,
      ),
      settings: RouteSettings(name: _CourseCreatePage.tag),
    ),
  );
  await waitingForPopAnimation();
  if (createdCourse != null) {
    final name = createdCourse is Course ? ' "${createdCourse.name}"' : '';
    showSnackSec(
      context: context,
      text: 'Kurs$name wurde erstellt.',
      seconds: 2,
    );
  }
  return createdCourse as Course;
}

Future<void> submit(BuildContext context) async {
  final bloc = BlocProvider.of<CourseCreateBloc>(context);
  Course createdCourse;

  try {
    if (bloc.hasSchoolClassId) {
      sendDataToFrankfurtSnackBar(context, behavior: SnackBarBehavior.fixed);
      final successful = await bloc.submitSchoolClassCourse();
      Navigator.pop(context, successful);
    } else {
      createdCourse = bloc.submitCourse();
      Navigator.pop(context, createdCourse);
    }
  } catch (e, s) {
    showSnackSec(
      context: context,
      text: handleErrorMessage(e.toString(), s),
    );
  }
}

class _CourseCreatePage extends StatefulWidget {
  const _CourseCreatePage({Key key, this.course, this.schoolClassId})
      : super(key: key);

  static const tag = "course-create-page";
  final Course course;
  final String schoolClassId;

  @override
  _CourseCreatePageState createState() => _CourseCreatePageState();
}

class _CourseCreatePageState extends State<_CourseCreatePage> {
  CourseCreateBloc bloc;

  final abbreviationNode = FocusNode();
  final nameNode = FocusNode();

  @override
  void initState() {
    bloc ??= BlocProvider.of<CourseCreateBlocFactory>(context).create(
      schoolClassId: widget.schoolClassId,
    );
    bloc.setInitalCourse(widget.course);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      bloc: bloc,
      child: WillPopScope(
        onWillPop: () async => bloc.hasUserEditInput()
            ? warnUserAboutLeavingForm(context)
            : Future.value(true),
        child: Scaffold(
          appBar:
              AppBar(title: const Text("Kurs erstellen"), centerTitle: true),
          body: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Column(
              children: <Widget>[
                _Subject(
                    subject: widget.course?.subject,
                    nextFocusNode: abbreviationNode),
                _Abbreviation(
                    abbreviation: widget.course?.abbreviation,
                    focusNode: abbreviationNode,
                    nextFocusNode: nameNode),
                _CourseName(focusNode: nameNode),
              ],
            ),
          ),
          floatingActionButton: _CreateCourseFAB(),
        ),
      ),
    );
  }
}

class _CreateCourseFAB extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () => submit(context),
      child: const Icon(Icons.check),
      tooltip: 'Erstellen',
    );
  }
}

class _Subject extends StatelessWidget {
  const _Subject({Key key, this.subject, this.nextFocusNode}) : super(key: key);

  final String subject;
  final FocusNode nextFocusNode;

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<CourseCreateBloc>(context);
    return StreamBuilder<Object>(
      stream: bloc.subject,
      builder: (context, snapshot) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: PrefilledTextField(
            prefilledText: subject,
            decoration: InputDecoration(
              labelText: "Fach des Kurses (erforderlich)",
              hintText: "z.B. Mathematik",
              errorText: snapshot.error?.toString(),
            ),
            autofocus: true,
            textInputAction: TextInputAction.next,
            onChanged: bloc.changeSubject,
            onEditingComplete: () =>
                FocusScope.of(context).requestFocus(nextFocusNode),
          ),
        );
      },
    );
  }
}

class _Abbreviation extends StatelessWidget {
  const _Abbreviation(
      {Key key, this.abbreviation, this.focusNode, this.nextFocusNode})
      : super(key: key);

  final String abbreviation;
  final FocusNode focusNode;
  final FocusNode nextFocusNode;

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<CourseCreateBloc>(context);
    return PrefilledTextField(
      prefilledText: abbreviation,
      focusNode: focusNode,
      onEditingComplete: () =>
          FocusScope.of(context).requestFocus(nextFocusNode),
      textInputAction: TextInputAction.next,
      onChanged: bloc.changeAbbreviation,
      decoration: const InputDecoration(
        labelText: "Kürzel des Kurses",
        hintText: "z.B. M",
      ),
      maxLength: 3,
    );
  }
}

class _CourseName extends StatelessWidget {
  const _CourseName({Key key, this.courseName, this.focusNode})
      : super(key: key);

  final String courseName;
  final FocusNode focusNode;

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<CourseCreateBloc>(context);
    return TextFieldWithDescription(
      textField: PrefilledTextField(
        prefilledText: courseName,
        focusNode: focusNode,
        onChanged: bloc.changeName,
        onEditingComplete: () => submit(context),
        decoration: const InputDecoration(
          labelText: "Name des Kurses",
          hintText: "z.B. Mathematik GK Q2",
        ),
      ),
      description:
          "Der Kursname dient hauptsächlich für die Lehrkraft zur Unterscheidung der einzelnen Kurse. Denn würden bei der Lehrkraft alle Kurse Mathematik heißen, könnte diese nicht mehr Kurse unterscheiden.",
    );
  }
}
