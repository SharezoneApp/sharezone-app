// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:bloc_provider/bloc_provider.dart';
import 'package:common_domain_models/common_domain_models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:hausaufgabenheft_logik/hausaufgabenheft_logik.dart';
import 'package:key_value_store/key_value_store.dart';
import 'package:provider/provider.dart';
import 'package:sharezone/comments/comments_gateway.dart';
import 'package:sharezone/comments/widgets/comment_section_builder.dart';
import 'package:sharezone/filesharing/dialog/attachment_list.dart';
import 'package:sharezone/homework/homework_details/homework_details_view_factory.dart';
import 'package:sharezone/homework/homework_dialog/homework_dialog.dart';
import 'package:sharezone/homework/homework_page.dart';
import 'package:sharezone/homework/shared/delete_homework.dart';
import 'package:sharezone/homework/teacher_and_parent/homework_done_by_users_list/homework_completion_user_list_page.dart';
import 'package:sharezone/main/application_bloc.dart';
import 'package:sharezone/navigation/logic/navigation_bloc.dart';
import 'package:sharezone/navigation/models/navigation_item.dart';
import 'package:sharezone/homework/shared/shared.dart';
import 'package:sharezone/report/report_icon.dart';
import 'package:sharezone/report/report_item.dart';
import 'package:sharezone/submissions/homework_list_submissions_page.dart';
import 'package:sharezone/widgets/matching_type_of_user_builder.dart';
import 'package:sharezone/widgets/material/bottom_action_bar.dart';
import 'package:sharezone_localizations/sharezone_localizations.dart';
import 'package:sharezone_widgets/sharezone_widgets.dart';
import 'package:url_launcher_extended/url_launcher_extended.dart';
import 'package:user/user.dart';

import '../../submissions/homework_create_submission_page.dart';
import 'homework_details_bloc.dart';
import 'homework_details_view.dart';

void showTeacherMustBeAdminDialogToViewSubmissions(BuildContext context) {
  showLeftRightAdaptiveDialog(
    context: context,
    left: AdaptiveDialogAction.ok(context),
    title: context.l10n.homeworkDetailsNoPermissionTitle,
    content: Text(
      context.l10n.homeworkDetailsViewSubmissionsNoPermissionContent,
    ),
  );
}

void showTeacherMustBeAdminDialogToViewCompletionList(BuildContext context) {
  showLeftRightAdaptiveDialog(
    context: context,
    left: AdaptiveDialogAction.ok(context),
    title: context.l10n.homeworkDetailsNoPermissionTitle,
    content: Text(
      context.l10n.homeworkDetailsViewCompletionNoPermissionContent,
    ),
  );
}

Future<bool?> confirmToMarkHomeworkAsDoneWithoutSubmission(
  BuildContext context,
) {
  return showLeftRightAdaptiveDialog<bool>(
    context: context,
    title: context.l10n.homeworkDetailsNoSubmissionTitle,
    content: Text(context.l10n.homeworkDetailsNoSubmissionContent),
    defaultValue: false,
    right: AdaptiveDialogAction<bool>(
      title: context.l10n.homeworkDetailsMarkDoneAction,
      popResult: true,
      textColor: Colors.orange,
    ),
  );
}

class HomeworkDetails extends StatelessWidget {
  static const tag = "homework-details-page";

  /// Loads the [HomeworkDetails] with [initialHomework] being prefilled into
  /// the page (no loading animation is shown).
  HomeworkDetails(HomeworkDetailsView this.initialHomework, {super.key})
    : id = initialHomework.id;

  /// Loads the [HomeworkDetails] for the homework with the given [id].
  /// This means that there may be a loading animation shown until all
  /// information has been loaded.
  const HomeworkDetails.loadId(this.id, {super.key}) : initialHomework = null;

  final String id;
  final HomeworkDetailsView? initialHomework;

  @override
  Widget build(BuildContext context) {
    final gateway = BlocProvider.of<SharezoneContext>(context).api.homework;
    final detailsViewFactory = BlocProvider.of<HomeworkDetailsViewFactory>(
      context,
    );
    final bloc = HomeworkDetailsBloc(gateway, id, detailsViewFactory);

    return BlocProvider(
      bloc: bloc,
      child: StreamBuilder<HomeworkDetailsView>(
        initialData: initialHomework,
        stream: bloc.homework,
        builder: (context, snapshot) {
          final view = snapshot.data ?? initialHomework;

          /// This is neccessary as the homeworkItem can be null at the beginning.
          if (view == null) return const CircularProgressIndicator();

          return SelectionArea(
            child: Scaffold(
              body: CustomScrollView(
                slivers: <Widget>[
                  HomeworkTitleAppBar(view: view),
                  SliverToBoxAdapter(child: _HomeworkDetailsBody(view: view)),
                ],
              ),
              bottomNavigationBar: _BottomHomeworkIsDoneActionButton(
                view: view,
              ),
            ),
          );
        },
      ),
    );
  }
}

class _HomeworkDetailsBody extends StatelessWidget {
  const _HomeworkDetailsBody({required this.view});

  final HomeworkDetailsView view;

  @override
  Widget build(BuildContext context) {
    return MaxWidthConstraintBox(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _CourseTile(courseName: view.courseName),
          _TodoUntil(
            todoUntil: view.todoUntil,
            withSubmissions: view.withSubmissions,
          ),
          _HomeworkDescription(description: view.description),
          _HomeworkPrivateTile(isPrivate: view.isPrivate),
          _HomeworkAuthorTile(authorName: view.authorName),
          _UserSubmissionsTile(view: view),
          _DoneByTile(view: view),
          _AttachmentList(view: view),
          if (view.homework.id.isNotEmpty)
            CommentSectionBuilder(
              itemId: view.homework.id,
              commentOnType: CommentOnType.homework,
              courseID: view.homework.courseID,
            ),
        ],
      ),
    );
  }
}

class HomeworkTitleAppBar extends StatelessWidget {
  final HomeworkDetailsView? view;

  const HomeworkTitleAppBar({super.key, this.view});

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(brightness: Brightness.dark),
      child: SliverAppBar(
        leading: const CloseIconButton(color: Colors.white),
        backgroundColor:
            Theme.of(context).isDarkTheme
                ? Theme.of(context).appBarTheme.backgroundColor
                : Theme.of(context).primaryColor,
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 1,
        actions: <Widget>[
          ReportIcon(item: ReportItemReference.homework(view!.id)),
          if (view!.hasPermission) ...[
            _EditIcon(homework: view!.homework),
            _DeleteIcon(homework: view!.homework),
          ],
        ],
        expandedHeight: 155,
        flexibleSpace: FlexibleSpaceBar(
          background: HomeworkDetailsHomeworkTitle(title: view!.title),
        ),
        pinned: true,
        floating: true,
      ),
    );
  }
}

class _DoneByTile extends StatelessWidget {
  const _DoneByTile({this.view});

  final HomeworkDetailsView? view;

  @override
  Widget build(BuildContext context) {
    if (view!.withSubmissions) return Container();
    if (view!.typeOfUser != TypeOfUser.teacher) return Container();
    return ListTile(
      leading: const Icon(Icons.check),
      title: Text(
        context.l10n.homeworkDetailsDoneByStudentsCount(
          view!.nrOfCompletedStudents,
        ),
      ),
      onTap: () {
        if (view!.hasPermissionsToViewDoneByList) {
          _openDoneByList(context);
        } else {
          showTeacherMustBeAdminDialogToViewCompletionList(context);
        }
      },
      trailing: const Icon(Icons.chevron_right),
    );
  }

  void _openDoneByList(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (context) => HomeworkCompletionUserListPage(
              homeworkId: HomeworkId(view!.id),
            ),
        settings: const RouteSettings(name: HomeworkCompletionUserListPage.tag),
      ),
    );
  }
}

class _UserSubmissionsTile extends StatelessWidget {
  const _UserSubmissionsTile({required this.view});

  final HomeworkDetailsView view;

  @override
  Widget build(BuildContext context) {
    if (!view.withSubmissions) return Container();
    if (_isParent) return _UserSubmissionsParentsTile();
    if (_isTeacher) return _UserSubmissionsTeacherTile(view: view);
    return _UserSubmissionsStudentTile(view: view);
  }

  bool get _isParent => view.typeOfUser == TypeOfUser.parent;

  bool get _isTeacher => view.typeOfUser == TypeOfUser.teacher;
}

class _UserSubmissionsTeacherTile extends StatelessWidget {
  const _UserSubmissionsTeacherTile({required this.view});

  final HomeworkDetailsView view;

  void _openSharezonePlusPage(BuildContext context) {
    // Popping the homework details page
    Navigator.pop(context);

    // Open Sharezone Plus page
    BlocProvider.of<NavigationBloc>(
      context,
    ).navigateTo(NavigationItem.sharezonePlus);
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.folder_shared),
      title: Text(
        context.l10n.homeworkDetailsSubmissionsCount(view.nrOfSubmissions),
      ),
      onTap: () {
        if (view.hasPermissionToViewSubmissions) {
          if (view.hasTeacherSubmissionsUnlocked) {
            _openSubmissionsList(context);
          } else {
            _openSharezonePlusPage(context);
          }
        } else {
          showTeacherMustBeAdminDialogToViewSubmissions(context);
        }
      },
      trailing: const Icon(Icons.chevron_right),
    );
  }

  void _openSubmissionsList(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => HomeworkUserSubmissionsPage(homeworkId: view.id),
      ),
    );
  }
}

class _UserSubmissionsStudentTile extends StatelessWidget {
  const _UserSubmissionsStudentTile({required this.view});

  final HomeworkDetailsView view;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.folder_shared),
      title: Text(getText(context)),
      onTap: () => _openCreateSubmissionPage(context),
      trailing: const Icon(Icons.chevron_right),
    );
  }

  String getText(BuildContext context) {
    if (view.hasSubmitted) return context.l10n.homeworkDetailsMySubmission;
    return context.l10n.homeworkDetailsNoSubmissionYet;
  }

  void _openCreateSubmissionPage(BuildContext context) {
    Navigator.push(
      context,
      IgnoreWillPopScopeWhenIosSwipeBackRoute(
        builder: (_) => HomeworkUserCreateSubmissionPage(homeworkId: view.id),
      ),
    );
  }
}

class _UserSubmissionsParentsTile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return ListTile(
      leading: const Icon(Icons.folder_shared),
      title: Text(l10n.homeworkDetailsParentsCannotSubmit),
      onTap: () async {
        final confirmed =
            (await showLeftRightAdaptiveDialog<bool>(
              context: context,
              defaultValue: false,
              title: l10n.homeworkDetailsChangeAccountTypeTitle,
              content: Text(l10n.homeworkDetailsChangeAccountTypeContent),
              right: AdaptiveDialogAction(
                isDefaultAction: true,
                popResult: true,
                title: l10n.commonActionsContactSupport,
              ),
            ))!;

        if (confirmed && context.mounted) {
          final uid = BlocProvider.of<SharezoneContext>(context).api.uID;
          UrlLauncherExtended().tryLaunchMailOrThrow(
            "support@sharezone.net",
            subject: l10n.homeworkDetailsChangeAccountTypeEmailSubject(uid),
            body: l10n.homeworkDetailsChangeAccountTypeEmailBody,
          );
        }
      },
    );
  }
}

class _DeleteIcon extends StatelessWidget {
  const _DeleteIcon({required this.homework});

  final HomeworkDto homework;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.delete),
      tooltip: context.l10n.commonActionsDelete,
      onPressed:
          () => deleteHomeworkDialogsEntry(context, homework, popTwice: true),
    );
  }
}

class _EditIcon extends StatelessWidget {
  const _EditIcon({this.homework});

  final HomeworkDto? homework;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.edit),
      tooltip: context.l10n.commonActionsEdit,
      onPressed: () async {
        // See comment below
        // ignore: unused_local_variable
        final successful = await Navigator.push<bool>(
          context,
          MaterialPageRoute(
            builder:
                (context) => HomeworkDialog(
                  id: homework?.id != null ? HomeworkId(homework!.id) : null,
                ),
            settings: const RouteSettings(name: HomeworkDialog.tag),
          ),
        );

        // We always show this SnackBar because if we don't the "sending
        // data..." SnackBar would not disappear.
        //
        // Additionally we can't even really know right here if everything went
        // okay, because we have to call Firestore synchronously because of some
        // weird behavior of the library.
        // I think it was because when calling Firestore with "await" while
        // being offline the call won't complete until we're online again.
        // Unfortunately this behavior won't be fixed by Firestore it seems so
        // we don't use await when we don't have to.
        // This means if the Firestore server doesn't accept the change the
        // exception will only be thrown later after this code here has already
        // run.
        //
        // This really isn't the best solution but it's more of a quick fix to
        // get at least the "sending data..." SnackBar to disappear.
        //
        // if (successful) {
        if (context.mounted) {
          await showUserConfirmationOfHomeworkArrival(context: context);
        }
        // }
      },
    );
  }
}

class _BottomHomeworkIsDoneActionButton extends StatelessWidget {
  const _BottomHomeworkIsDoneActionButton({required this.view});

  final HomeworkDetailsView view;

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<HomeworkDetailsBloc>(context);
    return MatchingTypeOfUserBuilder(
      expectedTypeOfUser: TypeOfUser.student,
      // Hier wird ein leeres Text-Widget anstatt einem Container verwendet,
      // da bei einem Container einfach nur eine weiße Seite angezeigt
      // wird und der restliche Content nicht geladen wird.
      notMatchingWidget: const Text(""),
      matchesTypeOfUserWidget: BottomActionBar(
        onTap: () async {
          if (view.isDone) {
            bloc.changeIsHomeworkDoneTo(false);
            Navigator.pop(context);
          } else {
            if (view.withSubmissions) {
              final result =
                  (await confirmToMarkHomeworkAsDoneWithoutSubmission(
                    context,
                  ))!;
              if (result && context.mounted) {
                bloc.changeIsHomeworkDoneTo(true);
                Navigator.pop(context);
              }
            } else {
              bloc.changeIsHomeworkDoneTo(true);
              Navigator.pop(context);
            }
          }
        },
        title:
            view.isDone
                ? context.l10n.homeworkDetailsMarkAsUndone
                : context.l10n.homeworkDetailsMarkAsDone,
      ),
    );
  }
}

class _HomeworkAuthorTile extends StatelessWidget {
  const _HomeworkAuthorTile({this.authorName});

  final String? authorName;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.person),
      title: Text(context.l10n.homeworkDetailsCreatedBy),
      subtitle: Text(authorName ?? "-"),
    );
  }
}

class _HomeworkPrivateTile extends StatelessWidget {
  const _HomeworkPrivateTile({this.isPrivate});

  final bool? isPrivate;

  @override
  Widget build(BuildContext context) {
    return isPrivate != null && isPrivate!
        ? ListTile(
          leading: const Icon(Icons.security),
          title: Text(context.l10n.homeworkDetailsPrivateTitle),
          subtitle: Text(context.l10n.homeworkDetailsPrivateSubtitle),
        )
        : Container();
  }
}

class _HomeworkDescription extends StatelessWidget {
  const _HomeworkDescription({this.description});

  final String? description;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return description != null && description!.isNotEmpty
        ? ListTile(
          leading: const Icon(Icons.subject),
          title: Text(context.l10n.homeworkDetailsAdditionalInfo),
          subtitle: MarkdownBody(
            data: description!,
            selectable: true,
            softLineBreak: true,
            styleSheet: MarkdownStyleSheet.fromTheme(
              theme.copyWith(
                textTheme: theme.textTheme.copyWith(
                  bodyMedium: TextStyle(
                    color:
                        Theme.of(context).isDarkTheme
                            ? Colors.grey[400]
                            : Colors.grey[600],
                    fontFamily: rubik,
                    fontSize: 14,
                  ),
                ),
              ),
            ).copyWith(a: linkStyle(context, 14)),
            onTapLink:
                (text, href, _) => launchMarkdownLinkWithWarning(
                  href: href ?? text,
                  text: text,
                  keyValueStore: context.read<KeyValueStore>(),
                  context: context,
                ),
          ),
        )
        : Container();
  }
}

class _TodoUntil extends StatelessWidget {
  const _TodoUntil({required this.todoUntil, required this.withSubmissions});

  final DateTime todoUntil;
  final bool withSubmissions;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.today),
      title: Text(formatHomeworkTodoDate(context, todoUntil, withSubmissions)),
    );
  }
}

class _CourseTile extends StatelessWidget {
  const _CourseTile({this.courseName});

  final String? courseName;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.book),
      title: Text(context.l10n.homeworkDetailsCourseTitle),
      subtitle: Text(courseName ?? ''),
    );
  }
}

class _AttachmentList extends StatelessWidget {
  const _AttachmentList({required this.view});

  final HomeworkDetailsView view;

  @override
  Widget build(BuildContext context) {
    if (!view.hasAttachments) return Container();
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          DividerWithText(
            text: context.l10n.homeworkDetailsAttachmentsCount(
              view.attachmentIDs.length,
            ),
            fontSize: 16,
          ),
          const SizedBox(height: 4),
          AttachmentStreamList(
            cloudFileStream: view.attachmentStream,
            courseID: view.courseID,
            initialAttachmentIDs: view.attachmentIDs,
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}

class HomeworkDetailsHomeworkTitle extends StatelessWidget {
  const HomeworkDetailsHomeworkTitle({super.key, this.title});

  final String? title;

  @override
  Widget build(BuildContext context) {
    return MaxWidthConstraintBox(
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(top: 50),
          child: Align(
            alignment: Alignment.bottomLeft,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 1),
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.only(
                    left: 16,
                    bottom: 11,
                    right: 24,
                  ),
                  child: Text(
                    title!,
                    style: Theme.of(
                      context,
                    ).textTheme.headlineSmall!.copyWith(color: Colors.white),
                    textAlign: TextAlign.left,
                    // overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
