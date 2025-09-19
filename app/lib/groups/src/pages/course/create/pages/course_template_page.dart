// Copyright (c) 2024 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:bloc_provider/bloc_provider.dart';
import 'package:common_domain_models/common_domain_models.dart';
import 'package:flutter/material.dart';
import 'package:group_domain_models/group_domain_models.dart';
import 'package:sharezone/groups/src/pages/course/create/bloc/course_create_bloc.dart';
import 'package:sharezone/groups/src/pages/course/create/bloc/course_create_bloc_factory.dart';
import 'package:sharezone/groups/src/pages/course/create/models/course_template.dart';
import 'package:sharezone/groups/src/pages/course/create/pages/course_create_page.dart';
import 'package:sharezone/groups/src/pages/school_class/card/school_class_card.dart';
import 'package:sharezone_common/api_errors.dart';
import 'package:sharezone_widgets/sharezone_widgets.dart';

class CourseTemplatePage extends StatefulWidget {
  const CourseTemplatePage({super.key, this.schoolClassId});

  static const tag = 'course-template-page';

  final SchoolClassId? schoolClassId;

  @override
  State<CourseTemplatePage> createState() => _CourseTemplatePageState();
}

class _CourseTemplatePageState extends State<CourseTemplatePage> {
  late CourseCreateBloc bloc;

  @override
  void initState() {
    super.initState();
    bloc = BlocProvider.of<CourseCreateBlocFactory>(
      context,
    ).create(schoolClassId: widget.schoolClassId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Vorlagen"),
        actions: const [CourseTemplatePageFinishButton()],
      ),
      body: SingleChildScrollView(
        child: CourseTemplatePageBody(
          schoolClassId: widget.schoolClassId,
          bloc: bloc,
        ),
      ),
      bottomNavigationBar: BlocProvider(
        bloc: bloc,
        child: _CreateCustomCourseSection(),
      ),
    );
  }
}

class CourseTemplatePageBody extends StatefulWidget {
  const CourseTemplatePageBody({
    super.key,
    this.withCreateCustomCourseSection = false,
    this.schoolClassId,
    this.bloc,
  });

  final SchoolClassId? schoolClassId;
  final CourseCreateBloc? bloc;
  final bool withCreateCustomCourseSection;

  @override
  State<CourseTemplatePageBody> createState() => _CourseTemplatePageBodyState();
}

class _CourseTemplatePageBodyState extends State<CourseTemplatePageBody> {
  late CourseCreateBloc bloc;

  @override
  void initState() {
    super.initState();
    bloc =
        widget.bloc ??
        BlocProvider.of<CourseCreateBlocFactory>(
          context,
        ).create(schoolClassId: widget.schoolClassId);
  }

  @override
  Widget build(BuildContext context) {
    final hasSchoolClassId = widget.schoolClassId != null;
    return BlocProvider(
      bloc: bloc,
      child: CourseTemplateList(
        header: hasSchoolClassId ? null : const _SelectSchoolClass(),
        hasAlreadyCreated:
            (template) => bloc.isCourseTemplateAlreadyAdded(template),
        onDeletePressed: (courseId) => bloc.deleteCourse(courseId),
        onEditCourseTemplatePressed:
            (template) => openCourseCreatePage(
              context,
              template: template,
              schoolClassId: widget.schoolClassId,
            ),
        onCreateCoursePressed:
            (template) => bloc.submitWithCourseTemplate(template),
        bottom:
            widget.withCreateCustomCourseSection
                ? _CreateCustomCourseSection()
                : null,
      ),
    );
  }
}

class CourseTemplateList extends StatefulWidget {
  const CourseTemplateList({
    super.key,
    this.header,
    this.bottom,
    required this.hasAlreadyCreated,
    required this.onDeletePressed,
    required this.onCreateCoursePressed,
    required this.onEditCourseTemplatePressed,
  });

  final Widget? header;
  final Widget? bottom;
  final bool Function(CourseTemplate) hasAlreadyCreated;
  final Future<void> Function(CourseId) onDeletePressed;
  final Future<(CourseId, CourseName)?> Function(CourseTemplate)
  onCreateCoursePressed;
  final Future<(CourseId, CourseName)?> Function(CourseTemplate)
  onEditCourseTemplatePressed;

  @override
  State<CourseTemplateList> createState() => _CourseTemplateListState();
}

class _CourseTemplateListState extends State<CourseTemplateList> {
  late List<CourseTemplate> sortedCourseTemplates;

  @override
  void initState() {
    super.initState();

    const unsortedCourseTemplates = [
      CourseTemplate("Deutsch", "D"),
      CourseTemplate("Englisch", "E"),
      CourseTemplate("Französisch", "F"),
      CourseTemplate("Spanisch", "S"),
      CourseTemplate("Latein", "L"),
      CourseTemplate("Mathematik", "M"),
      CourseTemplate("Biologie", "BI"),
      CourseTemplate("Chemie", "CH"),
      CourseTemplate("Physik", "PH"),
      CourseTemplate("Ethik", "ETH"),
      CourseTemplate("Informatik", "IF"),
      CourseTemplate("Naturwissenschaften", "NW"),
      CourseTemplate("Technik", "TK"),
      CourseTemplate("Gesellschaftslehre", "GL"),
      CourseTemplate("Politik", "PO"),
      CourseTemplate("Geschichte", "GE"),
      CourseTemplate("Wirtschaft", "W"),
      CourseTemplate("Pädagogik", "PA"),
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
    ];
    sortedCourseTemplates = List<CourseTemplate>.from(unsortedCourseTemplates)
      ..sortBySubject();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: MaxWidthConstraintBox(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            if (widget.header != null) widget.header!,
            for (var i = 0; i < sortedCourseTemplates.length; i++)
              _CourseTemplateTile(
                sortedCourseTemplates[i],
                showDivider: i != sortedCourseTemplates.length - 1,
                hasAlreadyCreated: widget.hasAlreadyCreated,
                onCreateCoursePressed: widget.onCreateCoursePressed,
                onDeletePressed: widget.onDeletePressed,
                onEditCourseTemplatePressed: widget.onEditCourseTemplatePressed,
              ),
            if (widget.bottom != null) widget.bottom!,
          ],
        ),
      ),
    );
  }
}

class CourseTemplatePageFinishButton extends StatelessWidget {
  const CourseTemplatePageFinishButton({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Text(
        "FERTIG",
        style: TextStyle(
          fontWeight: FontWeight.w600,
          color: Theme.of(context).appBarTheme.iconTheme?.color,
        ),
      ),
      onPressed: () => Navigator.pop(context),
      iconSize: 60,
      tooltip: 'Seite schließen',
    );
  }
}

class _CreateCustomCourseSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          const Divider(height: 0),
          Padding(
            padding: const EdgeInsets.fromLTRB(18, 16, 18, 16),
            child: MaxWidthConstraintBox(
              child: Column(
                children: [
                  const Opacity(
                    opacity: 0.8,
                    child: Text(
                      'Dein Kurs ist nicht dabei?',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.lightBlueAccent,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    onPressed: () async {
                      final bloc = BlocProvider.of<CourseCreateBloc>(context);
                      final course = await openCourseCreatePage(
                        context,
                        schoolClassId: bloc.schoolClassId,
                      );
                      if (course != null && context.mounted) {
                        showSnackSec(
                          context: context,
                          text: 'Kurs "${course.$2}" wurde erstellt.',
                        );
                      }
                    },
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(Icons.add_circle, color: Colors.white),
                        SizedBox(width: 8.0),
                        Text(
                          "EIGENEN KURS ERSTELLEN",
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CourseTemplateTile extends StatefulWidget {
  const _CourseTemplateTile(
    this.courseTemplate, {
    required this.hasAlreadyCreated,
    required this.showDivider,
    required this.onCreateCoursePressed,
    required this.onEditCourseTemplatePressed,
    required this.onDeletePressed,
  });

  final CourseTemplate courseTemplate;
  final bool showDivider;
  final bool Function(CourseTemplate) hasAlreadyCreated;
  final Future<void> Function(CourseId) onDeletePressed;
  final Future<(CourseId, CourseName)?> Function(CourseTemplate)
  onCreateCoursePressed;
  final Future<(CourseId, CourseName)?> Function(CourseTemplate)
  onEditCourseTemplatePressed;

  @override
  State createState() => _CourseTemplateTileState();
}

enum _CourseTemplateTileStatus { add, added, loading }

class _CourseTemplateTileState extends State<_CourseTemplateTile> {
  late _CourseTemplateTileStatus status;

  @override
  void initState() {
    super.initState();
    if (widget.hasAlreadyCreated(widget.courseTemplate)) {
      setCourseAsCreated();
    } else {
      setCourseAsNotCreated();
    }
  }

  void setCourseAsCreated() {
    setState(() => status = _CourseTemplateTileStatus.added);
  }

  void setCourseAsNotCreated() {
    setState(() => status = _CourseTemplateTileStatus.add);
  }

  void setLoading() {
    setState(() => status = _CourseTemplateTileStatus.loading);
  }

  void showDeletingCourseSnackBar() {
    showSnackSec(
      context: context,
      text: "Kurs wird wieder gelöscht...",
      withLoadingCircle: true,
      seconds: 60,
    );
  }

  void showDeletedCourseSnackBar() {
    showSnackSec(context: context, text: "Kurs wurde gelöscht.", seconds: 2);
  }

  Future<void> deleteCourse(CourseId courseId) async {
    try {
      setLoading();
      showDeletingCourseSnackBar();
      await widget.onDeletePressed(courseId);
      setCourseAsNotCreated();
      showDeletedCourseSnackBar();
    } catch (e, s) {
      if (!mounted) return;
      showSnackSec(context: context, text: handleErrorMessage(e.toString(), s));
      setCourseAsCreated();
    }
  }

  void _showCourseCreatedSnackBar((CourseId, CourseName) course) {
    showSnackSec(
      text: 'Kurs "${course.$2}" wurde erstellt.',
      context: context,
      seconds: 4,
      action: SnackBarAction(
        label: "RÜCKGÄNGIG MACHEN",
        onPressed: () => deleteCourse(course.$1),
        textColor: Colors.lightBlueAccent,
      ),
    );
  }

  Future<bool?> showCreateAnotherCourseDialog() {
    return showDialog<bool>(
      context: context,
      builder:
          (context) => _YouAlreadyHaveThisCourseDialog(
            subject: widget.courseTemplate.subject,
          ),
    );
  }

  Future<void> createCourse() async {
    if (status == _CourseTemplateTileStatus.added) {
      final result = await showCreateAnotherCourseDialog();
      if (result != true || !mounted) return;
    }

    setState(() => status = _CourseTemplateTileStatus.loading);
    try {
      final course = await widget.onCreateCoursePressed(widget.courseTemplate);
      if (!mounted) return;
      if (course == null) {
        setCourseAsNotCreated();
        return;
      }
      setCourseAsCreated();
      _showCourseCreatedSnackBar(course);
    } catch (e, s) {
      if (!mounted) return;
      showSnackSec(context: context, text: handleErrorMessage(e.toString(), s));
      setCourseAsNotCreated();
    }
  }

  @override
  Widget build(BuildContext context) {
    final courseTemplate = widget.courseTemplate;
    return Column(
      children: <Widget>[
        ListTile(
          onTap: () => createCourse(),
          leading: CircleAvatar(
            backgroundColor: Theme.of(
              context,
            ).primaryColor.withValues(alpha: 0.20),
            foregroundColor: Colors.lightBlue,
            child: Text(courseTemplate.abbreviation),
          ),
          title: Text(courseTemplate.subject),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 400),
                transitionBuilder:
                    (widget, animation) =>
                        FadeTransition(opacity: animation, child: widget),
                child: switch (status) {
                  _CourseTemplateTileStatus.add => _CreateCourseButton(
                    onPressed: () => createCourse(),
                  ),
                  _CourseTemplateTileStatus.added => _CourseIsCreatedIcon(),
                  _CourseTemplateTileStatus.loading => const _Loading(),
                },
              ),
              _CourseEditButton(
                onPressed: () async {
                  if (status == _CourseTemplateTileStatus.added) {
                    final result = await showCreateAnotherCourseDialog();
                    if (result != true || !mounted) return;
                  }

                  final course = await widget.onEditCourseTemplatePressed(
                    courseTemplate,
                  );
                  if (course != null && mounted) {
                    setCourseAsCreated();
                    _showCourseCreatedSnackBar(course);
                  }
                },
              ),
            ],
          ),
        ),
        if (widget.showDivider) const Divider(),
      ],
    );
  }
}

class _Loading extends StatelessWidget {
  const _Loading();

  @override
  Widget build(BuildContext context) {
    return const IconButton(onPressed: null, icon: LoadingCircle(size: 20));
  }
}

class _CourseIsCreatedIcon extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const IconButton(
      icon: Icon(Icons.check, color: Colors.greenAccent),
      onPressed: null,
    );
  }
}

class _CourseEditButton extends StatelessWidget {
  const _CourseEditButton({required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.edit),
      onPressed: onPressed,
      tooltip: 'Bearbeiten',
    );
  }
}

class _CreateCourseButton extends StatelessWidget {
  const _CreateCourseButton({required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.add_circle_outline),
      onPressed: onPressed,
      tooltip: 'Hinzufügen',
    );
  }
}

class _YouAlreadyHaveThisCourseDialog extends StatelessWidget {
  const _YouAlreadyHaveThisCourseDialog({required this.subject});

  final String subject;

  @override
  Widget build(BuildContext context) {
    return MaxWidthConstraintBox(
      maxWidth: 400,
      child: AlertDialog(
        title: const Text("Kurs bereits vorhanden"),
        content: Text(
          "Du hast bereits einen Kurs für das Fach $subject erstellt. Möchtest du einen weiteren Kurs erstellen?",
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("Nein"),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text("Ja"),
          ),
        ],
      ),
    );
  }
}

class _SelectSchoolClass extends StatefulWidget {
  const _SelectSchoolClass();

  @override
  State<_SelectSchoolClass> createState() => _SelectSchoolClassState();
}

class _SelectSchoolClassState extends State<_SelectSchoolClass> {
  (SchoolClassId, SchoolClassName)? selectedSchoolClass;

  @override
  void initState() {
    super.initState();
    final bloc = BlocProvider.of<CourseCreateBloc>(context);
    bloc.loadAdminSchoolClasses();
  }

  void setSelectId((SchoolClassId, SchoolClassName)? schoolClass) {
    setState(() {
      selectedSchoolClass = schoolClass;
    });
    final bloc = BlocProvider.of<CourseCreateBloc>(context);
    bloc.setSchoolClassId(schoolClass?.$1);
    showSelectedSnackBar(schoolClass?.$2);
  }

  void showSelectedSnackBar(SchoolClassName? name) {
    late String text;

    if (name == null) {
      text =
          'Kurse, die ab jetzt erstellt werden, werden mit keiner Schulklasse verknüpft.';
    } else {
      text =
          'Kurse, die ab jetzt erstellt werden, werden mit der Schulklasse "$name" verknüpft.';
    }

    showSnackSec(context: context, text: text, seconds: 5);
  }

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<CourseCreateBloc>(context);
    return StreamBuilder<List<(SchoolClassId, SchoolClassName)>?>(
      stream: bloc.myAdminSchoolClasses,
      builder: (context, snapshot) {
        final schoolClasses = snapshot.data;
        if (schoolClasses == null || schoolClasses.isEmpty) {
          return const SizedBox();
        }

        return Padding(
          padding: const EdgeInsets.all(12),
          child: CustomCard(
            padding: const EdgeInsets.all(12),
            child: RadioGroup<(SchoolClassId, SchoolClassName)?>(
              groupValue: selectedSchoolClass,
              onChanged: setSelectId,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  const Text(
                    "Schulklasse auswählen",
                    style: TextStyle(fontSize: 18),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    "Du bist in einer oder mehreren Schulklasse(n) Administrator. Wähle eine Schulklasse aus, um festzulegen, zu welcher Schulklasse die Kurse verknüpft werden sollen.",
                  ),
                  const SizedBox(height: 12),
                  for (final schoolClass in schoolClasses)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 4),
                      child: ListTile(
                        leading: SchoolClassAbbreviationAvatar(
                          name: schoolClass.$2,
                        ),
                        title: Text(schoolClass.$2),
                        onTap: () => setSelectId(schoolClass),
                        trailing: Radio<(SchoolClassId, SchoolClassName)?>(
                          value: schoolClass,
                        ),
                      ),
                    ),
                  const SizedBox(height: 4),
                  ListTile(
                    onTap: () => setSelectId(null),
                    leading: const Padding(
                      padding: EdgeInsets.only(left: 8),
                      child: Icon(Icons.remove_circle_outline),
                    ),
                    title: const Padding(
                      padding: EdgeInsets.only(left: 8),
                      child: Text("Mit keiner Schulklasse verknüpfen"),
                    ),
                    trailing: Radio<(SchoolClassId, SchoolClassName)?>(
                      value: null,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

extension on List<CourseTemplate> {
  void sortBySubject() {
    sort((a, b) => a.subject.compareTo(b.subject));
  }
}
