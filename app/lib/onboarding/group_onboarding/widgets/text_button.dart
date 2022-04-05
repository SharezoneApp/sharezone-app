// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:flutter/material.dart';
import 'package:sharezone_widgets/widgets.dart';

class GroupOnboardingTextButton extends StatelessWidget {
  const GroupOnboardingTextButton({
    Key key,
    this.text,
    this.onTap,
    this.icon,
  }) : super(key: key);

  final Widget icon;
  final String text;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 500),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          child: CustomCard(
            onTap: onTap,
            padding: const EdgeInsets.all(12),
            child: Row(
              children: <Widget>[
                if (icon != null) ...[
                  IconTheme(
                    data: IconThemeData(color: Colors.grey[700]),
                    child: icon,
                  ),
                  const SizedBox(width: 12),
                ],
                Expanded(
                  child: Center(
                    child: Text(
                      text,
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
