// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:flutter/material.dart';
import 'package:sharezone_widgets/sharezone_widgets.dart';

class FileSharingHeadline extends StatelessWidget {
  const FileSharingHeadline({Key? key, this.title}) : super(key: key);

  final String? title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 6, top: 4, bottom: 12),
      child: Text(
        title!,
        style: TextStyle(
            color: Theme.of(context).isDarkTheme
                ? Colors.grey[400]
                : Colors.grey[700],
            fontWeight: FontWeight.w600),
      ),
    );
  }
}
