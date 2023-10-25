// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:bloc_provider/bloc_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:sharezone/groups/src/widgets/contact_support.dart';
import 'package:sharezone/settings/src/subpages/imprint/bloc/imprint_bloc.dart';
import 'package:sharezone/settings/src/subpages/imprint/bloc/imprint_bloc_factory.dart';
import 'package:sharezone/settings/src/subpages/imprint/models/imprint.dart';
import 'package:sharezone/util/launch_link.dart';

class ImprintPage extends StatefulWidget {
  static const tag = 'imprint-page';

  const ImprintPage({super.key});

  @override
  State createState() => _ImprintPageState();
}

class _ImprintPageState extends State<ImprintPage> {
  late ImprintBloc bloc;

  @override
  void initState() {
    super.initState();
    bloc = BlocProvider.of<ImprintBlocFactory>(context).create();
  }

  @override
  Widget build(BuildContext context) {
    final offlineData = Imprint.offline().asMarkdown;
    return Scaffold(
      appBar: AppBar(title: const Text("Impressum")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(12),
        child: SafeArea(
          child: StreamBuilder<String>(
            initialData: offlineData,
            stream: bloc.markdownStream,
            builder: (context, snapshot) {
              final data = snapshot.data ?? offlineData;
              return MarkdownBody(
                data: data,
                onTapLink: (link, _, __) => launchURL(link),
                selectable: true,
              );
            },
          ),
        ),
      ),
      bottomNavigationBar: const ContactSupport(),
    );
  }
}
