// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:bloc_base/bloc_base.dart';
import 'package:bloc_provider/bloc_provider.dart';
import 'package:flutter/material.dart';
import 'package:sharezone/groups/src/pages/school_class/my_school_class_bloc.dart';
import 'package:sharezone_widgets/widgets.dart';

class SchoolClassCreateBloc extends BlocBase {
  SchoolClassCreateBloc();

  final ValueNotifier<String> name = ValueNotifier("");

  @override
  void dispose() {
    name.dispose();
  }
}

Future<dynamic> openMySchoolClassCreateDialog(
    BuildContext context, MySchoolClassBloc schoolClassBloc) {
  final bloc = SchoolClassCreateBloc();
  return showDialog(
    context: context,
    builder: (context) {
      return BlocProvider(
        child: BlocProvider(child: MySchoolClassCreateDialog(), bloc: bloc),
        bloc: schoolClassBloc,
      );
    },
  );
}

class MySchoolClassCreateDialog extends StatefulWidget {
  const MySchoolClassCreateDialog({Key key}) : super(key: key);

  @override
  _MySchoolClassCreateDialogState createState() =>
      _MySchoolClassCreateDialogState();
}

class _MySchoolClassCreateDialogState extends State<MySchoolClassCreateDialog> {
  bool isLoading = false;
  String errorTextForUser;

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<SchoolClassCreateBloc>(context);
    return AlertDialog(
      title: const Text("Schulklasse erstellen"),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const SizedBox(height: 8),
            _NameField(),
            if (errorTextForUser != null)
              Text(errorTextForUser,
                  style: TextStyle(
                      color: Theme.of(context).errorColor, fontSize: 14)),
          ],
          mainAxisSize: MainAxisSize.min,
        ),
      ),
      actions: isLoading
          ? <Widget>[LoadingCircle()]
          : <Widget>[
              CancleButton(),
              ValueListenableBuilder<String>(
                valueListenable: bloc.name,
                builder: (builderContext, data, _) {
                  return TextButton(
                    style: TextButton.styleFrom(
                      primary: Theme.of(context).primaryColor,
                    ),
                    child: const Text("ERSTELLEN"),
                    onPressed: data.isEmpty
                        ? null
                        : () {
                            final schoolClassBloc =
                                BlocProvider.of<MySchoolClassBloc>(
                                    builderContext);
                            setState(() => isLoading = true);
                            schoolClassBloc
                                .createSchoolClass(data)
                                .then((result) {
                              if (result != null &&
                                  result.hasData &&
                                  result.data == true) {
                                Navigator.pop(context, true);
                              }
                            }).catchError((e, s) {
                              setState(() {
                                isLoading = false;
                                errorTextForUser = "$e $s";
                              });
                            });
                          },
                  );
                },
              )
            ],
    );
  }
}

class _NameField extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<SchoolClassCreateBloc>(context);
    return TextField(
      autofocus: true,
      decoration: InputDecoration(
        labelText: "Name",
        border: OutlineInputBorder(),
      ),
      maxLines: 1,
      maxLength: 32,
      onChanged: (newtext) => bloc.name.value = newtext,
    );
  }
}
