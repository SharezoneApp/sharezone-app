// Copyright (c) 2024 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:flutter/material.dart';

class TextFieldLabeled extends StatefulWidget {
  const TextFieldLabeled({
    Key? key,
    this.label,
    this.autofocus = false,
    this.onEditingComplete,
    this.onChanged,
    this.textInputAction,
    this.decoration,
    this.maxLength,
    this.focusNode,
    this.maxLines = 1,
    this.style,
    this.cursorColor,
    this.keyboardType,
    this.scrollPadding = const EdgeInsets.all(20.0),
    this.autofillHints,
  }) : super(key: key);

  final String? label;
  final bool autofocus;
  final FocusNode? focusNode;
  final VoidCallback? onEditingComplete;
  final ValueChanged<String>? onChanged;
  final TextInputAction? textInputAction;
  final InputDecoration? decoration;
  final int? maxLength;
  final int maxLines;
  final TextStyle? style;
  final Color? cursorColor;
  final TextInputType? keyboardType;
  final EdgeInsets scrollPadding;
  final Iterable<String>? autofillHints;

  @override
  _TextFieldLabeledState createState() => _TextFieldLabeledState();
}

class _TextFieldLabeledState extends State<TextFieldLabeled> {
  TextEditingController? controller;

  @override
  void initState() {
    super.initState();
    controller = TextEditingController(text: widget.label);
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      autofocus: widget.autofocus,
      onEditingComplete: widget.onEditingComplete,
      textInputAction: widget.textInputAction,
      decoration: widget.decoration,
      onChanged: widget.onChanged,
      maxLength: widget.maxLength,
      maxLines: widget.maxLines,
      autofillHints: widget.autofillHints,
      focusNode: widget.focusNode,
      style: widget.style,
      keyboardType: widget.keyboardType,
      cursorColor: widget.cursorColor,
      scrollPadding: widget.scrollPadding,
    );
  }
}
