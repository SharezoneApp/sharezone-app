// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:bloc_provider/bloc_provider.dart';
import 'package:flutter/material.dart';
import 'package:group_domain_models/group_domain_models.dart';
import 'package:sharezone/main/application_bloc.dart';
import 'package:sharezone/groups/src/pages/school_class/edit/school_class_edit_bloc.dart';
import 'package:sharezone/groups/src/pages/school_class/edit/school_class_edit_gateway.dart';
import 'package:sharezone_common/api_errors.dart';
import 'package:sharezone_widgets/sharezone_widgets.dart';
import 'package:sharezone_localizations/sharezone_localizations.dart';

Future<void> openSchoolClassEditPage(
  BuildContext context,
  SchoolClass schoolClass,
) async {
  final successful = await Navigator.push<bool>(
    context,
    MaterialPageRoute(
      builder: (context) => SchoolClassEditPage(schoolClass: schoolClass),
      settings: const RouteSettings(name: SchoolClassEditPage.tag),
    ),
  );
  if (successful == true && context.mounted) {
    await _showSchoolClassConformationSnackbarWithDelay(context);
  }
}

Future<void> _showSchoolClassConformationSnackbarWithDelay(
  BuildContext context,
) async {
  await waitingForPopAnimation();
  if (!context.mounted) return;
  showSnackSec(
    context: context,
    text: context.l10n.schoolClassEditSuccess,
    seconds: 2,
  );
}

Future<void> _submit(BuildContext context) async {
  sendDataToFrankfurtSnackBar(context);
  final bloc = BlocProvider.of<SchoolClassEditBloc>(context);
  try {
    final result = await bloc.submit();
    if (result && context.mounted) Navigator.pop(context, true);
  } on Exception catch (e, s) {
    if (context.mounted) {
      showSnackSec(
        context: context,
        seconds: 4,
        text: handleErrorMessage(l10n: context.l10n, error: e, stackTrace: s),
      );
    }
  }
}

class SchoolClassEditPage extends StatefulWidget {
  const SchoolClassEditPage({super.key, required this.schoolClass});

  static const tag = "school-class-details-page";
  final SchoolClass schoolClass;

  @override
  State createState() => _SchoolClassEditPageState();
}

class _SchoolClassEditPageState extends State<SchoolClassEditPage> {
  late SchoolClassEditBloc bloc;
  bool _didInit = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_didInit) return;
    final schoolClassGateway =
        BlocProvider.of<SharezoneContext>(context).api.schoolClassGateway;
    bloc = SchoolClassEditBloc(
      gateway: SchoolClassEditGateway(schoolClassGateway, widget.schoolClass),
      currentName: widget.schoolClass.name,
      l10n: context.l10n,
    );
    _didInit = true;
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      bloc: bloc,
      child: Scaffold(
        appBar: AppBar(title: Text(context.l10n.schoolClassEditTitle)),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(12),
          child: MaxWidthConstraintBox(
            child: SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  _NameField(currentName: widget.schoolClass.name),
                ],
              ),
            ),
          ),
        ),
        floatingActionButton: _SchoolClassEditPageFAB(),
      ),
    );
  }
}

class _SchoolClassEditPageFAB extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      tooltip: context.l10n.commonActionsSave,
      child: const Icon(Icons.check),
      onPressed: () => _submit(context),
    );
  }
}

class _NameField extends StatelessWidget {
  const _NameField({this.currentName});

  final String? currentName;

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<SchoolClassEditBloc>(context);
    return StreamBuilder<String>(
      stream: bloc.name,
      builder: (context, snapshot) {
        return PrefilledTextField(
          prefilledText: currentName,
          onChanged: bloc.changeName,
          autofocus: true,
          onEditingComplete: () => _submit(context),
          decoration: InputDecoration(
            labelText: context.l10n.commonFieldName,
            errorText: snapshot.error?.toString(),
          ),
          maxLength: 32,
          textInputAction: TextInputAction.done,
          textCapitalization: TextCapitalization.sentences,
        );
      },
    );
  }
}
