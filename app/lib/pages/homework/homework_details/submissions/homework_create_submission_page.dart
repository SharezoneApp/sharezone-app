// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:abgabe_client_lib/abgabe_client_lib.dart';
import 'package:bloc_provider/bloc_provider.dart';
import 'package:files_usecases/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:sharezone/filesharing/dialog/attach_file.dart';
import 'package:sharezone/filesharing/widgets/cloud_file_icon.dart';
import 'package:sharezone/homework/shared/placeholder_templates.dart';
import 'package:sharezone_common/helper_functions.dart';
import 'package:sharezone_utils/platform.dart';
import 'package:sharezone_widgets/adaptive_dialog.dart';
import 'package:sharezone_widgets/announcement_card.dart';
import 'package:sharezone_widgets/snackbars.dart';
import 'package:sharezone_widgets/widgets.dart';
import 'package:sharezone_widgets/wrapper.dart';

import 'open_submission_file.dart';

class HomeworkUserCreateSubmissionPage extends StatefulWidget {
  static const tag = 'homework-user-create-submission-page';

  final String homeworkId;

  const HomeworkUserCreateSubmissionPage({Key key, @required this.homeworkId})
      : super(key: key);

  @override
  _HomeworkUserCreateSubmissionPageState createState() =>
      _HomeworkUserCreateSubmissionPageState();
}

class _HomeworkUserCreateSubmissionPageState
    extends State<HomeworkUserCreateSubmissionPage> {
  HomeworkUserCreateSubmissionsBloc bloc;

  @override
  void initState() {
    bloc = BlocProvider.of<HomeworkUserCreateSubmissionsBlocFactory>(context)
        .create(widget.homeworkId);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        final abgegeben =
            await bloc.pageView.map((pageView) => pageView.submitted).first;
        final dateienVorhanden = await bloc.pageView
            .map((pageView) => pageView.files.isNotEmpty)
            .first;
        final dateienAmHochladen = await bloc.pageView
            .map((pageView) => pageView.files
                .where((file) => file.status == FileViewStatus.uploading)
                .isNotEmpty)
            .first;

        if (dateienAmHochladen) {
          await warnUserAboutUploadingFilesForm(context);
        }
        if (dateienVorhanden && !abgegeben) {
          return await warnUserAboutNotSubmittedForm(context);
        }
        return true;
      },
      child: BlocProvider(
        bloc: bloc,
        child: StreamBuilder<SubmissionPageView>(
            stream: bloc.pageView,
            builder: (context, snapshot) {
              final view = snapshot.data;
              final showSubmitButton =
                  (view?.submittable ?? false) && !view.submitted;
              final afterDeadline = view?.deadlineState != null &&
                  view.deadlineState == SubmissionDeadlineState.afterDeadline;
              final hasSubmitted = snapshot?.data?.submitted ?? false;

              return Scaffold(
                appBar: AppBar(
                  leading: CloseIconButton(),
                  actions: <Widget>[
                    /// Im Web wird der Button nicht immer ausgefaded, auch wenn
                    /// [showSubmitButton] false ist und onPressed null sein müsste.
                    /// Deswegen der Workaround für Web.
                    if (!kIsWeb || kIsWeb && showSubmitButton)
                      TextButton(
                        child: Text('Abgeben'.toUpperCase()),
                        onPressed: showSubmitButton
                            ? () async {
                                final res = await showLeftRightAdaptiveDialog<
                                    SubmitDialogOption>(
                                  context: context,
                                  title: 'Wirklich Abgeben?',
                                  content: Text(
                                    'Nach der Abgabe kannst du keine Datei mehr löschen. Du kannst aber noch neue Dateien hinzufügen und alte Dateien umbenennen.',
                                  ),
                                  right: AdaptiveDialogAction(
                                    title: 'Abgeben',
                                    popResult: SubmitDialogOption.submit,
                                  ),
                                  left: AdaptiveDialogAction(
                                    title: 'Abbrechen',
                                    popResult: SubmitDialogOption.cancel,
                                  ),
                                );
                                switch (res) {
                                  case SubmitDialogOption.submit:
                                    bloc.veroeffentlicheAbgabe();
                                    break;
                                  case SubmitDialogOption.cancel:
                                    break;
                                }
                              }
                            : null,
                      ),
                  ],
                  centerTitle: true,
                ),
                body: SingleChildScrollView(
                  padding: const EdgeInsets.all(12),
                  child: MaxWidthConstraintBox(
                    child: SafeArea(
                        child: view == null
                            ? Container()
                            : Column(
                                children: <Widget>[
                                  /// Falls submitted & editierbar
                                  if (view != null && view.submitted)
                                    _SubmissionReceivedInfo(),
                                  if (afterDeadline && !hasSubmitted)
                                    _AfterDeadlineCanStillBeSubmitted(),
                                  _FileList(),
                                ],
                              )),
                  ),
                ),
                floatingActionButton:
                    view != null && !view.submitted ? _AddFileFab() : null,
                floatingActionButtonLocation:
                    FloatingActionButtonLocation.centerFloat,
              );
            }),
      ),
    );
  }
}

enum SubmitDialogOption { cancel, submit }

class _SubmissionReceivedInfo extends StatelessWidget {
  const _SubmissionReceivedInfo({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnnouncementCard(
        color: Colors.lightGreen, title: 'Abgabe erfolgreich abgegeben!');
  }
}

class _FileList extends StatelessWidget {
  const _FileList({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<HomeworkUserCreateSubmissionsBloc>(context);
    return StreamBuilder<SubmissionPageView>(
      stream: bloc.pageView,
      builder: (context, snapshot) {
        final pageView = snapshot?.data;
        final files = snapshot.data?.files ?? [];

        if (files.isEmpty)
          return _EmptyState(submissionDeadlineState: pageView?.deadlineState);

        return AnimationLimiter(
          child: Column(
            children: AnimationConfiguration.toStaggeredList(
              duration: const Duration(milliseconds: 350),
              childAnimationBuilder: (widget) => SlideAnimation(
                verticalOffset: 25,
                child: FadeInAnimation(child: widget),
              ),
              children: <Widget>[
                for (final file in files)
                  _FileCard(
                    view: file,
                    submitted: pageView?.submitted ?? false,
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _AfterDeadlineCanStillBeSubmitted extends StatelessWidget {
  const _AfterDeadlineCanStillBeSubmitted({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnnouncementCard(
      title: 'Abgabefrist verpasst? Du kannst trotzdem abgeben!',
      content: Text(
          'Du kannst jetzt trotzdem noch abgeben, aber die Lehrkraft muss entscheiden wie sie damit umgeht ;)'),
    );
  }
}

class _AddFileFab extends StatelessWidget {
  const _AddFileFab({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.extended(
      onPressed: () => _showFilePickerDialog(context),
      label: const Text('Datei hinzufügen', style: TextStyle(fontSize: 16)),
      backgroundColor: Colors.blue,
      tooltip: 'Datei hinzufügen',
    );
  }

  Future<void> _showFilePickerDialog(BuildContext context) async {
    final bloc = BlocProvider.of<HomeworkUserCreateSubmissionsBloc>(context);
    if (PlatformCheck.isDesktopOrWeb) {
      final pickedFiles = await FilePicker().pickMultiFile();
      if (pickedFiles != null && pickedFiles.isNotEmpty) {
        final localFiles = pickedFiles.toList();
        bloc.addSubmissionFiles(localFiles);
      }
    } else {
      final error = await showDialog<String>(
        context: context,
        builder: (_) =>
            AddLocalFileDialog(addLocalFileToBlocMethod: (localFiles) {
          try {
            bloc.addSubmissionFiles(localFiles);
          } on FileConversionException catch (e) {
            String msg;
            if (e.files.length == 1) {
              msg =
                  'Die gewählte Datei "${e.files.first.getName()}" scheint invalide zu sein.';
            } else {
              final names = e.files.map((e) => e.getName()).join(', ');
              msg = 'Die gewählte Datein "$names" scheinen invalide zu sein.';
            }
            showLeftRightAdaptiveDialog(
              context: context,
              title: 'Fehler',
              content: Text(
                  '$msg.\nBitte kontaktiere den Support unter support@sharezone.net!'),
              left: AdaptiveDialogAction(
                isDefaultAction: true,
                onPressed: () => Navigator.pop(context),
                title: 'Ok',
              ),
            );
          }
        }),
      );

      if (error != null) {
        showSnackSec(
          text: error,
          context: context,
        );
      }
    }
  }
}

class _FileCard extends StatelessWidget {
  const _FileCard({
    @required this.view,
    @required this.submitted,
    Key key,
  }) : super(key: key);

  final FileView view;
  final bool submitted;

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 350),
      child: Padding(
        key: ValueKey(view.id),
        padding: const EdgeInsets.only(bottom: 10),
        child: CustomCard(
          onTap: view.downloadUrl.isPresent
              ? () => openCreateSubmissionFile(context, view)
              : null,
          child: Column(
            children: <Widget>[
              Opacity(
                opacity: view.status == FileViewStatus.uploading ? 0.6 : 1.0,
                child: ListTile(
                  leading: view.status == FileViewStatus.failed
                      ? Icon(Icons.close)
                      : FileIcon(fileFormat: view.fileFormat),
                  title: Text(view.name),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      AnimatedSwitcher(
                        duration: Duration(milliseconds: 250),
                        child: view.status == FileViewStatus.succesfullyUploaded
                            ? _RenameFile(view: view)
                            : Container(),
                      ),
                      AnimatedSwitcher(
                        duration: Duration(milliseconds: 250),
                        child: view.status != FileViewStatus.uploading &&
                                !submitted
                            ? _DeleteIcon(view: view)
                            : Container(),
                      ),
                    ],
                  ),
                ),
              ),
              if (view.status == FileViewStatus.uploading)
                LinearProgressIndicator(
                  backgroundColor: Colors.grey[400],
                  valueColor: const AlwaysStoppedAnimation(Colors.lightBlue),
                  value: view.uploadProgess.orElse(0),
                ),
              if (view.status == FileViewStatus.failed)
                LinearProgressIndicator(
                  valueColor: const AlwaysStoppedAnimation(Colors.red),
                  value: 1,
                ),
              if (view.status == FileViewStatus.succesfullyUploaded)
                LinearProgressIndicator(
                  valueColor: const AlwaysStoppedAnimation(Colors.green),
                  value: 1,
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _RenameFile extends StatelessWidget {
  const _RenameFile({
    Key key,
    @required this.view,
  }) : super(key: key);

  final FileView view;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.edit),
      onPressed: () async {
        final bloc =
            BlocProvider.of<HomeworkUserCreateSubmissionsBloc>(context);
        final invalidNames = await bloc.submissionFileBasenames.first;

        showDialog(
          context: context,
          builder: (context) => _RenameDialog(
            view: view,
            invalidNames: invalidNames,
            bloc: bloc,
          ),
        );
      },
      tooltip: 'Umbenennen',
    );
  }
}

class _RenameDialog extends StatefulWidget {
  const _RenameDialog({
    Key key,
    @required this.view,
    @required this.invalidNames,
    @required this.bloc,
  }) : super(key: key);

  final FileView view;
  final List<String> invalidNames;
  final HomeworkUserCreateSubmissionsBloc bloc;

  @override
  __RenameDialogState createState() => __RenameDialogState();
}

class __RenameDialogState extends State<_RenameDialog> {
  _RenameError error;
  String newName;

  @override
  void initState() {
    // Verhindert, dass beim drücken des Umbenennen Buttons ohne eine Änderung
    // null als Name übergeben wird.
    newName = widget.view.basename;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Datei umbennen'),
      content: PrefilledTextField(
        prefilledText: widget.view.basename,
        decoration: InputDecoration(
          errorText: getErrorText(),
          border: const OutlineInputBorder(),
        ),
        autofocus: true,
        onChanged: (text) {
          if (isValid(text)) {
            setState(() {
              newName = text;
            });
          } else {
            setState(() {});
          }
        },
      ),
      actions: <Widget>[
        CancelButton(),
        TextButton(
          onPressed: error == null
              ? () {
                  widget.bloc.renameFile(widget.view.id, newName);
                  Navigator.pop(context);
                }
              : null,
          style: TextButton.styleFrom(
            foregroundColor: Theme.of(context).primaryColor,
          ),
          child: const Text("UMBENENNEN"),
        )
      ],
    );
  }

  /// Beachte: Zur Überprüfung des Namens nicht [newName] verwenden,
  /// sondern den neuen Wert als Parameter übergeben.
  bool isValid(String text) {
    if (isEmptyOrNull(text)) {
      error = _RenameError.isEmpty;
    } else if (widget.invalidNames.contains(text)) {
      error = _RenameError.alreadyExits;
    } else if (text.length >= 128) {
      error = _RenameError.tooLong;
    } else {
      error = null;
      return true;
    }
    return false;
  }

  String getErrorText() {
    switch (error) {
      case _RenameError.tooLong:
        return 'Der Name ist zu lang!';
      case _RenameError.alreadyExits:
        return 'Dieser Dateiname existiert bereits!';
      case _RenameError.isEmpty:
        return 'Der Name darf nicht leer sein!';
    }
    return null;
  }
}

enum _RenameError { tooLong, alreadyExits, isEmpty }

class _DeleteIcon extends StatelessWidget {
  const _DeleteIcon({Key key, @required this.view}) : super(key: key);

  final FileView view;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.delete),
      onPressed: () async {
        final confirmed = await showLeftRightAdaptiveDialog<bool>(
          context: context,
          title: 'Datei entfernen',
          content:
              Text('Möchtest du die Datei "${view.name}" wirklich entfernen?'),
          right: AdaptiveDialogAction.delete,
          defaultValue: false,
        );

        if (confirmed) {
          final bloc =
              BlocProvider.of<HomeworkUserCreateSubmissionsBloc>(context);
          bloc.removeSubmissionFile(view.id);
        }
      },
      tooltip: 'Datei entfernen',
    );
  }
}

class _EmptyState extends StatelessWidget {
  final SubmissionDeadlineState submissionDeadlineState;

  const _EmptyState({
    Key key,
    @required this.submissionDeadlineState,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _NoFilesUploaded();
  }
}

class _NoFilesUploaded extends StatelessWidget {
  const _NoFilesUploaded({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.16),
      child: PlaceholderModel(
        animateSVG: false,
        riveAnimationName: 'Writing',
        rivePath: 'assets/flare/submissions_empty_state.flr',
        title:
            'Lade jetzt Dateien hoch, die du für die Hausaufgabe abgeben willst!',
        iconSize: Size(400, 200),
      ),
    );
  }
}

Future<bool> warnUserAboutUploadingFilesForm(BuildContext context) async {
  await closeKeyboardAndWait(context);
  return showLeftRightAdaptiveDialog<bool>(
        context: context,
        title: 'Dateien am hochladen!',
        content: Text(
          'Wenn du den Dialog verlässt wird der Hochladevorgang für noch nicht hochgeladene Dateien abgebrochen.',
        ),
        defaultValue: false,
        right: AdaptiveDialogAction(
          title: "Verlassen",
          isDefaultAction: true,
          popResult: true,
        ),
      ) ??
      Future.value(false);
}

Future<bool> warnUserAboutNotSubmittedForm(BuildContext context) async {
  await closeKeyboardAndWait(context);
  return showLeftRightAdaptiveDialog<bool>(
        context: context,
        title: 'Abgabe nicht abgegeben!',
        content: Text(
          'Dein Lehrer wird deine Abgabe nicht sehen können, bis du diese abgibst.\n\n'
          'Deine bisher hochgeladenen Dateien bleiben trotzdem für dich gespeichert.',
        ),
        defaultValue: false,
        right: AdaptiveDialogAction(
          title: "Verlassen",
          isDefaultAction: true,
          popResult: true,
        ),
      ) ??
      Future.value(false);
}
