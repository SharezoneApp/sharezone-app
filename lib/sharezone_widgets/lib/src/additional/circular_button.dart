// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:flutter/material.dart';

class CircularButton extends StatelessWidget {
  const CircularButton(
      {Key key, this.title, this.subtitle, this.color, this.icon, this.onTap})
      : super(key: key);

  final String title, subtitle;
  final Color color;
  final Widget icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Column(
        children: <Widget>[
          const SizedBox(height: 12),
          Stack(
            children: <Widget>[
              Container(
                height: 45,
                width: 45,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: color.withOpacity(0.1),
                ),
              ),
              Positioned(left: 11, top: 11, child: icon)
            ],
          ),
          const SizedBox(height: 8),
          Text(title, style: Theme.of(context).textTheme.titleLarge),
          Text(subtitle,
              style: TextStyle(fontSize: 15, color: Colors.grey[400])),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
