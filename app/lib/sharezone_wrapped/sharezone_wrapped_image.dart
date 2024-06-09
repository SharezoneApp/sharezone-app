import 'package:flutter/material.dart';
import 'package:sharezone/sharezone_wrapped/sharezone_wrapped_view.dart';

class SharezoneWrappedImage extends StatelessWidget {
  const SharezoneWrappedImage({
    super.key,
    required this.view,
  });

  final SharezoneWrappedView view;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 9 / 16,
      child: Material(
        color: Colors.blue,
      ),
    );
  }
}
