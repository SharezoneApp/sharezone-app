import 'package:flutter/material.dart';

class CustomCard extends StatelessWidget {
  const CustomCard(
      {@required this.child,
      this.size,
      this.onTap,
      this.margin,
      this.opacity,
      this.padding = const EdgeInsets.all(0),
      this.blurRadius = 5,
      this.shadowColor = Colors.grey,
      this.offset = const Offset(0.0, 0.0),
      this.color,
      this.borderRadius = const BorderRadius.all(Radius.circular(10)),
      this.onLongPress,
      this.withBorder = true,
      this.borderWidth = 1});

  const CustomCard.roundVertical(
      {@required this.child,
      this.onTap,
      this.size,
      this.margin,
      this.opacity,
      this.padding = const EdgeInsets.all(0),
      this.blurRadius = 5,
      this.borderRadius = const BorderRadius.vertical(
          top: Radius.circular(500), bottom: Radius.circular(500)),
      this.shadowColor = Colors.grey,
      this.offset = const Offset(0.0, 0.0),
      this.color,
      this.onLongPress,
      this.withBorder = false,
      this.borderWidth = 1});

  final Widget child;
  final VoidCallback onTap;
  final VoidCallback onLongPress;
  final Size size;
  final Padding margin;
  final double opacity;
  final EdgeInsetsGeometry padding;
  final double blurRadius;
  final BorderRadius borderRadius;
  final double borderWidth;
  final Color shadowColor;
  final Offset offset;
  final Color color;
  final bool withBorder;

  @override
  Widget build(BuildContext context) {
    final color = this.color ?? Theme.of(context).cardColor;
    return SafeArea(
      left: true,
      right: true,
      bottom: false,
      top: false,
      child: ClipRRect(
        borderRadius: borderRadius,
        child: Padding(
          padding: margin as EdgeInsetsGeometry ?? const EdgeInsets.all(0.0),
          child: Opacity(
            opacity: opacity ?? 1,
            child: Container(
              width: size?.height,
              height: size?.width,
              decoration: BoxDecoration(
                color: color,
                borderRadius: borderRadius,
                // border: Border.all(color: isDarkThemeEnabled(context) ? Colors.grey[800] : Colors.grey[300]),
                border: withBorder
                    ? Border.all(color: Colors.grey[300], width: borderWidth)
                    : null,
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: borderRadius,
                  onTap: onTap,
                  onLongPress: onLongPress,
                  child: Padding(
                    padding: padding,
                    child: child,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
