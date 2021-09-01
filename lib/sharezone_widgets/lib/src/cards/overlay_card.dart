import 'package:flutter/material.dart';
import 'package:sharezone_widgets/theme.dart';

class OverlayCard extends StatelessWidget {
  final Widget title;
  final Widget content;

  final VoidCallback onClose;

  final String actionText;
  final VoidCallback onAction;

  const OverlayCard({
    Key key,
    this.title,
    this.content,
    this.onClose,
    this.actionText,
    this.onAction,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Align(
        alignment: Alignment.bottomRight,
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: 400),
          child: Material(
            elevation: 10,
            color: isDarkThemeEnabled(context)
                ? ElevationColors.dp4
                : Colors.white,
            shadowColor: Colors.black.withOpacity(0.6),
            borderRadius: BorderRadius.circular(10),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (title != null) _Title(title: title),
                  const SizedBox(height: 8),
                  if (content != null) _Content(content: content),
                  const SizedBox(height: 14),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Wrap(
                      alignment: WrapAlignment.end,
                      children: [
                        _Close(onClose: onClose),
                        const SizedBox(width: 8),
                        if (actionText != null)
                          _Action(onAction: onAction, actionText: actionText),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _Action extends StatelessWidget {
  const _Action({
    Key key,
    @required this.onAction,
    @required this.actionText,
  }) : super(key: key);

  final VoidCallback onAction;
  final String actionText;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: actionText,
      button: true,
      enabled: true,
      onTap: onAction,
      child: TextButton(
        onPressed: onAction,
        child: Text(actionText),
        style: TextButton.styleFrom(
          primary: Theme.of(context).primaryColor,
          backgroundColor: Theme.of(context).primaryColor.withOpacity(0.15),
        ),
      ),
    );
  }
}

class _Close extends StatelessWidget {
  const _Close({Key key, @required this.onClose}) : super(key: key);

  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'Schließe die Karte',
      button: true,
      enabled: true,
      onTap: onClose,
      child: TextButton(
        onPressed: onClose,
        child: const Text("SCHLIESSEN"),
        style: TextButton.styleFrom(
          primary: Colors.grey,
        ),
      ),
    );
  }
}

class _Content extends StatelessWidget {
  const _Content({Key key, @required this.content}) : super(key: key);

  final Widget content;

  @override
  Widget build(BuildContext context) {
    return DefaultTextStyle(
      style: const TextStyle(
        color: Colors.grey,
        fontFamily: rubik,
      ),
      child: content,
    );
  }
}

class _Title extends StatelessWidget {
  const _Title({Key key, @required this.title}) : super(key: key);

  final Widget title;

  @override
  Widget build(BuildContext context) {
    return DefaultTextStyle(
      style: TextStyle(
        fontSize: 18,
        fontFamily: rubik,
        color: isDarkThemeEnabled(context) ? Colors.white : Colors.black,
        fontWeight: FontWeight.w600,
      ),
      child: title,
    );
  }
}
