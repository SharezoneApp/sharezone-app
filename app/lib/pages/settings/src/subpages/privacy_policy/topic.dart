part of 'privacy_policy.dart';

class _Topic extends StatelessWidget {
  const _Topic({Key key, @required this.title, @required this.texts})
      : super(key: key);

  final Widget title;
  final List<Widget> texts;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[title, ...texts, SizedBox(height: 20)],
    );
  }
}
