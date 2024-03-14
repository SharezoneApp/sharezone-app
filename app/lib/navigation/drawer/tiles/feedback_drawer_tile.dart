import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sharezone/feedback/unread_messages/has_unread_feedback_messages_provider.dart';
import 'package:sharezone/navigation/drawer/tiles/drawer_tile.dart';
import 'package:sharezone/navigation/models/navigation_item.dart';
import 'package:sharezone_widgets/sharezone_widgets.dart';

class FeedbackDrawerTile extends StatelessWidget {
  const FeedbackDrawerTile({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<HasUnreadFeedbackMessagesProvider>();
    return DrawerTile(
      NavigationItem.feedbackBox,
      trailing: AnimatedSwap(
        duration: const Duration(milliseconds: 350),
        child: state.hasUnreadFeedbackMessages
            ? const Icon(Icons.brightness_1, size: 13)
            : const SizedBox.shrink(),
      ),
    );
  }
}
