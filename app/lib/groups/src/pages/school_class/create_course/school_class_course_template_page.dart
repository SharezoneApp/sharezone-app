// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:bloc_provider/bloc_provider.dart';
import 'package:flutter/material.dart';
import 'package:sharezone/main/application_bloc.dart';
import 'package:sharezone/groups/src/pages/course/create/course_create_page.dart';
import 'package:sharezone/groups/src/pages/course/create/course_template_page.dart';
import 'package:sharezone/groups/src/pages/course/create/src/models/course_template.dart';
import 'package:sharezone/groups/src/pages/school_class/create_course/school_class_create_course_bloc.dart';
import 'package:sharezone_widgets/sharezone_widgets.dart';

import 'school_class_create_course.dart';

class SchoolClassCourseTemplatePage extends StatelessWidget {
  const SchoolClassCourseTemplatePage({
    Key? key,
    required this.schoolClassID,
  }) : super(key: key);

  static const tag = "school-class-course-template-page";
  final String schoolClassID;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Vorlagen"),
        centerTitle: true,
        actions: const [CourseTemplatePageFinishButton()],
      ),
      body: SchoolClassCourseCreateTemplateBody(schoolClassID: schoolClassID),
      bottomNavigationBar: CreateCustomCourseSection(
        onTap: () => openSchoolClassCourseCreatePage(context, schoolClassID),
      ),
    );
  }
}

class SchoolClassCourseCreateTemplateBody extends StatelessWidget {
  const SchoolClassCourseCreateTemplateBody({
    Key? key,
    required this.schoolClassID,
    this.bottom,
  }) : super(key: key);

  final String schoolClassID;
  final Widget? bottom;

  @override
  Widget build(BuildContext context) {
    final gateway = BlocProvider.of<SharezoneContext>(context).api;
    return BlocProvider(
      bloc: SchoolClassCourseCreateBloc(
          schoolClassID: schoolClassID, gateway: gateway),
      child: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              _Hauptfaecher(),
              _Naturwissenschaften(),
              _Gesellschaftwissenschaften(),
              _Nebenfaecher(),
              if (bottom != null) bottom!,
            ],
          ),
        ),
      ),
    );
  }
}

class _Hauptfaecher extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const _CourseTemplateCategorySection(
      title: "Sprachen",
      courseTemplates: [
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
    return const _CourseTemplateCategorySection(
      title: "Naturwissenschaften",
      courseTemplates: [
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
    return const _CourseTemplateCategorySection(
      title: "Nebenfächer",
      courseTemplates: [
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
    return const _CourseTemplateCategorySection(
      title: "Nebenfächer",
      showLastDivider: false,
      courseTemplates: [
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

class _CourseTemplateCategorySection extends StatelessWidget {
  const _CourseTemplateCategorySection({
    Key? key,
    required this.title,
    required this.courseTemplates,
    this.showLastDivider = true,
  }) : super(key: key);

  final String title;
  final List<CourseTemplate> courseTemplates;
  final bool showLastDivider;

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<SchoolClassCourseCreateBloc>(context);
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
  const _CourseTemplateTile(
    this.courseTemplate, {
    Key? key,
    this.showDivider = true,
    this.isAlreadyAdded = false,
  }) : super(key: key);

  final CourseTemplate courseTemplate;
  final bool showDivider;
  final bool isAlreadyAdded;

  @override
  __CourseTemplateTileState createState() => __CourseTemplateTileState();
}

class __CourseTemplateTileState extends State<_CourseTemplateTile> {
  late _CourseTemplateTileStatus status;

  @override
  void initState() {
    status = widget.isAlreadyAdded == true
        ? _CourseTemplateTileStatus.added
        : _CourseTemplateTileStatus.add;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final courseTemplate = widget.courseTemplate;
    return Column(
      children: <Widget>[
        ListTile(
          onTap: () async {
            if (status == _CourseTemplateTileStatus.added) {
              final createAgain = await showLeftRightAdaptiveDialog(
                  context: context,
                  defaultValue: false,
                  content: Text(
                      "Möchtest du nochmal den Kurs ${widget.courseTemplate.subject} erstellen?"),
                  right: const AdaptiveDialogAction(
                    title: 'Ja',
                    isDefaultAction: true,
                    popResult: true,
                  ));
              if (createAgain == false) return;
            }
            if (!context.mounted) return;
            final bloc = BlocProvider.of<SchoolClassCourseCreateBloc>(context);
            final result = bloc.submitWithCourseTemplate(widget.courseTemplate);

            startLoading();
            result.then((v) => setCourseAsCreated());
          },
          leading: CircleAvatar(
            backgroundColor: Theme.of(context).primaryColor.withOpacity(0.22),
            foregroundColor: Colors.blue[600],
            child: Text(courseTemplate.abbreviation),
          ),
          title: Text(courseTemplate.subject),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 400),
                child: getIcon(context),
              ),
              IconButton(
                icon: const Icon(Icons.edit),
                onPressed: () async {
                  final bloc =
                      BlocProvider.of<SchoolClassCourseCreateBloc>(context);
                  final course = await openCourseCreatePage(context,
                      course: courseTemplate.toCourse(),
                      schoolClassId: bloc.schoolClassID);
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

  Widget _createCourseButton(BuildContext context) {
    return _CreateCourseButton(
      key: const ValueKey(_CourseTemplateTileStatus.add),
      onCreate: () {
        final bloc = BlocProvider.of<SchoolClassCourseCreateBloc>(context);
        final result = bloc.submitWithCourseTemplate(widget.courseTemplate);

        startLoading();
        result.then((v) => setCourseAsCreated());
      },
    );
  }

  Widget getIcon(BuildContext context) {
    switch (status) {
      case _CourseTemplateTileStatus.add:
        return _createCourseButton(context);
      case _CourseTemplateTileStatus.added:
        return const _CourseIsCreatedIcon(
            key: ValueKey(_CourseTemplateTileStatus.added));
      case _CourseTemplateTileStatus.loading:
        return const Padding(
          padding: EdgeInsets.only(left: 12, top: 12),
          child: LoadingCircle(
            key: ValueKey(_CourseTemplateTileStatus.loading),
            size: 20,
          ),
        );
    }
  }

  void startLoading() =>
      setState(() => status = _CourseTemplateTileStatus.loading);
  void setCourseAsCreated() =>
      setState(() => status = _CourseTemplateTileStatus.added);
  void setCourseAsNotCreated() => setState(() => _CourseTemplateTileStatus.add);
}

enum _CourseTemplateTileStatus { add, added, loading }

class _CourseIsCreatedIcon extends StatelessWidget {
  const _CourseIsCreatedIcon({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const IconButton(
        icon: Icon(Icons.check, color: Colors.greenAccent), onPressed: null);
  }
}

class _CreateCourseButton extends StatelessWidget {
  const _CreateCourseButton({Key? key, this.onCreate}) : super(key: key);

  final VoidCallback? onCreate;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.add_circle_outline),
      onPressed: onCreate,
      tooltip: 'Hinzufügen',
    );
  }
}
