import 'package:flutter/material.dart';
import 'package:sharezone_widgets/theme.dart';

class FileSharingHeadline extends StatelessWidget {
  const FileSharingHeadline({Key key, this.title}) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 6, top: 4, bottom: 12),
      child: Text(
        title,
        style: TextStyle(
            color: isDarkThemeEnabled(context)
                ? Colors.grey[400]
                : Colors.grey[700],
            fontWeight: FontWeight.w600),
      ),
    );
  }
}
