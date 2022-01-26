// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

part of 'privacy_policy.dart';

class _Topic extends StatelessWidget {
  const _Topic({Key key, @required this.title, @required this.texts})
      : super(key: key);

  final Widget title;
  final List<Widget> texts;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[title, ...texts, SizedBox(height: 20)],
    );
  }
}
