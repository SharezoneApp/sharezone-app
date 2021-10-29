import 'package:flutter/material.dart';

class ColumnSpacing extends StatelessWidget {
  const ColumnSpacing({
    Key? key,
    this.children,
    this.spacing,
    this.crossAxisAlignment = CrossAxisAlignment.center,
  }) : super(key: key);

  final List<Widget>? children;
  final double? spacing;
  final CrossAxisAlignment crossAxisAlignment;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: crossAxisAlignment,
      children: _buildList(),
    );
  }

  List<Widget> _buildList() {
    final _list = <Widget>[];
    for (int i = 0; i < children!.length; i++) {
      _list.add(children![i]);
      if (i + 1 != children!.length) {
        _list.add(SizedBox(height: spacing));
      }
    }
    return _list;
  }
}
