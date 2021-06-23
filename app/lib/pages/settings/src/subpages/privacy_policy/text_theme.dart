part of 'privacy_policy.dart';

class _Title extends StatelessWidget {
  const _Title(this.title, {Key key}) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) {
    return SelectableText(title, style: TextStyle(fontSize: 22));
  }
}

class _Subtitle extends StatelessWidget {
  const _Subtitle(this.subtitle, {Key key}) : super(key: key);

  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return SelectableText(subtitle, style: TextStyle(fontWeight: FontWeight.w500));
  }
}
