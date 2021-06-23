import 'package:flutter/material.dart';

class RowSpacing extends StatelessWidget {
  const RowSpacing({
    Key key,
    this.children,
    this.spacing,
    this.mainAxisAlignment = MainAxisAlignment.start,
  }) : super(key: key);

  final List<Widget> children;
  final double spacing;

  final MainAxisAlignment mainAxisAlignment;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: mainAxisAlignment,
      children: _buildList(),
    );
  }

  List<Widget> _buildList() {
    final _list = <Widget>[];
    for (int i = 0; i < children.length; i++) {
      _list.add(children[i]);
      if (i + 1 != children.length) {
        _list.add(SizedBox(width: spacing));
      }
    }
    return _list;
  }
}
