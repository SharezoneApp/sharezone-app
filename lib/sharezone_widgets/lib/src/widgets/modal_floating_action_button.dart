import 'package:flutter/material.dart';
import 'package:sharezone_utils/dimensions.dart';

class ModalFloatingActionButton extends StatelessWidget {
  final VoidCallback onPressed;
  final Icon icon;
  final Color backgroundColor;
  final String tooltip;
  final String heroTag;
  final String label;

  const ModalFloatingActionButton({
    Key key,
    @required this.onPressed,
    @required this.icon,
    this.backgroundColor,
    @required this.tooltip,
    this.label,
    this.heroTag,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final dimensions = Dimensions.fromMediaQuery(context);
    return Semantics(
      child: dimensions.isDesktopModus
          ? FloatingActionButton.extended(
              backgroundColor: backgroundColor,
              label: Text(label ?? tooltip),
              icon: icon,
              onPressed: onPressed,
              heroTag: heroTag,
            )
          : FloatingActionButton(
              onPressed: onPressed,
              backgroundColor: backgroundColor,
              child: icon,
              heroTag: heroTag,
              tooltip: tooltip,
            ),
      label: tooltip,
      button: true,
    );
  }
}
