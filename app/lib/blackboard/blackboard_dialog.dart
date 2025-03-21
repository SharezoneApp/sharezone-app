// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'dart:async';

import 'package:bloc_provider/bloc_provider.dart';
import 'package:build_context/build_context.dart';
import 'package:flutter/material.dart';
import 'package:group_domain_models/group_domain_models.dart';
import 'package:sharezone/blackboard/blackboard_card.dart';
import 'package:sharezone/blackboard/blackboard_item.dart';
import 'package:sharezone/blackboard/blackboard_page.dart';
import 'package:sharezone/blackboard/blackboard_picture.dart';
import 'package:sharezone/blackboard/blocs/blackboard_dialog_bloc.dart';
import 'package:sharezone/filesharing/dialog/attach_file.dart';
import 'package:sharezone/filesharing/dialog/course_tile.dart';
import 'package:sharezone/main/application_bloc.dart';
import 'package:sharezone/markdown/markdown_analytics.dart';
import 'package:sharezone/widgets/material/save_button.dart';
import 'package:sharezone_common/api_errors.dart';
import 'package:sharezone_widgets/sharezone_widgets.dart';

import 'details/blackboard_details.dart';

class BlackboardDialog extends StatefulWidget {
  const BlackboardDialog({
    super.key,
    this.blackboardItem,
    this.course,
    this.popTwice = true,
  });

  static const tag = "blackboard-dialog-page";

  /// BlackboardItem, which will be edited; When you create
  /// a new blackboardItem, [blackboardItem] is null
  final BlackboardItem? blackboardItem;
  final Course? course;
  final bool popTwice;

  @override
  State createState() => _BlackboardDialogState();
}

class _BlackboardDialogState extends State<BlackboardDialog> {
  late BlackboardDialogBloc bloc;

  @override
  void initState() {
    final api = BlocProvider.of<SharezoneContext>(context).api;
    final markdownAnalytics = BlocProvider.of<MarkdownAnalytics>(context);
    bloc = BlackboardDialogBloc(
      BlackboardDialogApi(api),
      markdownAnalytics,
      blackboardItem: widget.blackboardItem,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      bloc: bloc,
      child: _BlackboardDialog(
        oldBlackboardItem: widget.blackboardItem,
        course: widget.course,
        popTwice: widget.popTwice,
        bloc: bloc,
      ),
    );
  }
}

class _BlackboardDialog extends StatefulWidget {
  final BlackboardItem? oldBlackboardItem;
  final Course? course;
  final BlackboardDialogBloc bloc;
  final bool popTwice;

  const _BlackboardDialog({
    this.oldBlackboardItem,
    this.course,
    required this.bloc,
    required this.popTwice,
  });

  @override
  State createState() => __BlackboardDialogState();
}

class __BlackboardDialogState extends State<_BlackboardDialog> {
  final titleNode = FocusNode();
  bool editMode = false;

  @override
  void initState() {
    if (widget.oldBlackboardItem != null) editMode = true;
    delayKeyboard(context: context, focusNode: titleNode);
    super.initState();
  }

  Future<void> leaveDialog() async {
    if (widget.bloc.hasInputChanged()) {
      final leaveDialog = await warnUserAboutLeavingForm(context);
      if (leaveDialog && mounted) {
        Navigator.pop(context);
      }
    } else {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope<Object?>(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) async {
        if (didPop) return;

        final hasInputChanged = widget.bloc.hasInputChanged();
        final navigator = Navigator.of(context);
        if (!hasInputChanged) {
          navigator.pop();
          return;
        }

        final shouldPop = await warnUserAboutLeavingForm(context);
        if (shouldPop) {
          navigator.pop();
          return;
        }
      },
      child: Scaffold(
        backgroundColor: Theme.of(context).isDarkTheme ? null : Colors.white,
        body: Column(
          children: <Widget>[
            _AppBar(
              editMode: editMode,
              focusNodeTitle: titleNode,
              oldBlackboardItem: widget.oldBlackboardItem,
              onCloseTap: () => leaveDialog(),
              popTwice: widget.popTwice,
            ),
            Expanded(
              child: SingleChildScrollView(
                child: MaxWidthConstraintBox(
                  child: SafeArea(
                    top: false,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        const SizedBox(height: 8),
                        _CourseTile(editMode: editMode),
                        getDividerOnMobile(context),
                        _PictureTile(),
                        getDividerOnMobile(context),
                        _AttachFile(),
                        getDividerOnMobile(context),
                        _TextField(
                          initialText: widget.oldBlackboardItem?.text ?? "",
                        ),
                        getDividerOnMobile(context),
                        _SendNotification(editMode: editMode),
                        getDividerOnMobile(context),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget getDividerOnMobile(BuildContext context) {
    if (context.isDesktopModus) return Container();
    return const Divider(height: 0);
  }
}

class _SaveButton extends StatelessWidget {
  const _SaveButton({
    this.oldBlackboardItem,
    required this.popTwice,
    required this.editMode,
  });

  final BlackboardItem? oldBlackboardItem;
  final bool popTwice;
  final bool editMode;

  Future<void> onPressed(
    BuildContext context,
    BlackboardDialogBloc bloc,
  ) async {
    final localFiles = await bloc.localFiles.first;
    final hasAttachments = localFiles.isNotEmpty;
    try {
      if (bloc.isValid()) {
        if (context.mounted) {
          sendDataToFrankfurtSnackBar(context);
        }

        if (editMode) {
          if (hasAttachments) {
            await bloc.submit(oldBlackboardItem: oldBlackboardItem);
          } else {
            bloc.submit(oldBlackboardItem: oldBlackboardItem);
          }

          if (context.mounted) {
            logBlackboardEditEvent(context);
            hideSendDataToFrankfurtSnackBar(context);
            if (popTwice) Navigator.pop(context);
            Navigator.pop(context, BlackboardPopOption.edited);
          }
        } else {
          if (hasAttachments) {
            await bloc.submit();
          } else {
            bloc.submit();
          }

          if (context.mounted) {
            logBlackboardAddEvent(context);
            hideSendDataToFrankfurtSnackBar(context);
            Navigator.pop(context, BlackboardPopOption.added);
          }
        }
      }
    } on Exception catch (e, s) {
      if (context.mounted) {
        showSnackSec(
          text: handleErrorMessage(e.toString(), s),
          context: context,
          seconds: 5,
        );
      }
    }
  }

  void hideSendDataToFrankfurtSnackBar(BuildContext context) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
  }

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<BlackboardDialogBloc>(context);
    return SaveButton(
      tooltip: "Eintrag speichern",
      onPressed: () => onPressed(context, bloc),
    );
  }
}

class _AppBar extends StatelessWidget {
  const _AppBar({
    required this.oldBlackboardItem,
    required this.editMode,
    required this.popTwice,
    required this.focusNodeTitle,
    required this.onCloseTap,
  });

  final BlackboardItem? oldBlackboardItem;
  final bool editMode;
  final bool popTwice;
  final VoidCallback onCloseTap;

  final FocusNode focusNodeTitle;

  @override
  Widget build(BuildContext context) {
    return Material(
      color:
          Theme.of(context).isDarkTheme
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
                    oldBlackboardItem: oldBlackboardItem,
                    editMode: editMode,
                    popTwice: popTwice,
                  ),
                ],
              ),
            ),
            MaxWidthConstraintBox(
              child: _TitleField(
                initialTitle: oldBlackboardItem?.title ?? "",
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
  const _TitleField({required this.initialTitle, required this.focusNode});

  final FocusNode focusNode;
  final String? initialTitle;

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<BlackboardDialogBloc>(context);
    return ConstrainedBox(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height / 3,
      ),
      child: SingleChildScrollView(
        child: StreamBuilder<String>(
          stream: bloc.title,
          builder:
              (context, snapshot) => Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                ).add(const EdgeInsets.only(top: 8)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Theme(
                      data: Theme.of(context).copyWith(
                        textSelectionTheme:
                            !context.isDarkThemeEnabled
                                ? const TextSelectionThemeData(
                                  selectionColor: Colors.white24,
                                )
                                : null,
                      ),
                      child: PrefilledTextField(
                        prefilledText: initialTitle,
                        focusNode: focusNode,
                        cursorColor: Colors.white,
                        maxLines: null,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20.0,
                          fontWeight: FontWeight.w400,
                        ),
                        decoration: const InputDecoration(
                          hintText: "Titel eingeben",
                          hintStyle: TextStyle(color: Colors.white),
                          border: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          contentPadding: EdgeInsets.zero,
                          fillColor: Colors.transparent,
                        ),
                        onChanged: (String title) => bloc.changeTitle(title),
                        textCapitalization: TextCapitalization.sentences,
                      ),
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
  const _CourseTile({required this.editMode});

  final bool editMode;

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<BlackboardDialogBloc>(context);
    return CourseTile(
      courseStream: bloc.courseSegment,
      onChanged: bloc.changeCourseSegment,
      editMode: editMode,
    );
  }
}

class _PictureTile extends StatelessWidget {
  Future<void> onTap(BuildContext context, BlackboardDialogBloc bloc) async {
    final path =
        await Navigator.pushNamed(context, BlackboardDialogChoosePicture.tag)
            as String?;
    if (path != null) bloc.changePictureURL(path);
  }

  Future<void> onLongPress(
    BuildContext context,
    BlackboardDialogBloc bloc,
  ) async {
    final delete = await showDialog<bool>(
      context: context,
      builder: (context) => _RemovePictureDialogContent(),
    );
    if (delete != null && delete) {
      bloc.changePictureURL("null");
    }
  }

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<BlackboardDialogBloc>(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: StreamBuilder<String>(
        stream: bloc.pictureURL,
        builder: (context, snapshot) {
          final hasData =
              !(!snapshot.hasData ||
                  snapshot.data == null ||
                  snapshot.data!.isEmpty ||
                  snapshot.data == "null");
          return ListTile(
            onTap: () => onTap(context, bloc),
            leading: const Icon(Icons.photo),
            title: StreamBuilder<String>(
              stream: bloc.pictureURL,
              builder: (context, snapshot) {
                if (!hasData) return const Text("Titelbild auswählen");
                return InkWell(
                  child: Image.asset(
                    snapshot.data!,
                    height: 120,
                    fit: BoxFit.cover,
                  ),
                );
              },
            ),
            trailing: !hasData ? const Icon(Icons.keyboard_arrow_down) : null,
            onLongPress: hasData ? () => onLongPress(context, bloc) : null,
          );
        },
      ),
    );
  }
}

class _TextField extends StatelessWidget {
  const _TextField({required this.initialText});

  final String initialText;

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<BlackboardDialogBloc>(context);
    return Padding(
      padding: const EdgeInsets.only(top: 4),
      child: MarkdownField(
        icon: const Icon(Icons.subject),
        prefilledText: initialText,
        inputDecoration: const InputDecoration(
          hintText: "Nachricht verfassen",
          border: InputBorder.none,
        ),
        onChanged: bloc.changeText,
      ),
    );
  }
}

class _AttachFile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<BlackboardDialogBloc>(context);
    return AttachFile(
      addLocalFileToBlocMethod: (localFile) => bloc.addLocalFile(localFile),
      removeLocalFileFromBlocMethod:
          (localFile) => bloc.removeLocalFile(localFile),
      removeCloudFileFromBlocMethod:
          (cloudFile) => bloc.removeCloudFile(cloudFile),
      localFilesStream: bloc.localFiles,
      cloudFilesStream: bloc.cloudFiles,
    );
  }
}

class _SendNotification extends StatelessWidget {
  const _SendNotification({this.editMode = true});

  final bool editMode;

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<BlackboardDialogBloc>(context);
    return StreamBuilder<bool>(
      stream: bloc.sendNotification,
      builder: (context, snapshot) {
        final sendNotification = snapshot.data ?? !editMode;
        return ListTileWithDescription(
          onTap: () => bloc.changeSendNotification(!sendNotification),
          leading: const Icon(Icons.notifications_active),
          title: Text(
            "Kursmitglieder ${editMode ? "über die Änderungen " : ""}benachrichtigen",
          ),
          trailing: Switch.adaptive(
            onChanged: bloc.changeSendNotification,
            value: sendNotification,
          ),
          description:
              editMode
                  ? null
                  : const Text(
                    "Sende eine Benachrichtigung an deine Kursmitglieder, dass du einen neuen Eintrag erstellt hast.",
                  ),
        );
      },
    );
  }
}

class _RemovePictureDialogContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      contentPadding: const EdgeInsets.all(0),
      children: <Widget>[
        ListTile(
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 4,
          ),
          leading: const Icon(Icons.delete),
          title: const Text("Anhang entfernen"),
          onTap: () => Navigator.pop(context, true),
        ),
      ],
    );
  }
}
