import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class CheckTile extends StatelessWidget {
  const CheckTile({
    super.key,
    this.title,
    this.subtitle,
  });

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
              Text(
                title!,
                style: const TextStyle(fontSize: 20),
              ),
              if (subtitle != null)
                Text(
                  subtitle!,
                  style: const TextStyle(color: Colors.grey, fontSize: 16),
                ),
            ],
          ),
        ),
      ],
    );
  }
}
