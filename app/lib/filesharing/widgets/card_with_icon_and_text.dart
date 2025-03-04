// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:flutter/material.dart';
import 'package:sharezone_widgets/sharezone_widgets.dart';

class CardWithIconAndText extends StatelessWidget {
  const CardWithIconAndText({
    super.key,
    this.icon,
    this.text,
    this.onTap,
    this.trailing,
  });

  final Widget? icon, trailing;
  final String? text;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: SizedBox(
        height: 60,
        child: Padding(
          padding: const EdgeInsets.only(right: 8),
          child: CustomCard(
            onTap: onTap,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(12, 8, 0, 8),
              child: Row(
                children: <Widget>[
                  icon!,
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      text!,
                      style: const TextStyle(fontSize: 16, height: 1.3),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                    ),
                  ),
                  if (trailing != null) trailing! else const SizedBox(width: 8),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
