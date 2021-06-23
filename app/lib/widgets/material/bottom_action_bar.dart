import 'package:flutter/material.dart';
import 'package:sharezone_widgets/wrapper.dart';

/// Is a bar in the bottom navigation bar slot in the
/// scaffold. Is used for homework-details, to show a FlatButton
/// at the bottom to mark the homework as done.
class BottomActionBar extends StatelessWidget {
  const BottomActionBar({
    Key key,
    @required this.title,
    @required this.onTap,
  })  : assert(title != null || onTap != null),
        super(key: key);

  final String title;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: Material(
        color: Theme.of(context).scaffoldBackgroundColor,
        child: SafeArea(
          bottom: true,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              const Divider(height: 0),
              MaxWidthConstraintBox(
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: FlatButton(
                      onPressed: onTap,
                      textColor: Theme.of(context).primaryColor,
                      child: Text(title.toUpperCase()),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
