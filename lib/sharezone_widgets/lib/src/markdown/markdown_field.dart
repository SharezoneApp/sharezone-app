import 'package:flutter/material.dart';
import 'package:sharezone_widgets/sharezone_widgets.dart';

class MarkdownField extends StatefulWidget {
  const MarkdownField({
    super.key,
    required this.onChanged,
    this.prefilledText,
    this.inputDecoration,
    this.icon,
    this.focusNode,
  });

  final Function(String) onChanged;
  final String? prefilledText;
  final InputDecoration? inputDecoration;
  final Widget? icon;
  final FocusNode? focusNode;

  @override
  State<MarkdownField> createState() => MarkdownFieldState();
}

class MarkdownFieldState extends State<MarkdownField> {
  bool isFocused = false;
  late FocusNode focusNode;
  late TextEditingController controller;

  @override
  void initState() {
    super.initState();
    focusNode = widget.focusNode ?? FocusNode();
    focusNode.addListener(onFocusChange);
  }

  @override
  void dispose() {
    focusNode.removeListener(onFocusChange);
    focusNode.dispose();
    super.dispose();
  }

  void onFocusChange() {
    setState(() {
      isFocused = focusNode.hasFocus;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaxWidthConstraintBox(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          ListTile(
            leading: widget.icon,
            title: PrefilledTextField(
              prefilledText: widget.prefilledText,
              focusNode: focusNode,
              maxLines: null,
              scrollPadding: const EdgeInsets.all(16.0),
              keyboardType: TextInputType.multiline,
              decoration: widget.inputDecoration,
              onChanged: widget.onChanged,
              textCapitalization: TextCapitalization.sentences,
              textInputAction: TextInputAction.newline,
            ),
          ),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 250),
            transitionBuilder: (child, animation) {
              return FadeTransition(
                opacity: animation,
                child: SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(0, -0.1),
                    end: Offset.zero,
                  ).animate(animation),
                  child: child,
                ),
              );
            },
            child: isFocused
                ? Padding(
                    key: ValueKey(isFocused),
                    padding: const EdgeInsets.fromLTRB(50, 0, 16, 12),
                    child: const MarkdownSupport(),
                  )
                : SizedBox(key: ValueKey(isFocused)),
          ),
        ],
      ),
    );
  }
}
