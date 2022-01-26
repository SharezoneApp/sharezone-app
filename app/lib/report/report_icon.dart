// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:flutter/material.dart';
import 'package:sharezone/report/page/report_page.dart';
import 'package:sharezone/report/report.dart';
import 'package:sharezone/report/report_item.dart';

/// Ist als Variable gespeichert, damit das Icon einfach und schnell
/// überall in der App ausgetauscht werden kann.
const reportIcon = Icon(Icons.flag);

class ReportIcon extends StatelessWidget {
  const ReportIcon({Key key, @required this.item, this.color, this.tooltip})
      : super(key: key);

  final ReportItemReference item;
  final Color color;
  final String tooltip;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      tooltip: tooltip ??
          '${reportItemTypeToUiString(ReportItem(item.path).type)} melden',
      icon: reportIcon,
      onPressed: () => openReportPage(context, item),
      color: color,
    );
  }
}
