import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class CheckTile extends StatelessWidget {
  const CheckTile({
    Key? key,
    this.title,
    this.subtitle,
  }) : super(key: key);

  final String? title;
  final String? subtitle;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SvgPicture.asset(
          "assets/icons/correct.svg",
          height: 30,
        ),
        const SizedBox(width: 18),
        Flexible(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SelectableText(
                title!,
                style: TextStyle(fontSize: 20),
              ),
              if (subtitle != null)
                SelectableText(
                  subtitle!,
                  style: TextStyle(color: Colors.grey, fontSize: 16),
                ),
            ],
          ),
        ),
      ],
    );
  }
}
