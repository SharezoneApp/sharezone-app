import 'package:flutter/material.dart';
import 'package:sharezone_widgets/theme.dart';

class FilePageAppBar extends StatelessWidget implements PreferredSizeWidget {
  const FilePageAppBar({
    Key key,
    this.actions,
    @required this.name,
    this.nameStream,
  }) : super(key: key);

  final String name;
  final Stream<String> nameStream;
  final List<Widget> actions;

  @override
  Size get preferredSize => Size.fromHeight(56);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: nameStream != null
          ? StreamBuilder<String>(
              initialData: name,
              stream: nameStream,
              builder: (context, snapshot) {
                final name = snapshot.data;
                return _Title(name: name);
              },
            )
          : _Title(name: name),
      centerTitle: true,
      iconTheme: IconThemeData(color: Colors.white60),
      backgroundColor: Colors.black,
      actions: actions,
    );
  }
}

class _Title extends StatelessWidget {
  const _Title({Key key, @required this.name}) : super(key: key);

  final String name;

  @override
  Widget build(BuildContext context) {
    return Text(
      name,
      style: TextStyle(color: Colors.white, fontFamily: rubik),
    );
  }
}
