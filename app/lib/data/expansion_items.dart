import 'package:flutter/material.dart';

class NewExpansionItem {
  bool isExpanded;
  final String header;
  final Widget body;
  final Icon iconpic;

  NewExpansionItem(this.isExpanded, this.header, this.body, this.iconpic);
}
