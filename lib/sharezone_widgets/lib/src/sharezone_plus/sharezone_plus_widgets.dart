import 'package:flutter/material.dart';
import 'package:sharezone_widgets/sharezone_widgets.dart';

class SharezonePlusBadge extends StatelessWidget {
  const SharezonePlusBadge({super.key});

  @override
  Widget build(BuildContext context) {
    return const Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          Icons.star_rounded,
          color: darkBlueColor,
        ),
        SizedBox(width: 6),
        Text(
          'PLUS',
          style: TextStyle(
            fontWeight: FontWeight.w500,
            color: darkBlueColor,
            letterSpacing: 0.5,
          ),
        )
      ],
    );
  }
}

class SharezonePlusCard extends StatelessWidget {
  const SharezonePlusCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor.withOpacity(0.2),
        borderRadius: BorderRadius.circular(7.5),
      ),
      child: const Padding(
        padding: EdgeInsets.fromLTRB(8, 4, 10, 4),
        child: SharezonePlusBadge(),
      ),
    );
  }
}
