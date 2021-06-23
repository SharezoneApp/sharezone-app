import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class PlatformSvg {
  static const isSkiaEnabled =
      bool.fromEnvironment('FLUTTER_WEB_USE_SKIA', defaultValue: false);

  // Das SVG-Package unterstützt aktuell keine SVG-Grafiken mit DomCanvas (der
  // normale Renderer von Flutter). Ein Workaroudn ist, dass Image.network
  // verwendet wird. Damit können auch SVG-Grafiken mit DomCanvas angezeigt
  // werden. Wird jedoch Skia / CanvasKit verwendet, funktioniert dieser
  // Workaround nicht mehr. Dort kann einfach das normale SVG-Package verwendet
  // werden.\
  // Ticket: https://github.com/dnfield/flutter_svg/issues/173
  static const shouldUseSvgFallback = kIsWeb && !isSkiaEnabled;

  static Widget asset(
    String assetName, {
    double width,
    double height,
    BoxFit fit = BoxFit.contain,
    Color color,
    alignment = Alignment.center,
    String semanticsLabel,
  }) {
    if (shouldUseSvgFallback) {
      return Image.network(
        "/assets/$assetName",
        width: width,
        height: height,
        fit: fit,
        color: color,
        alignment: alignment,
        semanticLabel: semanticsLabel,
      );
    }
    return SvgPicture.asset(
      assetName,
      width: width,
      height: height,
      fit: fit,
      color: color,
      alignment: alignment,
      semanticsLabel: semanticsLabel,
    );
  }

  static Widget network(
    String url, {
    double width,
    double height,
    BoxFit fit = BoxFit.contain,
    Color color,
    alignment = Alignment.center,
    String semanticsLabel,
  }) {
    if (shouldUseSvgFallback) {
      return Image.network(
        url,
        width: width,
        height: height,
        fit: fit,
        color: color,
        alignment: alignment,
        semanticLabel: semanticsLabel,
      );
    }
    return SvgPicture.network(
      url,
      width: width,
      height: height,
      fit: fit,
      color: color,
      alignment: alignment,
      semanticsLabel: semanticsLabel,
    );
  }
}
