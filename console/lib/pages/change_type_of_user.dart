// Copyright (c) 2024 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/material.dart';

class ChangeTypeOfUserPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Change Type Of User"),
      ),
      body: Center(
        child: TypeOfUserChangeDialogs(),
      ),
    );
  }
}

class TypeOfUserChangeDialogs extends StatefulWidget {
  TypeOfUserChangeDialogs({Key? key}) : super(key: key);

  @override
  _TypeOfUserChangeDialogsState createState() =>
      _TypeOfUserChangeDialogsState();
}

class _TypeOfUserChangeDialogsState extends State<TypeOfUserChangeDialogs> {
  final _formKey = GlobalKey<FormState>();
  Nutzertyp? _nutzertyp;
  String? _cloudFunctionResult;
  String? _userId;
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Text(
          'Nutzertyp ändern:',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        Form(
          key: _formKey,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                width: 200,
                child: TextFormField(
                  decoration: InputDecoration(
                    helperText: 'Nutzer-Id',
                  ),
                  validator: (userId) {
                    if (userId!.isEmpty) {
                      return 'UserId darf nicht leer sein.';
                    }
                    return null;
                  },
                  onChanged: (newUid) {
                    setState(() {
                      _userId = newUid;
                    });
                  },
                ),
              ),
              const SizedBox(width: 50),
              DropdownButton(
                hint: Text('Nutzertyp'),
                value: _nutzertyp,
                onChanged: (dynamic newValue) {
                  setState(() {
                    _nutzertyp = newValue;
                  });
                },
                items: Nutzertyp.values.map((location) {
                  return DropdownMenuItem(
                    child: Text(location.toReadableString()),
                    value: location,
                  );
                }).toList(),
              ),
              const SizedBox(width: 150),
              if (loading)
                const CircularProgressIndicator()
              else
                ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate() &&
                        _nutzertyp != null) {
                      _cloudFunctionResult = null;

                      final cfs =
                          FirebaseFunctions.instanceFor(region: 'europe-west1');
                      final function =
                          cfs.httpsCallable('updateTypeOfUserAdmin');
                      final parameters = {
                        'userID': _userId,
                        'typeOfUser': _nutzertyp.toTypeOfUserString(),
                      };
                      print('Calling function with: $parameters');
                      try {
                        setState(() {
                          loading = true;
                        });
                        final res = await function.call(parameters);
                        setState(() {
                          _cloudFunctionResult =
                              res.data?.toString() ?? '[Leere Antwort]';
                        });
                        setState(() {
                          loading = false;
                        });
                      } catch (e) {
                        setState(() {
                          loading = false;
                        });
                        String msg = 'Error: $e';
                        if (e is FirebaseFunctionsException) {
                          msg = 'Error: ${e.toReadableString()}';
                        }
                        msg = 'Error: $e';
                        setState(() {
                          _cloudFunctionResult = msg;
                        });
                      }
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text('Input nicht valide'),
                      ));
                    }
                  },
                  child: const Text('Submit'),
                ),
            ],
          ),
        ),
        if (_cloudFunctionResult != null)
          Text(
            '$_cloudFunctionResult',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
      ],
    );
  }
}

extension on FirebaseFunctionsException {
  String toReadableString() {
    return 'Cloud-Function Exception: code: $code\ndetails: $details\nmessage $message)';
  }
}

enum Nutzertyp { schueler, lehrer, elternteil }

extension on Nutzertyp? {
  String toReadableString() {
    switch (this) {
      case Nutzertyp.schueler:
        return 'Schüler';
      case Nutzertyp.lehrer:
        return 'Lehrer';
      case Nutzertyp.elternteil:
        return 'Elternteil';
      default:
        return 'UNBEKANNT';
    }
  }

  String toTypeOfUserString() {
    switch (this) {
      case Nutzertyp.schueler:
        return 'student';
      case Nutzertyp.lehrer:
        return 'teacher';
      case Nutzertyp.elternteil:
        return 'parent';
      default:
        throw UnimplementedError();
    }
  }
}
