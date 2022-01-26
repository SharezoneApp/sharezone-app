// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:bloc_provider/bloc_provider.dart';
import 'package:bloc_provider/multi_bloc_provider.dart';
import 'package:flutter/material.dart';
import 'package:sharezone/blocs/application_bloc.dart';
import 'package:sharezone/blocs/file_sharing/file_sharing_page_bloc.dart';
import 'package:sharezone/filesharing/file_sharing_page_controller.dart';

import 'logic/file_sharing_page_state_bloc.dart';

class FileSharingPage extends StatefulWidget {
  static const String tag = "file-sharing-page";

  @override
  _FileSharingPageState createState() => _FileSharingPageState();
}

class _FileSharingPageState extends State<FileSharingPage> {
  FileSharingPageBloc fileSharingPageBloc;
  FileSharingPageStateBloc fileSharingPageStateBloc;

  @override
  void initState() {
    super.initState();
    final fileSharingGateway =
        BlocProvider.of<SharezoneContext>(context).api.fileSharing;
    fileSharingPageBloc = FileSharingPageBloc(fileSharingGateway);
    fileSharingPageStateBloc = FileSharingPageStateBloc();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      blocProviders: [
        BlocProvider<FileSharingPageBloc>(bloc: fileSharingPageBloc),
        BlocProvider<FileSharingPageStateBloc>(bloc: fileSharingPageStateBloc),
      ],
      child: (context) => FileSharingPageController(),
    );
  }
}
