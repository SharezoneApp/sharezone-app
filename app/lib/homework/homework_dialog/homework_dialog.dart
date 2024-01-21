// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'dart:async';
import 'dart:developer';

import 'package:analytics/analytics.dart';
import 'package:bloc_presentation/bloc_presentation.dart';
import 'package:bloc_provider/bloc_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collection/collection.dart';
import 'package:common_domain_models/common_domain_models.dart';
import 'package:date/date.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:firebase_hausaufgabenheft_logik/firebase_hausaufgabenheft_logik.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart' as bloc_lib show BlocProvider;
import 'package:flutter_bloc/flutter_bloc.dart' hide BlocProvider;
import 'package:platform_check/platform_check.dart';
import 'package:sharezone/filesharing/dialog/attach_file.dart';
import 'package:sharezone/filesharing/dialog/course_tile.dart';
import 'package:sharezone/holidays/holiday_bloc.dart';
import 'package:sharezone/homework/homework_dialog/homework_dialog_bloc.dart';
import 'package:sharezone/main/application_bloc.dart';
import 'package:sharezone/main/constants.dart';
import 'package:sharezone/markdown/markdown_analytics.dart';
import 'package:sharezone/markdown/markdown_support.dart';
import 'package:sharezone/timetable/src/edit_time.dart';
import 'package:sharezone/util/next_lesson_calculator/next_lesson_calculator.dart';
import 'package:sharezone/widgets/material/list_tile_with_description.dart';
import 'package:sharezone/widgets/material/save_button.dart';
import 'package:sharezone_widgets/sharezone_widgets.dart';
import 'package:time/time.dart';

class HomeworkDialog extends StatefulWidget {
  const HomeworkDialog({
    super.key,
    required this.id,
    this.homeworkDialogApi,
    this.nextLessonCalculator,
    this.showDueDateSelectionChips = kDebugMode ||
        kDevelopmentStage == 'ALPHA' ||
        kDevelopmentStage == 'BETA',
  });

  static const tag = "homework-dialog";

  final HomeworkId? id;
  final HomeworkDialogApi? homeworkDialogApi;
  final NextLessonCalculator? nextLessonCalculator;
  final bool showDueDateSelectionChips;

  @override
  State createState() => _HomeworkDialogState();
}

class _HomeworkDialogState extends State<HomeworkDialog> {
  late HomeworkDialogBloc bloc;
  late Future<HomeworkDto?> homework;

  @override
  void initState() {
    super.initState();
    final markdownAnalytics = BlocProvider.of<MarkdownAnalytics>(context);
    final szContext = BlocProvider.of<SharezoneContext>(context);
    final analytics = szContext.analytics;

    late NextLessonCalculator nextLessonCalculator;
    if (widget.nextLessonCalculator != null) {
      nextLessonCalculator = widget.nextLessonCalculator!;
    } else {
      final holidayManager =
          BlocProvider.of<HolidayBloc>(context).holidayManager;
      nextLessonCalculator = NextLessonCalculator(
        timetableGateway: szContext.api.timetable,
        userGateway: szContext.api.user,
        holidayManager: holidayManager,
      );
    }

    if (widget.id != null) {
      homework = szContext.api.homework
          .singleHomework(widget.id!.id, source: Source.cache)
          .then((value) {
        bloc = HomeworkDialogBloc(
          homeworkId: widget.id,
          api: widget.homeworkDialogApi ?? HomeworkDialogApi(szContext.api),
          nextLessonCalculator: nextLessonCalculator,
          markdownAnalytics: markdownAnalytics,
          analytics: analytics,
        );
        return value;
      });
    } else {
      homework = Future.value(null);
      bloc = HomeworkDialogBloc(
        api: widget.homeworkDialogApi ?? HomeworkDialogApi(szContext.api),
        nextLessonCalculator: nextLessonCalculator,
        markdownAnalytics: markdownAnalytics,
        analytics: analytics,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: homework,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Container();
        }
        if (snapshot.hasError) {
          return Center(child: Text(snapshot.error!.toString()));
        }
        return bloc_lib.BlocProvider(
          create: (context) => bloc,
          child: HomeworkDialogMain(
            isEditing: snapshot.data != null,
            bloc: bloc,
            showDueDateSelectionChips: widget.showDueDateSelectionChips,
          ),
        );
      },
    );
  }
}

class HwDialogKeys {
  static const Key titleTextField = Key("title-field");
  static const Key courseTile = Key("course-tile");
  static const Key todoUntilTile = Key("todo-until-tile");
  static const Key customLessonChipDialogTextField =
      Key("custom-lesson-chip-dialog-text-field");
  static const Key customLessonChipDialogOkButton =
      Key("custom-lesson-chip-dialog-ok-button");
  static const Key lessonChipDeleteIcon = Key("lesson-chip-delete-icon");
  static const Key submissionTile = Key("submission-tile");
  static const Key submissionTimeTile = Key("submission-time-tile");
  static const Key descriptionField = Key("description-field");
  static const Key addAttachmentTile = Key("add-attachment-tile");
  static const Key attachmentOverflowMenuIcon = Key("attachment-overflow-menu");
  static const Key notifyCourseMembersTile = Key("notify-course-members-tile");
  static const Key isPrivateTile = Key("is-private-tile");
  static const Key saveButton = Key("save-button");
}

@visibleForTesting
class HomeworkDialogMain extends StatefulWidget {
  const HomeworkDialogMain({
    super.key,
    required this.isEditing,
    required this.bloc,
    this.showDueDateSelectionChips = false,
  });

  final bool isEditing;
  final bool showDueDateSelectionChips;
  final HomeworkDialogBloc bloc;

  @override
  HomeworkDialogMainState createState() => HomeworkDialogMainState();
}

class HomeworkDialogMainState extends State<HomeworkDialogMain> {
  final titleNode = FocusNode();

  @override
  void initState() {
    delayKeyboard(context: context, focusNode: titleNode);
    super.initState();
  }

  bool hasModifiedData() {
    final state = widget.bloc.state;
    return state is Ready && state.hasModifiedData;
  }

  Future<void> leaveDialog() async {
    if (hasModifiedData()) {
      final confirmedLeave = await warnUserAboutLeavingForm(context);
      if (confirmedLeave && context.mounted) Navigator.pop(context);
    } else {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocPresentationListener<HomeworkDialogBloc,
        HomeworkDialogBlocPresentationEvent>(
      bloc: widget.bloc,
      listener: (context, event) {
        switch (event) {
          case StartedUploadingAttachments():
            sendDataToFrankfurtSnackBar(context);
            break;
          case RequiredFieldsNotFilledOut():
            showSnackSec(
              text: "Bitte fülle alle erforderlichen Felder aus!",
              context: context,
              seconds: 2,
            );
          case SavingFailed(error: var error):
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
            showLeftRightAdaptiveDialog(
              content: Text(
                  'Hausaufgabe konnte nicht gespeichert werden.\n\n$error\n\nFalls der Fehler weiterhin auftritt, kontaktiere bitte den Support.'),
              left: null,
              right: AdaptiveDialogAction.ok,
              context: context,
            );
        }
      },
      child: BlocConsumer<HomeworkDialogBloc, HomeworkDialogState>(
        buildWhen: (previous, current) => current is! SavedSuccessfully,
        listener: (context, state) {
          if (state is SavedSuccessfully) {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
            Navigator.pop(context);
          }
        },
        builder: (context, state) {
          return switch (state) {
            LoadingHomework() =>
              const Center(child: CircularProgressIndicator()),
            SavedSuccessfully() => throw UnimplementedError(
                'Placeholder, we pop the Navigator above so this should not be reached.'),
            Ready() => PopScope(
                canPop: false,
                onPopInvoked: (didPop) async {
                  if (didPop) return;

                  final hasInputChanged = hasModifiedData();
                  final navigator = Navigator.of(context);
                  if (!hasInputChanged) {
                    navigator.pop();
                    return;
                  }

                  final shouldPop = await warnUserAboutLeavingForm(context);
                  if (shouldPop && context.mounted) {
                    navigator.pop();
                  }
                },
                child: Scaffold(
                  body: Column(
                    children: <Widget>[
                      _AppBar(
                          editMode: widget.isEditing,
                          focusNodeTitle: titleNode,
                          onCloseTap: () => leaveDialog(),
                          titleField: _TitleField(
                            focusNode: titleNode,
                            state: state,
                          )),
                      Expanded(
                        child: SingleChildScrollView(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              const SizedBox(height: 8),
                              _CourseTile(state: state),
                              const _MobileDivider(),
                              _TodoUntilPicker(
                                state: state,
                                showLessonChips: widget.isEditing
                                    ? false
                                    : widget.showDueDateSelectionChips,
                              ),
                              const _MobileDivider(),
                              _SubmissionsSwitch(state: state),
                              const _MobileDivider(),
                              _DescriptionField(state: state),
                              const _MobileDivider(),
                              _AttachFile(state: state),
                              const _MobileDivider(),
                              _SendNotification(state: state),
                              const _MobileDivider(),
                              _PrivateHomeworkSwitch(state: state),
                              const _MobileDivider(),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              )
          };
        },
      ),
    );
  }
}

class _MobileDivider extends StatelessWidget {
  const _MobileDivider();

  @override
  Widget build(BuildContext context) {
    if (PlatformCheck.isDesktopOrWeb) return const SizedBox(height: 4);
    return const Divider(height: 0);
  }
}

class HwDialogErrorStrings {
  static const String emptyTitle =
      "Bitte gib einen Titel für die Hausaufgabe an!";
  static const String emptyCourseSnackbar =
      "Bitte gib einen Kurs für die Hausaufgabe an!";
  static const String emptyCourse = "Keinen Kurs ausgewählt";
  static const String emptyTodoUntil =
      "Bitte gib ein Fälligkeitsdatum für die Hausaufgabe an!";
}

class _SaveButton extends StatelessWidget {
  const _SaveButton({this.editMode = false});

  final bool editMode;

  Future<void> onPressed(BuildContext context) async {
    final bloc = bloc_lib.BlocProvider.of<HomeworkDialogBloc>(context);
    try {
      bloc.add(const Save());
    } on Exception catch (e) {
      log("Exception when submitting: $e", error: e);
      showSnackSec(
        text:
            "Es gab einen unbekannten Fehler (${e.toString()}) 😖 Bitte kontaktiere den Support!",
        context: context,
        seconds: 5,
      );
    }
  }

  void hideSendDataToFrankfurtSnackBar(BuildContext context) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
  }

  @override
  Widget build(BuildContext context) {
    return SaveButton(
      key: HwDialogKeys.saveButton,
      tooltip: "Hausaufgabe speichern",
      onPressed: () => onPressed(context),
    );
  }
}

class _TodoUntilPicker extends StatelessWidget {
  final Ready state;
  final bool showLessonChips;

  const _TodoUntilPicker({
    required this.state,
    required this.showLessonChips,
  });

  @override
  Widget build(BuildContext context) {
    final bloc = bloc_lib.BlocProvider.of<HomeworkDialogBloc>(context);

    return MaxWidthConstraintBox(
      child: SafeArea(
        top: false,
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DefaultTextStyle.merge(
              style: TextStyle(
                color: state.dueDate.error != null ? Colors.red : null,
              ),
              child: DatePicker(
                selectedDate: state.dueDate.$1?.toDateTime,
                // If a user chooses a date that was already selected by using a
                // due date selection chip, we want [selectDate] to be called
                // anyways so we can change the selection to a manual due date
                // selection (chip will be deselected).
                ignoreSameDateSelection: false,
                selectDate: (newDate) {
                  bloc.add(DueDateChanged(
                      DueDateSelection.date(Date.fromDateTime(newDate))));
                },
                key: HwDialogKeys.todoUntilTile,
                padding: showLessonChips
                    ? const EdgeInsets.fromLTRB(12, 12, 12, 5)
                    : const EdgeInsets.all(12),
              ),
            ),
            if (showLessonChips)
              const Padding(
                padding: EdgeInsets.only(top: 4, left: 3.0),
                child: _DueDateChips(
                  initialChips: IListConst([
                    DueDateSelection.nextSchoolday,
                    DueDateSelection.inXLessons(1),
                    DueDateSelection.inXLessons(2),
                  ]),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _DueDateChip {
  final String label;
  final bool isSelected;
  final bool isDeletable;
  final DueDateSelection dueDate;

  const _DueDateChip({
    required this.label,
    required this.dueDate,
    this.isSelected = false,
    this.isDeletable = false,
  });

  _DueDateChip copyWith({
    String? label,
    bool? isSelected,
    bool? isDeletable,
    DueDateSelection? dueDate,
  }) {
    return _DueDateChip(
      label: label ?? this.label,
      isSelected: isSelected ?? this.isSelected,
      isDeletable: isDeletable ?? this.isDeletable,
      dueDate: dueDate ?? this.dueDate,
    );
  }

  @override
  String toString() {
    return '_LessonChip(label: $label, isSelected: $isSelected, isDeletable: $isDeletable, dueDate: $dueDate)';
  }
}

class _DueDateChipsController extends ChangeNotifier {
  final void Function(DueDateSelection?) onChanged;
  IList<_DueDateChip> chips = IList();

  _DueDateChipsController({
    required IList<DueDateSelection> initialChips,
    required this.onChanged,
  }) {
    chips = initialChips
        .map((config) => _DueDateChip(
              label: _getName(config),
              dueDate: config,
              isSelected: false,
              isDeletable: false,
            ))
        .toIList();
    notifyListeners();
  }

  String _getName(DueDateSelection dueDate) {
    switch (dueDate) {
      case NextSchooldayDueDateSelection _:
        return 'Nächster Schultag';
      case InXLessonsDueDateSelection due:
        return switch (due.inXLessons) {
          1 => 'Nächste Stunde',
          2 => 'Übernächste Stunde',
          _ => '${due.inXLessons}.-nächste Stunde',
        };
      case DateDueDateSelection _:
        throw Error();
    }
  }

  /// Updates the selection of the chips to the given [selection].
  void updateSelection(DueDateSelection? selection) {
    if (selection == null) {
      deselectChips();
    } else {
      selectChip(selection);
    }
  }

  void deselectChips() {
    chips = chips.map((chip) => chip.copyWith(isSelected: false)).toIList();
    notifyListeners();
  }

  void selectChip(DueDateSelection dueDate) {
    final old = chips;
    chips = chips.map((chip) {
      if (chip.dueDate == dueDate) {
        return chip.copyWith(isSelected: true);
      } else {
        return chip.copyWith(isSelected: false);
      }
    }).toIList();
    if (old != chips) {
      onChanged(dueDate);
    }
    notifyListeners();
  }

  void addInXLessonsChip(InXLessonsDueDateSelection inXLessons) {
    final alreadyExists = chips.firstWhereOrNull(
          (chip) => chip.dueDate == inXLessons,
        ) !=
        null;
    if (!alreadyExists) {
      chips = chips.add(_DueDateChip(
        label: '${inXLessons.inXLessons}.-nächste Stunde',
        dueDate: inXLessons,
        isDeletable: true,
      ));
    }
    selectChip(inXLessons);
    notifyListeners();
  }

  void deleteInXLessonsChip(InXLessonsDueDateSelection inXLessons) {
    final old = chips;
    chips = chips.removeWhere((chip) => chip.dueDate == inXLessons);
    if (old != chips) {
      onChanged(null);
    }
    notifyListeners();
  }
}

Map<String, dynamic> _getAnalyticsData(DueDateSelection s) {
  return switch (s) {
    NextSchooldayDueDateSelection _ => {'type': 'in_x_school_days', 'value': 1},
    InXLessonsDueDateSelection _ => {
        'type': 'in_x_lessons',
        'value': s.inXLessons
      },
    DateDueDateSelection _ => {'type': 'date'}
  };
}

class _DueDateChips extends StatefulWidget {
  const _DueDateChips({
    required this.initialChips,
  });

  final IList<DueDateSelection> initialChips;

  @override
  State<_DueDateChips> createState() => _DueDateChipsState();
}

class _DueDateChipsState extends State<_DueDateChips> {
  late _DueDateChipsController controller;

  @override
  void initState() {
    super.initState();
    final bloc =
        bloc_lib.BlocProvider.of<HomeworkDialogBloc>(context, listen: false);
    controller = _DueDateChipsController(
      initialChips: widget.initialChips,
      onChanged: (selection) {
        if (selection != null) {
          bloc.add(DueDateChanged(selection));
          return;
        }
        // If a selected chip was deleted then selection will be null and we
        // change to manual date selection with the previous selected date.
        final state = bloc.state;
        if (state is Ready && state.dueDate.$1 != null) {
          final oldDate = state.dueDate.$1!;
          bloc.add(DueDateChanged(DueDateSelection.date(oldDate)));
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final analytics = AnalyticsProvider.ofOrNullObject(context);
    final bloc =
        bloc_lib.BlocProvider.of<HomeworkDialogBloc>(context, listen: true);
    final state = bloc.state;

    final bool lessonChipsSelectable;
    if (state is Ready) {
      lessonChipsSelectable = state.dueDate.lessonChipsSelectable;
      controller.updateSelection(state.dueDate.selection);
    } else {
      lessonChipsSelectable = false;
    }
    final beforeThemeChangeContext = context;

    return Theme(
      data: ThemeData.from(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: blueColor,
          brightness: Theme.of(context).brightness,
        ),
      ),
      child: ScrollConfiguration(
        // It's unintuitive if users can't drag the chips on desktop.
        behavior: ScrollConfiguration.of(context).copyWith(dragDevices: {
          PointerDeviceKind.touch,
          PointerDeviceKind.mouse,
        }),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: ListenableBuilder(
              listenable: controller,
              builder: (context, _) {
                return Row(
                  children: [
                    const SizedBox(width: 10),
                    for (final chip in controller.chips)
                      Padding(
                        padding: const EdgeInsets.only(right: 10),
                        child: InputChip(
                          label: Text(chip.label),
                          selected: chip.isSelected,
                          // Copied from source code of InputChip, we need to add
                          // our key here for tests.
                          deleteIcon: const Icon(Icons.clear,
                              key: HwDialogKeys.lessonChipDeleteIcon, size: 18),
                          onSelected:
                              chip.dueDate is! InXLessonsDueDateSelection ||
                                      lessonChipsSelectable
                                  ? (newState) {
                                      controller.selectChip(chip.dueDate);

                                      analytics.log(NamedAnalyticsEvent(
                                        name: 'due_date_chip_ui_tapped',
                                        data: _getAnalyticsData(chip.dueDate)
                                          ..addAll({
                                            'was_selected': chip.isSelected,
                                          }),
                                      ));
                                    }
                                  : null,
                          // If onSelected is null but onDeleted is not null then
                          // the chip will still look selectable, but only
                          // tapping the delete icon will actually work. So if the
                          // chip is not selectable, we set onDeleted to null.
                          // Not being able to delete the chip if it is not
                          // selectable shouldn't be a problem for users.
                          onDeleted: chip.isDeletable && lessonChipsSelectable
                              ? () {
                                  controller.deleteInXLessonsChip(chip.dueDate
                                      as InXLessonsDueDateSelection);

                                  analytics.log(NamedAnalyticsEvent(
                                    name: 'due_date_chip_ui_deleted',
                                    data: _getAnalyticsData(chip.dueDate)
                                      ..addAll({
                                        'was_selected': chip.isSelected,
                                      }),
                                  ));
                                }
                              : null,
                        ),
                      ),
                    InputChip(
                      avatar: Icon(
                        Icons.edit,
                        color: Theme.of(context).iconTheme.color,
                      ),
                      label: const Text('Benutzerdefiniert'),
                      onPressed: lessonChipsSelectable
                          ? () async {
                              // The normal context would cause material3 to be
                              // applied the dialog which is not what we want.
                              await _onCustomChipTap(beforeThemeChangeContext);
                            }
                          : null,
                    ),
                    const SizedBox(width: 10),
                  ],
                );
              }),
        ),
      ),
    );
  }

  Future<void> _onCustomChipTap(BuildContext context) async {
    final analytics = AnalyticsProvider.ofOrNullObject(context);

    int? inXHours;
    final newInXHours = await showLeftRightAdaptiveDialog<dynamic>(
      context: context,
      title: 'Stundenzeit auswählen',
      right: AdaptiveDialogAction(
        key: HwDialogKeys.customLessonChipDialogOkButton,
        title: 'OK',
        onPressed: () {
          Navigator.pop(context, inXHours);
        },
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          MaxWidthConstraintBox(
            maxWidth: 270,
            child: Text(
              'Wähle aus, in wie vielen Stunden die Hausaufgabe fällig ist.',
              style: Theme.of(context).textTheme.bodySmall,
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 32),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 50,
                child: TextField(
                  key: HwDialogKeys.customLessonChipDialogTextField,
                  maxLength: 2,
                  textAlign: TextAlign.end,
                  style: const TextStyle(
                    fontSize: 20,
                  ),
                  decoration: const InputDecoration(
                    hintText: '5',
                    border: OutlineInputBorder(),
                  ),
                  textAlignVertical: TextAlignVertical.center,
                  onChanged: (value) {
                    inXHours = int.tryParse(value);
                  },
                  maxLengthEnforcement: MaxLengthEnforcement.enforced,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  keyboardType: TextInputType.number,
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(bottom: 18),
                child: Text('.-nächste Stunde'),
              ),
            ],
          ),
        ],
      ),
    );

    if (newInXHours != null && newInXHours is int) {
      controller.addInXLessonsChip(InXLessonsDueDateSelection(newInXHours));
      analytics.log(NamedAnalyticsEvent(
        name: 'due_date_chip_ui_added',
        data: _getAnalyticsData(InXLessonsDueDateSelection(newInXHours)),
      ));
    }
  }
}

class _AppBar extends StatelessWidget {
  const _AppBar({
    required this.editMode,
    required this.focusNodeTitle,
    required this.onCloseTap,
    required this.titleField,
  });

  final bool editMode;
  final VoidCallback onCloseTap;
  final Widget titleField;

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
                  _SaveButton(
                    editMode: editMode,
                  ),
                ],
              ),
            ),
            titleField,
          ],
        ),
      ),
    );
  }
}

class _TitleField extends StatelessWidget {
  const _TitleField({
    required this.focusNode,
    required this.state,
  });

  final Ready state;
  final FocusNode focusNode;

  @override
  Widget build(BuildContext context) {
    final bloc = bloc_lib.BlocProvider.of<HomeworkDialogBloc>(context);
    return MaxWidthConstraintBox(
      child: _TitleFieldBase(
        prefilledTitle: state.title.$1,
        focusNode: focusNode,
        onChanged: (newTitle) {
          bloc.add(TitleChanged(newTitle));
        },
        errorText: state.title.error is EmptyTitleException
            ? HwDialogErrorStrings.emptyTitle
            : state.title.error?.toString(),
      ),
    );
  }
}

class _TitleFieldBase extends StatelessWidget {
  const _TitleFieldBase({
    required this.prefilledTitle,
    required this.onChanged,
    this.errorText,
    this.focusNode,
  });

  final String? prefilledTitle;
  final String? errorText;
  final FocusNode? focusNode;
  final Function(String) onChanged;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height / 3,
      ),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20)
              .add(const EdgeInsets.only(top: 8)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              PrefilledTextField(
                key: HwDialogKeys.titleTextField,
                prefilledText: prefilledTitle,
                focusNode: focusNode,
                cursorColor: Colors.white,
                maxLines: null,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.w400,
                ),
                decoration: const InputDecoration(
                  hintText: "Titel eingeben (z.B. AB Nr. 1 - 3)",
                  hintStyle: TextStyle(color: Colors.white),
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  contentPadding: EdgeInsets.zero,
                  fillColor: Colors.transparent,
                ),
                onChanged: onChanged,
                textCapitalization: TextCapitalization.sentences,
              ),
              Text(
                errorText ?? "",
                style: TextStyle(color: Colors.red[700], fontSize: 12),
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}

class _CourseTile extends StatelessWidget {
  const _CourseTile({required this.state});

  final Ready state;

  @override
  Widget build(BuildContext context) {
    final bloc = bloc_lib.BlocProvider.of<HomeworkDialogBloc>(context);
    final courseState = state.course;
    final isDisabled = courseState is CourseChosen && !courseState.isChangeable;
    String? errorText;
    if (courseState is NoCourseChosen && courseState.error != null) {
      errorText = courseState.error is NoCourseChosenException
          ? HwDialogErrorStrings.emptyCourse
          : courseState.error.toString();
    }

    return MaxWidthConstraintBox(
      child: SafeArea(
        top: false,
        bottom: false,
        child: CourseTileBase(
          key: HwDialogKeys.courseTile,
          courseName:
              courseState is CourseChosen ? courseState.courseName : null,
          errorText: errorText,
          onTap: isDisabled
              ? null
              : () => CourseTile.onTap(context, onChangedId: (course) {
                    bloc.add(CourseChanged(course));
                  }),
        ),
      ),
    );
  }
}

class _SendNotification extends StatelessWidget {
  const _SendNotification({required this.state});

  final Ready state;

  @override
  Widget build(BuildContext context) {
    final bloc = bloc_lib.BlocProvider.of<HomeworkDialogBloc>(context);

    return MaxWidthConstraintBox(
      child: SafeArea(
        top: false,
        bottom: false,
        child: _SendNotificationBase(
          title:
              "Kursmitglieder ${state.isEditing ? "über die Änderungen " : ""}benachrichtigen",
          onChanged: (newValue) =>
              bloc.add(NotifyCourseMembersChanged(newValue)),
          sendNotification: state.notifyCourseMembers,
          description: state.isEditing
              ? null
              : "Sende eine Benachrichtigung an deine Kursmitglieder, dass du eine neue Hausaufgabe erstellt hast.",
        ),
      ),
    );
  }
}

class _SendNotificationBase extends StatelessWidget {
  const _SendNotificationBase({
    required this.title,
    required this.sendNotification,
    required this.onChanged,
    this.description,
  });

  final String title;
  final String? description;
  final bool sendNotification;
  final Function(bool) onChanged;

  @override
  Widget build(BuildContext context) {
    return ListTileWithDescription(
      key: HwDialogKeys.notifyCourseMembersTile,
      leading: const Icon(Icons.notifications_active),
      title: Text(title),
      trailing: Switch.adaptive(
        onChanged: onChanged,
        value: sendNotification,
      ),
      onTap: () => onChanged(!sendNotification),
      description: description != null ? Text(description!) : null,
    );
  }
}

class _DescriptionField extends StatelessWidget {
  const _DescriptionField({required this.state});

  final Ready state;

  @override
  Widget build(BuildContext context) {
    final bloc = bloc_lib.BlocProvider.of<HomeworkDialogBloc>(context);
    return _DescriptionFieldBase(
      onChanged: (newDescription) =>
          bloc.add(DescriptionChanged(newDescription)),
      prefilledDescription: state.description,
    );
  }
}

class _DescriptionFieldBase extends StatelessWidget {
  const _DescriptionFieldBase({
    required this.onChanged,
    required this.prefilledDescription,
  });

  final Function(String) onChanged;
  final String? prefilledDescription;

  @override
  Widget build(BuildContext context) {
    return MaxWidthConstraintBox(
      child: SafeArea(
        top: false,
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.subject),
                title: PrefilledTextField(
                  key: HwDialogKeys.descriptionField,
                  prefilledText: prefilledDescription,
                  maxLines: null,
                  scrollPadding: const EdgeInsets.all(16.0),
                  keyboardType: TextInputType.multiline,
                  decoration: const InputDecoration(
                    hintText: "Zusatzinformationen eingeben",
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    errorBorder: InputBorder.none,
                    fillColor: Colors.transparent,
                  ),
                  onChanged: onChanged,
                  textCapitalization: TextCapitalization.sentences,
                ),
              ),
              const Padding(
                padding: EdgeInsets.fromLTRB(16, 0, 16, 12),
                child: MarkdownSupport(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AttachFile extends StatelessWidget {
  const _AttachFile({required this.state});

  final Ready state;

  @override
  Widget build(BuildContext context) {
    final bloc = bloc_lib.BlocProvider.of<HomeworkDialogBloc>(context);
    return MaxWidthConstraintBox(
      child: SafeArea(
        top: false,
        bottom: false,
        child: AttachFileBase(
          key: HwDialogKeys.addAttachmentTile,
          onLocalFilesAdded: (localFiles) =>
              bloc.add(AttachmentsAdded(localFiles.toIList())),
          onLocalFileRemoved: (localFile) =>
              bloc.add(AttachmentRemoved(localFile.fileId)),
          onCloudFileRemoved: (cloudFile) =>
              bloc.add(AttachmentRemoved(FileId(cloudFile.id!))),
          cloudFiles: state.attachments
              .where((file) => file.cloudFile != null)
              .map((file) => file.cloudFile!)
              .toList(),
          localFiles: state.attachments
              .where((file) => file.localFile != null)
              .map((file) => file.localFile!)
              .toList(),
        ),
      ),
    );
  }
}

class _SubmissionsSwitch extends StatelessWidget {
  final Ready state;

  const _SubmissionsSwitch({required this.state});

  @override
  Widget build(BuildContext context) {
    final submissionsState = state.submissions;
    final bloc = bloc_lib.BlocProvider.of<HomeworkDialogBloc>(context);
    final submissionTime = submissionsState is SubmissionsEnabled
        ? submissionsState.deadline
        : null;

    return MaxWidthConstraintBox(
      child: _SubmissionsSwitchBase(
        key: HwDialogKeys.submissionTile,
        isWidgetEnabled: state.submissions.isChangeable,
        submissionsEnabled: state.submissions.isEnabled,
        onChanged: (newIsEnabled) => bloc.add(SubmissionsChanged((
          enabled: newIsEnabled,
          submissionTime: newIsEnabled ? submissionTime : null
        ))),
        onTimeChanged: (newTime) => bloc
            .add(SubmissionsChanged((enabled: true, submissionTime: newTime))),
        time: submissionTime,
      ),
    );
  }
}

class _SubmissionsSwitchBase extends StatelessWidget {
  const _SubmissionsSwitchBase({
    super.key,
    required this.isWidgetEnabled,
    required this.submissionsEnabled,
    required this.onChanged,
    required this.onTimeChanged,
    required this.time,
  });

  final bool isWidgetEnabled;
  final bool submissionsEnabled;
  final Function(bool) onChanged;
  final Function(Time) onTimeChanged;
  final Time? time;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        ListTile(
          leading: const Icon(Icons.folder_open),
          title: const Text("Mit Abgabe"),
          onTap: isWidgetEnabled ? () => onChanged(!submissionsEnabled) : null,
          trailing: Switch.adaptive(
            value: submissionsEnabled,
            onChanged: isWidgetEnabled ? onChanged : null,
          ),
        ),
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 200),
          child: submissionsEnabled
              ? ListTile(
                  key: HwDialogKeys.submissionTimeTile,
                  title: const Text("Abgabe-Uhrzeit"),
                  onTap: () async {
                    await hideKeyboardWithDelay(context: context);
                    if (!context.mounted) return;

                    final initialTime = time == Time(hour: 23, minute: 59)
                        ? Time(hour: 18, minute: 0)
                        : time;
                    final newTime =
                        await selectTime(context, initialTime: initialTime);
                    if (newTime != null) {
                      onTimeChanged(newTime);
                    }
                  },
                  trailing: Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: Text(time.toString()),
                  ),
                )
              : Container(),
        ),
      ],
    );
  }
}

class _PrivateHomeworkSwitch extends StatelessWidget {
  const _PrivateHomeworkSwitch({
    required this.state,
  });

  final Ready state;

  @override
  Widget build(BuildContext context) {
    final bloc = bloc_lib.BlocProvider.of<HomeworkDialogBloc>(context);
    return MaxWidthConstraintBox(
      child: SafeArea(
        top: false,
        bottom: false,
        child: _PrivateHomeworkSwitchBase(
          key: HwDialogKeys.isPrivateTile,
          isPrivate: state.isPrivate.$1,
          onChanged: state.isPrivate.isChangeable
              ? (newVal) => bloc.add(IsPrivateChanged(newVal))
              : null,
        ),
      ),
    );
  }
}

class _PrivateHomeworkSwitchBase extends StatelessWidget {
  const _PrivateHomeworkSwitchBase({
    required this.isPrivate,
    this.onChanged,
    super.key,
  });

  final bool isPrivate;

  /// Called when the user changes if the homework is private.
  ///
  /// Passing `null` disables the tile.
  final Function(bool)? onChanged;

  @override
  Widget build(BuildContext context) {
    final isEnabled = onChanged != null;
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      leading: const Icon(Icons.security),
      title: const Text("Privat"),
      subtitle: const Text("Hausaufgabe nicht mit dem Kurs teilen."),
      enabled: isEnabled,
      trailing: Switch.adaptive(
        value: isPrivate,
        onChanged: isEnabled ? onChanged! : null,
      ),
      onTap: isEnabled ? () => onChanged!(!isPrivate) : null,
    );
  }
}
