import 'package:flutter/material.dart';
import 'package:sharezone_widgets/sharezone_widgets.dart';

class SharezonePlusPageCtaButton extends StatelessWidget {
  const SharezonePlusPageCtaButton({
    required this.text,
    this.onPressed,
    this.backgroundColor,
  }) : super(key: const ValueKey('call-to-action-button'));

  final Widget text;
  final VoidCallback? onPressed;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    return MaxWidthConstraintBox(
      maxWidth: 300,
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: backgroundColor,
            textStyle: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w500,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.5),
            ),
            foregroundColor: Colors.white,
            shadowColor: Colors.transparent,
            elevation: 0,
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            child: text,
          ),
        ),
      ),
    );
  }
}
