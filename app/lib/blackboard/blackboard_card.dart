// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:analytics/analytics.dart';
import 'package:bloc_provider/bloc_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:sharezone/blackboard/blocs/blackboard_card_bloc.dart';
import 'package:sharezone/blackboard/details/blackboard_details.dart';
import 'package:sharezone/blocs/application_bloc.dart';
import 'package:sharezone/util/launch_link.dart';
import 'package:sharezone_common/helper_functions.dart';
import 'package:sharezone_widgets/sharezone_widgets.dart';

import 'blackboard_view.dart';

Future<void> showUserConfirmationOfBlackboardArrival(
    BuildContext context) async {
  await Future.delayed(
      const Duration(milliseconds: 320)); // Waiting for pop animation
  showDataArrivalConfirmedSnackbar(context: context);
}

Future<void> showUserConfirmationOfBlackboardDeleted(
    BuildContext context) async {
  await Future.delayed(
      const Duration(milliseconds: 320)); // Waiting for pop animation
  showSnackSec(context: context, text: "Eintrag wurde gelöscht.");
}

void openDetails(
    BuildContext context, BlackboardView view, BlackboardCardBloc bloc) {
  Navigator.of(context)
      .push<BlackboardPopOption>(MaterialPageRoute(
    builder: (BuildContext context) => BlackboardDetails(view: view),
  ))
      .then((BlackboardPopOption popOption) {
    if (popOption != null) {
      if (popOption == BlackboardPopOption.deleted) {
        logBlackboardDeleteEvent(context);
        showUserConfirmationOfBlackboardDeleted(context);
      } else {
        logBlackboardEditEvent(context);
        showUserConfirmationOfBlackboardArrival(context);
      }
    }
  });
}

void logBlackboardDeleteEvent(BuildContext context) {
  final analytics = BlocProvider.of<SharezoneContext>(context).analytics;
  analytics.log(NamedAnalyticsEvent(name: "blackboard_delete"));
}

void logBlackboardEditEvent(BuildContext context) {
  final analytics = BlocProvider.of<SharezoneContext>(context).analytics;
  analytics.log(NamedAnalyticsEvent(name: "blackboard_edit"));
}

class BlackboardCard extends StatelessWidget {
  const BlackboardCard(this.view, {Key key}) : super(key: key);

  final BlackboardView view;

  @override
  Widget build(BuildContext context) {
    final api = BlocProvider.of<SharezoneContext>(context).api;
    final bloc = BlackboardCardBloc(gateway: api.blackboard, itemID: view.id);
    final isAuthorOrIsRead = view.isAuthor || view.isRead;
    return BlocProvider(
      bloc: bloc,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: CustomCard(
          opacity: isAuthorOrIsRead ? 0.7 : 1.0,
          onTap: () => openDetails(context, view, bloc),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              if (view.hasPhoto) _Picture(view: view),
              Padding(
                padding: const EdgeInsets.only(
                    left: 16, top: 16, right: 16, bottom: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    LayoutBuilder(builder: (context, constraints) {
                      return Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          _HeadlineAndCourseName(
                              maxWidth: constraints.maxWidth, view: view),
                          if (view.hasAttachments) _AttachmentIcon(),
                          if (view.isAuthor) _IsAuthorIcon(),
                        ],
                      );
                    }),
                    if (view.hasPermissionToEdit)
                      _ReadPercent(
                        value: view.readPercent,
                        color: view.readPerecentColor,
                      ),
                    if (isNotEmptyOrNull(view.previewText))
                      _Text(view.previewText),
                  ],
                ),
              ),
              BottomActionBar(view: view),
            ],
          ),
        ),
      ),
    );
  }
}

class _HeadlineAndCourseName extends StatelessWidget {
  const _HeadlineAndCourseName({Key key, this.maxWidth, this.view})
      : super(key: key);

  final double maxWidth;
  final BlackboardView view;

  @override
  Widget build(BuildContext context) {
    const subtitleStyle = TextStyle(color: Colors.grey, fontSize: 14);
    return SizedBox(
      width: maxWidth - getIconSpace(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(view.title,
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: view.isAuthor || view.isRead
                      ? FontWeight.w400
                      : FontWeight.w800)),
          Text('${view.courseName} - ${view.createdOnText}',
              style: subtitleStyle),
        ],
      ),
    );
  }

  /// Gibt den Space wieder, den die Hinweis-Icons benötigen
  double getIconSpace() {
    const iconSpace = 30.0;
    if (view.hasAttachments && view.isAuthor) return iconSpace * 2;
    if (view.hasAttachments || view.isAuthor) return iconSpace;
    return 0;
  }
}

class _AttachmentIcon extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return _TipIcon(
      tooltip: 'Enthält Anhänge',
      icon: Icons.attach_file,
    );
  }
}

class _IsAuthorIcon extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return _TipIcon(
      tooltip: 'Mein Eintrag',
      icon: themeIconData(Icons.person, cupertinoIcon: CupertinoIcons.person),
    );
  }
}

class _TipIcon extends StatelessWidget {
  const _TipIcon({Key key, this.tooltip, this.icon}) : super(key: key);

  final String tooltip;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 4),
      child: Tooltip(
        message: tooltip,
        child: Icon(icon,
            color: isDarkThemeEnabled(context) ? Colors.grey : Colors.grey[700],
            size: 20),
      ),
    );
  }
}

class _ReadPercent extends StatelessWidget {
  const _ReadPercent({Key key, this.value, this.color}) : super(key: key);

  final int value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Text(
        "$value%",
        style: TextStyle(color: color),
      ),
    );
  }
}

class _Text extends StatelessWidget {
  const _Text(this.text, {Key key}) : super(key: key);

  final String text;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: MarkdownBody(
        data: text,
        softLineBreak: true,
        onTapLink: (url, _, __) => launchURL(url),
        styleSheet: MarkdownStyleSheet.fromTheme(
          theme.copyWith(
            textTheme: theme.textTheme.copyWith(
              bodyMedium: TextStyle(
                color: Colors.grey,
                fontSize: 14,
                fontFamily: rubik,
              ),
            ),
          ),
        ).copyWith(a: linkStyle(context, 14)),
      ),
    );
  }
}

class _Picture extends StatelessWidget {
  const _Picture({Key key, @required this.view}) : super(key: key);

  final BlackboardView view;

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: view.id,
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: 120,
        decoration: BoxDecoration(
          image: DecorationImage(
            fit: BoxFit.cover,
            image: AssetImage(view.pictureURL),
          ),
        ),
      ),
    );
  }
}

class BottomActionBar extends StatelessWidget {
  const BottomActionBar({Key key, this.withDetailsButton = true, this.view})
      : super(key: key);

  final bool withDetailsButton;
  final BlackboardView view;

  @override
  Widget build(BuildContext context) {
    final analytics = BlocProvider.of<SharezoneContext>(context).analytics;
    final bloc = BlocProvider.of<BlackboardCardBloc>(context);
    return Align(
      alignment: Alignment.bottomLeft,
      child: Padding(
        padding: const EdgeInsets.only(left: 4),
        child: Row(
          children: <Widget>[
            // if (withDetailsButton)
            //   TextButton(
            //     child: const Text('DETAILS'),
            //     textColor: Theme.of(context).primaryColor,
            //     onPressed: () => openDetails(context, view, bloc),
            //   ),
            if (!view.isAuthor && !view.isRead)
              TextButton(
                child: const Text('ALS GELESEN MARKIEREN'),
                style: TextButton.styleFrom(
                  foregroundColor: Theme.of(context).primaryColor,
                ),
                onPressed: () {
                  analytics.log(NamedAnalyticsEvent(name: "blackboard_read"));
                  bloc.changeReadState(true);
                },
              ),
          ],
        ),
      ),
    );
  }
}
