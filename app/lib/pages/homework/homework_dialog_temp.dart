// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'dart:async';
import 'dart:math';

import 'package:bloc_base/bloc_base.dart';
import 'package:bloc_provider/bloc_provider.dart';
import 'package:firebase_hausaufgabenheft_logik/firebase_hausaufgabenheft_logik.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:group_domain_models/group_domain_models.dart';
import 'package:rxdart/subjects.dart';
import 'package:sharezone/filesharing/dialog/course_tile.dart';
import 'package:sharezone/widgets/material/save_button.dart';
import 'package:sharezone_utils/platform.dart';
import 'package:sharezone_widgets/sharezone_widgets.dart';

class TempHomeworkDialog extends StatelessWidget {
  const TempHomeworkDialog({
    Key? key,
  }) : super(key: key);

  static const tag = "homework-dialog";

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData.from(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: blueColor),
      ),
      // data: Theme.of(context).copyWith(useMaterial3: true),
      child: BlocProvider<FakeHomeworkDialogBloc>(
        bloc: FakeHomeworkDialogBloc(),
        child: const __HomeworkDialog(),
      ),
    );
  }
}

class __HomeworkDialog extends StatefulWidget {
  const __HomeworkDialog({Key? key}) : super(key: key);

  @override
  __HomeworkDialogState createState() => __HomeworkDialogState();
}

class __HomeworkDialogState extends State<__HomeworkDialog> {
  final titleNode = FocusNode();
  bool editMode = false;

  @override
  void initState() {
    delayKeyboard(context: context, focusNode: titleNode);
    super.initState();
  }

  Future<void> leaveDialog() async {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => Future.value(true),
      child: Scaffold(
        body: Column(
          children: <Widget>[
            _AppBar(
              oldHomework: null,
              editMode: editMode,
              focusNodeTitle: titleNode,
              onCloseTap: () => leaveDialog(),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    const SizedBox(height: 8),
                    const _CourseTile(),
                    const _MobileDivider(),
                    _TodoUntilPicker(),
                    const _MobileDivider(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MobileDivider extends StatelessWidget {
  const _MobileDivider({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (PlatformCheck.isDesktopOrWeb) return Container();
    return const Divider(height: 0);
  }
}

class _SaveButton extends StatelessWidget {
  const _SaveButton({Key? key}) : super(key: key);

  Future<void> onPressed(BuildContext context) async {
    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    return SaveButton(
      tooltip: "Hausaufgabe speichern",
      onPressed: () => onPressed(context),
    );
  }
}

class _TodoUntilPicker extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<FakeHomeworkDialogBloc>(context);
    return MaxWidthConstraintBox(
      child: SafeArea(
        top: false,
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            StreamBuilder<DateTime>(
              stream: bloc.todoUntil,
              builder: (context, snapshot) => DefaultTextStyle.merge(
                style: TextStyle(
                  color: snapshot.hasError ? Colors.red : null,
                ),
                child: DatePicker(
                  padding: const EdgeInsets.all(12),
                  selectedDate: snapshot.data,
                  selectDate: bloc.changeTodoUntil,
                ),
              ),
            ),
            _InXHours(inXHoursSelected: (inXHours) {
              print(inXHours);
            }),
          ],
        ),
      ),
    );
  }
}

class _InXHours extends StatefulWidget {
  const _InXHours({required this.inXHoursSelected, super.key});

  final void Function(int) inXHoursSelected;

  @override
  State<_InXHours> createState() => _InXHoursState();
}

typedef FilterData = (String label, {int inXHours});

class _InXHoursState extends State<_InXHours> {
  final filters = <int, FilterData>{
    1: ("Nächste Stunde", inXHours: 1),
    2: ("Übernächste Stunde", inXHours: 2),
    // 3: (getName(3), inXHours: 3),
  };
  int? selectedFilter;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          const SizedBox(width: 10),
          for (final filter in filters.values)
            Padding(
              padding: const EdgeInsets.only(right: 10),
              // child: FilterChip(
              child: InputChip(
                label: Text(filter.$1),
                selected: selectedFilter == filter.inXHours,
                onSelected: (newState) {
                  setState(() {
                    selectedFilter == filter.inXHours
                        ? selectedFilter = null
                        : selectedFilter = filter.inXHours;
                  });
                  widget.inXHoursSelected(filter.inXHours);
                },
                onDeleted: filter.inXHours == 1 ||
                        filter.inXHours == 2 ||
                        filter.inXHours == 3
                    ? null
                    : () {
                        setState(() {
                          if (filter.inXHours == selectedFilter) {
                            selectedFilter = null;
                          }
                          filters.removeWhere(
                              (key, value) => key == filter.inXHours);
                        });
                      },
              ),
            ),
          InputChip(
            avatar: const Icon(Icons.edit),
            label: Text('Benutzerdefiniert'),
            onPressed: () async {
              final newInXHours = await showLeftRightAdaptiveDialog<dynamic>(
                  context: context,
                  title: 'Stundenzeit auswählen',
                  right: AdaptiveDialogAction(
                    title: 'OK',
                    onPressed: () {
                      // Navigator.pop(context, Random().nextInt(10));
                      Navigator.pop(context, 4);
                    },
                  ),
                  content: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 50,
                        child: TextField(
                          maxLength: 2,
                          maxLengthEnforcement: MaxLengthEnforcement.enforced,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly
                          ],
                          keyboardType: TextInputType.number,
                        ),
                      ),
                      Text('.-nächste Stunde'),
                    ],
                  )
                  // content: Text.rich(
                  //     textAlign: TextAlign.center,
                  //     softWrap: false,
                  //     TextSpan(
                  //       style: TextStyle(),
                  //       children: [
                  //         const TextSpan(text: 'In '),
                  //         WidgetSpan(
                  //             child: SizedBox(
                  //           width: 50,
                  //           child: TextField(
                  //             maxLength: 2,
                  //             maxLengthEnforcement: MaxLengthEnforcement.enforced,
                  //             inputFormatters: [
                  //               FilteringTextInputFormatter.digitsOnly
                  //             ],
                  //             keyboardType: TextInputType.number,
                  //           ),
                  //         )),
                  //         const TextSpan(text: ' Stunden.'),
                  //       ],
                  //     )),
                  );

              if (newInXHours != null && newInXHours is int) {
                filters[newInXHours] =
                    (getName(newInXHours), inXHours: newInXHours);
                setState(() {
                  selectedFilter = newInXHours;
                });
              }
            },
          ),
          const SizedBox(width: 10),
        ],
      ),
    );
  }

  static String getName(int inXHours) {
    return switch (inXHours) {
      1 => 'Nächste Stunde',
      2 => 'Übernächste Stunde',
      >= 3 => '$inXHours.-nächste Stunde',
      _ => throw Exception('Invalid inXHours: $inXHours'),
    };
  }
}

class _AppBar extends StatelessWidget {
  const _AppBar({
    Key? key,
    required this.oldHomework,
    required this.editMode,
    required this.focusNodeTitle,
    required this.onCloseTap,
  }) : super(key: key);

  final HomeworkDto? oldHomework;
  final bool editMode;
  final VoidCallback onCloseTap;

  final FocusNode focusNodeTitle;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Theme.of(context).isDarkTheme
          ? Theme.of(context).appBarTheme.backgroundColor
          : Theme.of(context).primaryColor,
      elevation: 1,
      child: SafeArea(
        top: true,
        bottom: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.fromLTRB(4, 6, 6, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.white),
                    onPressed: onCloseTap,
                    tooltip: "Schließen",
                  ),
                  const _SaveButton(),
                ],
              ),
            ),
            MaxWidthConstraintBox(
              child: _TitleField(
                title: oldHomework?.title ?? "",
                focusNode: focusNodeTitle,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TitleField extends StatelessWidget {
  const _TitleField({Key? key, this.title, this.focusNode}) : super(key: key);

  final String? title;
  final FocusNode? focusNode;

  @override
  Widget build(BuildContext context) {
    // final FakeHomeworkDialogBloc bloc =
    //     BlocProvider.of<FakeHomeworkDialogBloc>(context);
    return ConstrainedBox(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height / 3,
      ),
      child: SingleChildScrollView(
        child: StreamBuilder<String>(
          stream: Stream.value('HA S. 34'),
          builder: (context, snapshot) => Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                PrefilledTextField(
                  prefilledText: title,
                  focusNode: focusNode,
                  cursorColor: Colors.white,
                  maxLines: null,
                  style: const TextStyle(color: Colors.white, fontSize: 22),
                  decoration: const InputDecoration(
                    hintText: "Titel eingeben (z.B. AB Nr. 1 - 3)",
                    hintStyle: TextStyle(color: Colors.white),
                    border: InputBorder.none,
                  ),
                  onChanged: (String title) {},
                  textCapitalization: TextCapitalization.sentences,
                ),
                Text(
                  snapshot.error?.toString() ?? "",
                  style: TextStyle(color: Colors.red[700], fontSize: 12),
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _CourseTile extends StatelessWidget {
  const _CourseTile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<FakeHomeworkDialogBloc>(context);
    return MaxWidthConstraintBox(
      child: SafeArea(
        top: false,
        bottom: false,
        child: CourseTile(
          courseStream: bloc.courseSegment,
          onChanged: bloc.changeCourseSegment,
          editMode: false,
          // editMode: editMode,
        ),
      ),
    );
  }
}

class FakeHomeworkDialogBloc extends BlocBase {
  BehaviorSubject<Course> courseSegment = BehaviorSubject<Course>();
  BehaviorSubject<DateTime> todoUntil = BehaviorSubject<DateTime>();

  void changeTodoUntil(DateTime dateTime) {}
  void changeCourseSegment(Course course) {}

  @override
  void dispose() {
    courseSegment.close();
    todoUntil.close();
  }
}
