// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:bloc_provider/bloc_provider.dart';
import 'package:flutter/material.dart';
import 'package:sharezone/groups/src/pages/school_class/my_school_class_bloc.dart';
import 'package:sharezone_widgets/widgets.dart';

Future<dynamic> openMySchoolClassCreateDialog(
    BuildContext context, MySchoolClassBloc schoolClassBloc) {
  return showDialog(
    context: context,
    builder: (context) {
      return BlocProvider(
        child: SchoolClassCreateDialog(),
        bloc: schoolClassBloc,
      );
    },
  );
}

class SchoolClassCreateDialog extends StatefulWidget {
  const SchoolClassCreateDialog({Key key}) : super(key: key);

  @override
  _SchoolClassCreateDialogState createState() =>
      _SchoolClassCreateDialogState();
}

class _SchoolClassCreateDialogState extends State<SchoolClassCreateDialog> {
  String className = '';
  bool isLoading = false;
  String errorTextForUser;

  Future<void> _createClass(BuildContext context, String className) async {
    if (className == null || className.isEmpty) {
      return;
    }

    setState(() => isLoading = true);

    try {
      final bloc = BlocProvider.of<MySchoolClassBloc>(context);

      final result = await bloc.createSchoolClass(className);
      if (result != null && result.hasData && result.data == true) {
        Navigator.pop(context, true);
      }
    } catch (e, s) {
      setState(() {
        isLoading = false;
        errorTextForUser = "$e $s";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Schulklasse erstellen"),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const SizedBox(height: 8),
            _NameField(
              value: className,
              onChanged: (newName) => setState(() => className = newName),
              onSubmitted: (className) => _createClass(context, className),
            ),
            if (errorTextForUser != null)
              Text(
                errorTextForUser,
                style: TextStyle(
                  color: Theme.of(context).errorColor,
                  fontSize: 14,
                ),
              ),
          ],
          mainAxisSize: MainAxisSize.min,
        ),
      ),
      actions: isLoading
          ? <Widget>[LoadingCircle()]
          : <Widget>[
              CancleButton(),
              TextButton(
                  style: TextButton.styleFrom(
                    foregroundColor: Theme.of(context).primaryColor,
                  ),
                  child: const Text("ERSTELLEN"),
                  onPressed: className.isEmpty
                      ? null
                      : () => _createClass(context, className)),
            ],
    );
  }
}

class _NameField extends StatelessWidget {
  const _NameField({
    Key key,
    @required this.value,
    @required this.onChanged,
    @required this.onSubmitted,
  }) : super(key: key);

  final String value;
  final void Function(String) onChanged;
  final void Function(String) onSubmitted;

  @override
  Widget build(BuildContext context) {
    return TextField(
      autofocus: true,
      decoration: InputDecoration(
        labelText: "Name",
        border: OutlineInputBorder(),
      ),
      maxLines: 1,
      maxLength: 32,
      onChanged: onChanged,
      onSubmitted: onSubmitted,
    );
  }
}
