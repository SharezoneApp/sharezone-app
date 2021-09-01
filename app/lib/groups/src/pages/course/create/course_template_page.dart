import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:sharezone/blocs/application_bloc.dart';
import 'package:bloc_provider/bloc_provider.dart';
import 'package:group_domain_models/group_domain_models.dart';

import 'package:sharezone/groups/src/pages/course/create/course_create_page.dart';
import 'package:sharezone/groups/src/pages/course/create/src/bloc/course_create_bloc_factory.dart';
import 'package:sharezone/groups/src/pages/course/create/src/models/course_template.dart';
import 'package:sharezone_widgets/theme.dart';
import 'package:sharezone_widgets/snackbars.dart';
import 'package:sharezone_widgets/announcement_card.dart';

import 'src/bloc/course_create_bloc.dart';

class CourseTemplatePage extends StatelessWidget {
  static const tag = 'course-template-page';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Vorlagen"),
        centerTitle: true,
        actions: const [CourseTemplatePageFinishButton()],
      ),
      backgroundColor: isDarkThemeEnabled(context) ? null : Colors.white,
      body: SingleChildScrollView(
        child: SafeArea(child: CourseTemplatePageBody()),
      ),
      bottomNavigationBar: CreateCustomCourseSection(
        onTap: () => openCourseCreatePage(context),
      ),
    );
  }
}

class CourseTemplatePageBody extends StatefulWidget {
  const CourseTemplatePageBody({Key key, this.bottom}) : super(key: key);

  final Widget bottom;

  @override
  _CourseTemplatePageBodyState createState() => _CourseTemplatePageBodyState();
}

class _CourseTemplatePageBodyState extends State<CourseTemplatePageBody> {
  CourseCreateBloc bloc;

  @override
  void initState() {
    bloc ??= BlocProvider.of<CourseCreateBlocFactory>(context).create();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      bloc: bloc,
      child: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              // _Benutzerdefiniert(),
              if (!bloc.hasSchoolClassId)
                _CoursesAreNotLinkedWithSchoolClassWarning(),
              _Sprachen(),
              _Naturwissenschaften(),
              _Gesellschaftwissenschaften(),
              _Nebenfaecher(),
            ],
          ),
        ),
      ),
    );
  }
}

class _CoursesAreNotLinkedWithSchoolClassWarning extends StatelessWidget {
  const _CoursesAreNotLinkedWithSchoolClassWarning({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 0),
      child: AnnouncementCard(
        color: Colors.deepOrangeAccent.withOpacity(0.8),
        content: MarkdownBody(
          styleSheet: MarkdownStyleSheet.fromTheme(Theme.of(context)),
          selectable: true,
          data:
              "Die Kurse aus dieser Liste sind standardmäßig **nicht** mit einer Schulklasse verbunden.",
        ),
      ),
    );
  }
}

class CourseTemplatePageFinishButton extends StatelessWidget {
  const CourseTemplatePageFinishButton({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Text("FERTIG",
          style: TextStyle(
              fontWeight: FontWeight.w600,
              color: Theme.of(context).appBarTheme.iconTheme.color)),
      onPressed: () => Navigator.pop(context),
      iconSize: 60,
      tooltip: 'Seite schließen',
    );
  }
}

// class _Benutzerdefiniert extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: <Widget>[
//         Padding(
//           padding: const EdgeInsets.fromLTRB(16, 12, 4, 0),
//           child: Headline("Benutzerdifiniert"),
//         ),
//       ],
//     );
//   }
// }

class _Sprachen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return _CourseTemplateCategorySection(
      title: "Sprachen",
      courseTemplates: const [
        CourseTemplate("Deutsch", "D"),
        CourseTemplate("Englisch", "E"),
        CourseTemplate("Französisch", "F"),
        CourseTemplate("Spanisch", "S"),
        CourseTemplate("Latein", "L"),
      ],
    );
  }
}

class _Naturwissenschaften extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return _CourseTemplateCategorySection(
      title: "Naturwissenschaften",
      courseTemplates: const [
        CourseTemplate("Mathematik", "M"),
        CourseTemplate("Biologie", "BI"),
        CourseTemplate("Chemie", "CH"),
        CourseTemplate("Physik", "PH"),
        CourseTemplate("Informatik", "IF"),
        CourseTemplate("Naturwissenschaften", "NW"),
        CourseTemplate("Technik", "TK"),
      ],
    );
  }
}

class _Gesellschaftwissenschaften extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return _CourseTemplateCategorySection(
      title: "Nebenfächer",
      courseTemplates: const [
        CourseTemplate("Gesellschaftslehre", "GL"),
        CourseTemplate("Politik", "PO"),
        CourseTemplate("Geschichte", "GE"),
        CourseTemplate("Wirtschaft", "W"),
        CourseTemplate("Pädagogik", "PA"),
      ],
    );
  }
}

class _Nebenfaecher extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return _CourseTemplateCategorySection(
      title: "Nebenfächer",
      showLastDivider: false,
      courseTemplates: const [
        CourseTemplate("Sport", "SP"),
        CourseTemplate("Evangelische Religion", "ER"),
        CourseTemplate("Katholische Religion", "KR"),
        CourseTemplate("Philosophie", "PL"),
        CourseTemplate("Praktische Philosophie", "PP"),
        CourseTemplate("Kunst", "KU"),
        CourseTemplate("Musik", "MU"),
        CourseTemplate("Erdkunde", "EK"),
        CourseTemplate("Geografie", "GEO"),
        CourseTemplate("Hauswirtschaftslehre", "HW"),
        CourseTemplate("Arbeitslehre", "AL"),
      ],
    );
  }
}

class CreateCustomCourseSection extends StatelessWidget {
  const CreateCustomCourseSection({Key key, @required this.onTap})
      : super(key: key);

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: isDarkThemeEnabled(context)
          ? Theme.of(context).scaffoldBackgroundColor
          : Colors.grey[100],
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Divider(height: 0),
            Padding(
              padding: const EdgeInsets.fromLTRB(18, 16, 18, 16),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: Colors.lightBlueAccent,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const <Widget>[
                    Icon(Icons.add_circle, color: Colors.white),
                    SizedBox(width: 8.0),
                    Text("EIGENEN KURS ERSTELLEN",
                        style: TextStyle(color: Colors.white)),
                  ],
                ),
                onPressed: onTap,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CourseTemplateCategorySection extends StatelessWidget {
  const _CourseTemplateCategorySection(
      {Key key, this.title, this.courseTemplates, this.showLastDivider = true})
      : super(key: key);

  final String title;
  final List<CourseTemplate> courseTemplates;
  final bool showLastDivider;

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<CourseCreateBloc>(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 4, 0),
          child: Headline(title),
        ),
        for (int i = 0; i < courseTemplates.length; i++)
          _CourseTemplateTile(
            courseTemplates[i],
            showDivider: !(i == courseTemplates.length - 1 && !showLastDivider),
            isAlreadyAdded:
                bloc.isCourseTemplateAlreadyAdded(courseTemplates[i]),
          ),
      ],
    );
  }
}

class _CourseTemplateTile extends StatefulWidget {
  const _CourseTemplateTile(this.courseTemplate,
      {Key key, this.showDivider = true, this.isAlreadyAdded = false})
      : super(key: key);

  final CourseTemplate courseTemplate;
  final bool showDivider;
  final bool isAlreadyAdded;

  @override
  __CourseTemplateTileState createState() => __CourseTemplateTileState();
}

class __CourseTemplateTileState extends State<_CourseTemplateTile> {
  Widget add;

  @override
  Widget build(BuildContext context) {
    if (widget.isAlreadyAdded == true) {
      add = _CourseIsCreatedIcon();
    }
    final courseTemplate = widget.courseTemplate;
    return Column(
      children: <Widget>[
        ListTile(
          onTap: () {
            final bloc = BlocProvider.of<CourseCreateBloc>(context);
            final course = bloc.submitWithCourseTemplate(courseTemplate);
            setCourseAsCreated();

            _confirmCourseCreated(context, course,
                (courseId) => _deleteCourse(context, courseId));
          },
          leading: CircleAvatar(
            backgroundColor: Theme.of(context).primaryColor.withOpacity(0.20),
            foregroundColor: Colors.lightBlue,
            child: Text(courseTemplate.abbreviation),
          ),
          title: Text(courseTemplate.subject),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 400),
                transitionBuilder: (widget, animation) =>
                    FadeTransition(opacity: animation, child: widget),
                child: add ?? _createCourseButton(),
              ),
              IconButton(
                icon: const Icon(Icons.edit),
                onPressed: () async {
                  final course = await openCourseCreatePage(context,
                      course: courseTemplate.toCourse());
                  if (course != null) setCourseAsCreated();
                },
                tooltip: 'Hinzufügen',
              ),
            ],
          ),
        ),
        if (widget.showDivider) const Divider()
      ],
    );
  }

  Widget _createCourseButton() {
    return _CreateCourseButton(
      courseTemplate: widget.courseTemplate,
      onDelete: (courseId) => _deleteCourse(context, courseId),
      onCreate: setCourseAsCreated,
    );
  }

  Future<void> _deleteCourse(BuildContext context, String courseId) async {
    showSnackSec(
      context: context,
      text: "Kurs wird wieder gelöscht...",
      withLoadingCircle: true,
      seconds: 60,
    );

    final courseGateway = BlocProvider.of<SharezoneContext>(context).api.course;
    await courseGateway.deleteCourse(courseId);

    showSnackSec(
      context: context,
      text: "Kurs wurde gelöscht.",
      seconds: 2,
    );

    setCourseAsNotCreated();
  }

  void setCourseAsCreated() => setState(() => add = _CourseIsCreatedIcon());
  void setCourseAsNotCreated() => setState(() => add = _createCourseButton());
}

class _CourseIsCreatedIcon extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return IconButton(
        icon: Icon(Icons.check, color: Colors.greenAccent), onPressed: null);
  }
}

class _CreateCourseButton extends StatelessWidget {
  const _CreateCourseButton(
      {Key key, this.onCreate, this.courseTemplate, this.onDelete})
      : super(key: key);

  final VoidCallback onCreate;
  final ValueChanged<String> onDelete;
  final CourseTemplate courseTemplate;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.add_circle_outline),
      onPressed: () {
        final bloc = BlocProvider.of<CourseCreateBloc>(context);
        final course = bloc.submitWithCourseTemplate(courseTemplate);
        onCreate();

        _confirmCourseCreated(context, course, onDelete);
      },
      tooltip: 'Hinzufügen',
    );
  }
}

void _confirmCourseCreated(
    BuildContext context, Course course, ValueChanged<String> onDelete) {
  showSnackSec(
    text: 'Kurs "${course.name}" wurde erstellt.',
    context: context,
    seconds: 4,
    action: SnackBarAction(
      label: "RÜCKGÄNG MACHEN",
      onPressed: () => onDelete(course.id),
      textColor: Colors.lightBlueAccent,
    ),
  );
}
