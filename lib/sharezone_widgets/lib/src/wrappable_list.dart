import 'package:flutter/material.dart';

class WrappableList extends StatelessWidget {
  final List<Widget> children;
  final double minWidth;
  final int maxElementsPerSection;

  const WrappableList({
    Key key,
    @required this.children,
    @required this.minWidth,
    this.maxElementsPerSection = 2,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final layoutWidth = constraints.maxWidth;
        final double widgetWidth =
            _getOptimalWidth(layoutWidth, children.length);
        return Wrap(
          children: children.map((widget) {
            return ConstrainedBox(
              constraints: BoxConstraints(maxWidth: widgetWidth),
              child: widget,
            );
          }).toList(),
        );
      },
    );
  }

  double _getOptimalWidth(double layoutWidth, int totalElements) {
    var endAmount = totalElements < maxElementsPerSection
        ? totalElements
        : maxElementsPerSection;

    while (_getWidthPerElement(layoutWidth, endAmount) < minWidth &&
        endAmount != 1) {
      endAmount--;
    }
    return layoutWidth / endAmount;
  }
}

double _getWidthPerElement(double layoutWidth, int amountOfElements) {
  return layoutWidth / amountOfElements;
}
