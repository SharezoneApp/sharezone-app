// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:flutter/material.dart';
import 'package:sharezone_widgets/sharezone_widgets.dart';

class FilePageAppBar extends StatelessWidget implements PreferredSizeWidget {
  const FilePageAppBar({
    super.key,
    this.actions,
    required this.name,
    this.nameStream,
  });

  final String? name;
  final Stream<String>? nameStream;
  final List<Widget>? actions;

  @override
  Size get preferredSize => const Size.fromHeight(56);

  Widget? _getTitle() {
    if (nameStream != null) {
      return StreamBuilder<String>(
        initialData: name,
        stream: nameStream,
        builder: (context, snapshot) {
          final name = snapshot.data;
          return _Title(name: name);
        },
      );
    }

    if (name != null) {
      return _Title(name: name);
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: _getTitle(),
      centerTitle: true,
      iconTheme: const IconThemeData(color: Colors.white60),
      backgroundColor: Colors.black,
      actions: actions,
    );
  }
}

class _Title extends StatelessWidget {
  const _Title({required this.name});

  final String? name;

  @override
  Widget build(BuildContext context) {
    return Text(
      name!,
      style: const TextStyle(
        color: Colors.white,
        fontFamily: rubik,
      ),
    );
  }
}
