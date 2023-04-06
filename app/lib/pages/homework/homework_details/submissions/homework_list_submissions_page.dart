// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:abgabe_client_lib/abgabe_client_lib.dart';
import 'package:bloc_provider/bloc_provider.dart';
import 'package:files_basics/files_models.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sharezone/filesharing/widgets/cloud_file_icon.dart';
import 'package:sharezone/sharezone_plus/sharezone_plus_feature_guard.dart';
import 'package:sharezone/sharezone_plus/subscription_service/subscription_service.dart';
import 'package:sharezone_widgets/sharezone_widgets.dart';

import 'meme_placeholder.dart';
import 'open_submission_file.dart';

class HomeworkUserSubmissionsPage extends StatefulWidget {
  const HomeworkUserSubmissionsPage({
    @required this.homeworkId,
    Key key,
  }) : super(key: key);

  final String homeworkId;

  @override
  _HomeworkUserSubmissionsPageState createState() =>
      _HomeworkUserSubmissionsPageState();
}

class _HomeworkUserSubmissionsPageState
    extends State<HomeworkUserSubmissionsPage> {
  ViewSubmissionsPageBloc bloc;

  @override
  void initState() {
    final blocFactory =
        BlocProvider.of<ViewSubmissionsPageBlocFactory>(context);
    bloc = blocFactory.create(widget.homeworkId);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SharezonePlusFeatureGuard(
      paidFeature: PaidFeature.teacherSubmission,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Abgaben'),
          centerTitle: true,
        ),
        body: StreamBuilder<CreatedSubmissionsPageView>(
          stream: bloc.pageView,
          builder: (context, snapshot) {
            return AnimatedSwitcher(
              duration: Duration(milliseconds: 300),
              child: snapshot.hasData
                  ? _Abgabenbody(
                      pageView: snapshot.data,
                      key: const ValueKey('AnimatedSwitcherKey'),
                    )
                  : _LoadingPlaceholder(
                      key: const ValueKey('AnimatedSwitcherKey')),
            );
          },
        ),
      ),
    );
  }
}

class _Abgabenbody extends StatelessWidget {
  const _Abgabenbody({
    Key key,
    @required this.pageView,
  }) : super(key: key);

  final CreatedSubmissionsPageView pageView;

  @override
  Widget build(BuildContext context) {
    if (pageView.missingSubmissions.isEmpty && pageView.submissions.isEmpty) {
      return _NoMembersPlaceholder();
    }
    return SingleChildScrollView(
      child: Column(
        children: [
          ...[
            for (final view in pageView.submissions)
              _UserSubmissionTile(view: view)
          ],
          SizedBox(height: 10),
          if (pageView.afterDeadlineSubmissions.isNotEmpty)
            DividerWithText(
              text: 'Zu spät abgegeben 🕐',
              textStyle: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
          ...[
            for (final view in pageView.afterDeadlineSubmissions)
              _UserSubmissionTile(view: view)
          ],
          if (pageView.missingSubmissions.isNotEmpty)
            DividerWithText(
              text: 'Nicht abgegeben 😭',
              textStyle: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
          ...[
            for (final view in pageView.missingSubmissions)
              _NoSubmissionTile(view: view)
          ],
        ],
      ),
    );
  }
}

class _LoadingPlaceholder extends StatelessWidget {
  const _LoadingPlaceholder({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: GrayShimmer(
        child: _Abgabenbody(
          pageView: CreatedSubmissionsPageView(submissions: [
            CreatedSubmissionView(
              abbreviation: 'A',
              username: 'Patrick Star',
              submittedFiles: [],
              lastActionDateTime: DateTime.now(),
              wasEditedAfterwards: false,
            ),
            CreatedSubmissionView(
              abbreviation: 'S',
              username: 'Spongebob Schwammkopf',
              submittedFiles: [],
              lastActionDateTime: DateTime.now(),
              wasEditedAfterwards: false,
            ),
          ], afterDeadlineSubmissions: [
            CreatedSubmissionView(
              abbreviation: 'B',
              username: 'Thaddäus Tentakel',
              submittedFiles: [],
              lastActionDateTime: DateTime.now(),
              wasEditedAfterwards: false,
            ),
          ], missingSubmissions: [
            NotSubmittedView(
              abbreviation: 'P',
              username: 'Plankton',
            ),
          ]),
        ),
      ),
    );
  }
}

class _NoMembersPlaceholder extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MemePlaceholder(
      url: 'https://sharezone.net/meme-no-members-for-submissions',
      text: 'Vergessen Teilnehmer in den Kurs einzuladen?',
    );
  }
}

class _UserSubmissionTile extends StatelessWidget {
  const _UserSubmissionTile({
    @required this.view,
    Key key,
  }) : super(key: key);

  final CreatedSubmissionView view;

  @override
  Widget build(BuildContext context) {
    String subtitle = DateFormat('dd.MM.yyyy HH:mm')
        .format(view.lastActionDateTime.toLocal());
    if (view.wasEditedAfterwards) subtitle += ' (nachträglich bearbeitet)';

    return ExpansionTile(
      leading: CircleAvatar(
        child: Text(view.abbreviation),
      ),
      title: Text(view.username),
      // letztes Datum, wo irgendwas passiert ist (eingereicht, gelöscht etc)
      subtitle: Text(subtitle),
      children: <Widget>[
        for (final fileView in view.submittedFiles)
          _FileTile(
            format: fileView.format,
            title: fileView.title,
            onTap: () => openAbgegebeneAbgabedatei(context, fileView),
          ),
      ],
    );
  }
}

class _FileTile extends StatelessWidget {
  const _FileTile({
    @required this.format,
    @required this.title,
    @required this.onTap,
    Key key,
  }) : super(key: key);

  final FileFormat format;
  final String title;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20.0),
      child: ListTile(
        onTap: onTap,
        leading: FileIcon(fileFormat: format),
        title: Text(title),
      ),
    );
    // return Padding(
    //   padding: const EdgeInsets.only(left: 57.0),
    //   child: ListTile(
    //     onTap: onTap,
    //     leading: FileIcon(fileFormat: format),
    //     title: Text(title),
    //   ),
    // );
  }
}

class _NoSubmissionTile extends StatelessWidget {
  const _NoSubmissionTile({
    @required this.view,
  });

  final NotSubmittedView view;

  @override
  Widget build(BuildContext context) {
    return Padding(
      // Damit der Abstand wie bei den ExpansionTiles ist
      padding: const EdgeInsets.only(bottom: 3),
      child: ListTile(
        title: Text(view.username),
        leading: CircleAvatar(
          child: Text(view.abbreviation),
        ),
      ),
    );
  }
}
