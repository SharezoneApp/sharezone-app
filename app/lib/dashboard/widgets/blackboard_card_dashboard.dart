// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:bloc_provider/bloc_provider.dart';
import 'package:flutter/material.dart';
import 'package:sharezone/blackboard/blackboard_card.dart';
import 'package:sharezone/blackboard/blackboard_view.dart';
import 'package:sharezone/blackboard/blocs/blackboard_card_bloc.dart';
import 'package:sharezone/blocs/application_bloc.dart';
import 'package:sharezone_common/helper_functions.dart';
import 'package:sharezone_widgets/sharezone_widgets.dart';

/// Diese BlackboardCard wird nun auf der Dashboard-Seite verwendet
/// und ist für diese Seite extra angepasst (Größte, etc.)
class BlackboardCardDashboard extends StatelessWidget {
  const BlackboardCardDashboard({
    Key? key,
    this.view,
    this.width,
    this.height,
    this.maxLines = 4,
    this.withDetailsButton = true,
    this.forceIsRead,
    this.padding,
  }) : super(key: key);

  final BlackboardView? view;
  final double? width, height;
  final int maxLines;
  final bool? withDetailsButton, forceIsRead;
  final EdgeInsets? padding;

  @override
  Widget build(BuildContext context) {
    final width = this.width ?? MediaQuery.of(context).size.width;
    final api = BlocProvider.of<SharezoneContext>(context).api;
    final bloc = BlackboardCardBloc(gateway: api.blackboard, itemID: view!.id);
    return BlocProvider(
      bloc: bloc,
      child: Padding(
        padding: padding ?? const EdgeInsets.only(left: 12),
        child: SizedBox(
          width: width,
          height: height,
          child: CustomCard(
            onTap: () => openDetails(context, view!, bloc),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                _Header(
                    width: width,
                    view: view,
                    hasText: isNotEmptyOrNull(view!.text)),
                _Text(text: view!.text, maxLines: maxLines),
                BottomActionBar(
                    view: view!, withDetailsButton: withDetailsButton!)
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({Key? key, this.view, this.width, this.hasText = true})
      : super(key: key);

  final BlackboardView? view;
  final double? width;
  final bool hasText;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 10, 10, 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          SizedBox(
            width: width! - (view!.hasAttachments ? 90 : 56),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                _Title(view!.title, hasText: hasText),
                _CourseName(
                    name: view!.courseName, color: view!.courseNameColor),
              ],
            ),
          ),
          if (view!.hasAttachments)
            Icon(Icons.attach_file, color: Colors.grey[700], size: 20),
        ],
      ),
    );
  }
}

class _CourseName extends StatelessWidget {
  const _CourseName({Key? key, this.name, this.color}) : super(key: key);

  final String? name;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Text(
      name!,
      style: TextStyle(color: color),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }
}

class _Title extends StatelessWidget {
  final String title;
  final bool? hasText;

  const _Title(this.title, {Key? key, this.hasText}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: TextStyle(
          color: isDarkThemeEnabled(context)
              ? Colors.lightBlue[100]
              : darkBlueColor,
          fontWeight: FontWeight.w500,
          fontSize: 16),
      maxLines: hasText! ? 1 : 3,
      overflow: TextOverflow.ellipsis,
    );
  }
}

class _Text extends StatelessWidget {
  const _Text({Key? key, this.text, this.maxLines}) : super(key: key);

  final String? text;
  final int? maxLines;

  @override
  Widget build(BuildContext context) {
    if (isEmptyOrNull(text)) return Container();
    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 10),
      child: Text(
        text!,
        style: TextStyle(color: Colors.grey[700]),
        maxLines: maxLines,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}
