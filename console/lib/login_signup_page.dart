// Copyright (c) 2024 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginSignupPage extends StatefulWidget {
  LoginSignupPage({required this.auth});

  final FirebaseAuth auth;

  @override
  State<StatefulWidget> createState() => new _LoginSignupPageState();
}

class _LoginSignupPageState extends State<LoginSignupPage> {
  final _formKey = new GlobalKey<FormState>();

  String _email = '';
  String _password = '';
  String? _errorMessage;

  bool _isLoading = false;

  // Check if form is valid before perform login or signup
  bool validateAndSave() {
    final form = _formKey.currentState!;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  // Perform login or signup
  void validateAndSubmit() async {
    setState(() {
      _errorMessage = "";
      _isLoading = true;
    });
    if (validateAndSave()) {
      try {
        final res = await widget.auth.signInWithEmailAndPassword(
          email: _email,
          password: _password,
        );
        print('Signed in: ${res.user?.uid}');

        setState(() {
          _isLoading = false;
        });
      } catch (e) {
        print('Error: $e');
        setState(() {
          _isLoading = false;
          _errorMessage = '$e';
          _formKey.currentState!.reset();
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(title: new Text('Sharezone Admin Login')),
      body: Stack(children: <Widget>[_showForm(), _showCircularProgress()]),
    );
  }

  Widget _showCircularProgress() {
    if (_isLoading) {
      return Center(child: CircularProgressIndicator());
    }
    return Container();
  }

  Widget _showForm() {
    return new Container(
      padding: EdgeInsets.all(16.0),
      child: new Form(
        key: _formKey,
        child: AutofillGroup(
          child: new ListView(
            shrinkWrap: true,
            children: <Widget>[
              showLogo(),
              showEmailInput(),
              showPasswordInput(),
              showPrimaryButton(),
              showErrorMessage(),
            ],
          ),
        ),
      ),
    );
  }

  Widget showErrorMessage() {
    if (_errorMessage != null && _errorMessage!.length > 0) {
      return new Text(
        _errorMessage!,
        style: TextStyle(
          fontSize: 13.0,
          color: Colors.red,
          height: 1.0,
          fontWeight: FontWeight.w300,
        ),
      );
    } else {
      return new Container();
    }
  }

  Widget showLogo() {
    return new Hero(
      tag: 'hero',
      child: Padding(
        padding: EdgeInsets.fromLTRB(0.0, 20.0, 0.0, 0.0),
        child: CircleAvatar(
          backgroundColor: Colors.transparent,
          radius: 100.0,
          child: Image.asset(
            'assets/login_image.png',
            scale: 0.5,
            fit: BoxFit.scaleDown,
          ),
        ),
      ),
    );
  }

  Widget showEmailInput() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 0.0),
      child: new TextFormField(
        maxLines: 1,
        keyboardType: TextInputType.emailAddress,
        autofillHints: [AutofillHints.email],
        autofocus: false,
        decoration: new InputDecoration(
          hintText: 'E-Mail',
          icon: new Icon(Icons.mail, color: Colors.grey),
        ),
        validator: (value) => value!.isEmpty ? 'Email can\'t be empty' : null,
        onSaved: (value) => _email = value!.trim(),
      ),
    );
  }

  Widget showPasswordInput() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 0.0),
      child: new TextFormField(
        maxLines: 1,
        obscureText: true,
        autofocus: false,
        autofillHints: [AutofillHints.password],
        decoration: new InputDecoration(
          hintText: 'Passwort',
          icon: new Icon(Icons.lock, color: Colors.grey),
        ),
        validator: (value) =>
            value!.isEmpty ? 'Password can\'t be empty' : null,
        onSaved: (value) => _password = value!.trim(),
      ),
    );
  }

  Widget showPrimaryButton() {
    return new Padding(
      padding: EdgeInsets.fromLTRB(0.0, 45.0, 0.0, 0.0),
      child: SizedBox(
        height: 40.0,
        child: new ElevatedButton(
          child: new Text('Einloggen', style: TextStyle(color: Colors.white)),
          onPressed: validateAndSubmit,
        ),
      ),
    );
  }
}
