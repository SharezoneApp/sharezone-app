// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:flutter/material.dart';

import '../widgets/file_page_app_bar.dart';

class ErrorFilePage extends StatefulWidget {
  const ErrorFilePage({
    super.key,
    required this.name,
    required this.nameStream,
    required this.id,
    required this.error,
  });

  static const tag = "error-page";

  final String name;
  final Stream<String>? nameStream;
  final String id;
  final Widget error;

  @override
  State createState() => _ErrorFilePageState();
}

class _ErrorFilePageState extends State<ErrorFilePage> {
  bool showAppBar = true;

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(brightness: Brightness.dark),
      child: Scaffold(
        appBar:
            showAppBar
                ? FilePageAppBar(
                  name: widget.name,
                  nameStream: widget.nameStream,
                )
                : null,
        backgroundColor: Colors.black,
        body: SafeArea(
          bottom: false,
          left: false,
          right: false,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.error_outline, color: Colors.red),
                  const SizedBox(height: 16),
                  DefaultTextStyle.merge(
                    child: widget.error,
                    style: const TextStyle(color: Colors.red, fontSize: 18),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
