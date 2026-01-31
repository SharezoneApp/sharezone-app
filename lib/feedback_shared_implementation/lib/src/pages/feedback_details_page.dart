// Copyright (c) 2024 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:build_context/build_context.dart';
import 'package:feedback_shared_implementation/src/models/feedback_id.dart';
import 'package:feedback_shared_implementation/src/pages/feedback_details_page_controller.dart';
import 'package:feedback_shared_implementation/src/pages/feedback_details_page_controller_factory.dart';
import 'package:feedback_shared_implementation/src/pages/feedback_icons.dart';
import 'package:feedback_shared_implementation/src/pages/feedback_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:provider/provider.dart';
import 'package:sharezone_localizations/sharezone_localizations.dart';
import 'package:sharezone_widgets/sharezone_widgets.dart';

class FeedbackDetailsPage extends StatefulWidget {
  const FeedbackDetailsPage({
    super.key,
    required this.feedbackId,
    required this.onContactSupportPressed,
    this.showDeviceInformation = false,
  });

  final FeedbackId feedbackId;
  final VoidCallback? onContactSupportPressed;
  final bool showDeviceInformation;

  static const tag = 'feedback-details-page';

  @override
  State<FeedbackDetailsPage> createState() => _FeedbackDetailsPageState();
}

class _FeedbackDetailsPageState extends State<FeedbackDetailsPage> {
  late FeedbackDetailsPageController controller;
  late ScrollController scrollController;

  @override
  void initState() {
    super.initState();

    controller = context.read<FeedbackDetailsPageControllerFactory>().create(
      widget.feedbackId,
    );
    scrollController = ScrollController();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.init();
    });
  }

  void _scrollToBottom() {
    scrollController.animateTo(
      scrollController.position.maxScrollExtent,
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    // For some reason, the controller is not disposed automatically  when the
    // page is popped.
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: controller,
      child: Scaffold(
        appBar: AppBar(title: Text(context.l10n.feedbackDetailsPageTitle)),
        body: SingleChildScrollView(
          controller: scrollController,
          child: SafeArea(
            child: MaxWidthConstraintBox(
              child: _FeedbackTiles(
                onContactSupportPressed: widget.onContactSupportPressed,
                showDeviceInformation: widget.showDeviceInformation,
              ),
            ),
          ),
        ),
        bottomNavigationBar: _WriteResponseField(
          scrollToBottom: () => _scrollToBottom(),
        ),
      ),
    );
  }
}

class _FeedbackTiles extends StatelessWidget {
  const _FeedbackTiles({
    required this.onContactSupportPressed,
    required this.showDeviceInformation,
  });

  final VoidCallback? onContactSupportPressed;
  final bool showDeviceInformation;

  @override
  Widget build(BuildContext context) {
    final state = context.watch<FeedbackDetailsPageController>().state;
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 250),
      child: switch (state) {
        FeedbackDetailsPageError() => _Error(
          state: state,
          onContactSupportPressed: onContactSupportPressed,
        ),
        FeedbackDetailsPageLoading() => const _Loading(),
        FeedbackDetailsPageLoaded() => _Items(
          feedback: state.feedback,
          messages: state.chatMessages,
          showDeviceInformation: showDeviceInformation,
        ),
      },
    );
  }
}

class _Loading extends StatelessWidget {
  const _Loading();

  @override
  Widget build(BuildContext context) {
    return _Items(
      feedback: FeedbackView(
        id: const FeedbackId('1'),
        createdOn: '2022-01-01',
        rating: '5',
        likes: '10',
        dislikes: '2',
        missing: context.l10n.feedbackDetailsLoadingMissing,
        heardFrom: context.l10n.feedbackDetailsLoadingHeardFrom,
        lastMessage: null,
        hasUnreadMessages: null,
      ),
      showDeviceInformation: false,
      messages: null,
    );
  }
}

class _Error extends StatelessWidget {
  const _Error({required this.state, required this.onContactSupportPressed});

  final FeedbackDetailsPageError state;
  final VoidCallback? onContactSupportPressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: ErrorCard(
        message: Text(state.message),
        onContactSupportPressed: onContactSupportPressed,
      ),
    );
  }
}

class _Items extends StatelessWidget {
  const _Items({
    required this.feedback,
    required this.messages,
    required this.showDeviceInformation,
  });

  final FeedbackView? feedback;
  final List<FeedbackMessageView>? messages;
  final bool showDeviceInformation;

  @override
  Widget build(BuildContext context) {
    final feedback = this.feedback;
    if (feedback == null) {
      return const SizedBox();
    }
    return Column(
      children: [
        if (feedback.hasCreatedOn) _CreatedOn(createdOn: feedback.createdOn!),
        if (feedback.hasRating) _Rating(rating: feedback.rating!),
        if (feedback.hasLikes) _Likes(likes: feedback.likes!),
        if (feedback.hasDislikes) _Dislikes(dislikes: feedback.dislikes!),
        if (feedback.hasMissing) _Missing(missing: feedback.missing!),
        if (feedback.hasHeardFrom) _HeardFrom(heardFrom: feedback.heardFrom!),
        if (feedback.hasDeviceInformation && showDeviceInformation)
          _DeviceInformation(deviceInformation: feedback.deviceInformation!),
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 250),
          child: messages != null ? _Messages(messages) : null,
        ),
      ],
    );
  }
}

class _Messages extends StatelessWidget {
  const _Messages(this.messages);

  final List<FeedbackMessageView>? messages;

  @override
  Widget build(BuildContext context) {
    if (messages == null) {
      return const SizedBox();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Divider(),
        Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                context.l10n.feedbackDetailsCommentsTitle,
                style: const TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 12),
              for (final message in messages!)
                if (message.isMyMessage)
                  _MyChatBubble(message)
                else
                  _SupportTeamChatBubble(message),
            ],
          ),
        ),
      ],
    );
  }
}

class _MyChatBubble extends StatelessWidget {
  const _MyChatBubble(this.view);

  final FeedbackMessageView view;

  @override
  Widget build(BuildContext context) {
    return _ChatBubble(
      text: view.message,
      backgroundColor: Theme.of(
        context,
      ).colorScheme.primary.withValues(alpha: 0.2),
      alignment: Alignment.centerRight,
      sentAt: view.sentAt,
    );
  }
}

class _SupportTeamChatBubble extends StatelessWidget {
  const _SupportTeamChatBubble(this.view);

  final FeedbackMessageView view;

  @override
  Widget build(BuildContext context) {
    final color =
        context.isDarkThemeEnabled ? Colors.grey[800]! : Colors.grey[300]!;
    return _ChatBubble(
      text: view.message,
      backgroundColor: color,
      alignment: Alignment.centerLeft,
      sentAt: view.sentAt,
    );
  }
}

class _WriteResponseField extends StatefulWidget {
  const _WriteResponseField({required this.scrollToBottom});

  final VoidCallback scrollToBottom;

  @override
  State<_WriteResponseField> createState() => _WriteResponseFieldState();
}

class _WriteResponseFieldState extends State<_WriteResponseField> {
  String? message;
  late TextEditingController? textEditingController;
  late FocusNode focusNode;
  bool get isMessageValid => message != null && message!.isNotEmpty;

  @override
  void initState() {
    super.initState();
    textEditingController = TextEditingController();
    focusNode = FocusNode(
      onKeyEvent: (node, event) {
        final pressedKeys = HardwareKeyboard.instance.physicalKeysPressed;
        final isShiftLeftPressed = pressedKeys.contains(
          PhysicalKeyboardKey.shiftLeft,
        );
        final isShiftRightPressed = pressedKeys.contains(
          PhysicalKeyboardKey.shiftRight,
        );
        final enterPressedWithoutShift =
            event is KeyDownEvent &&
            event.physicalKey == PhysicalKeyboardKey.enter &&
            !isShiftLeftPressed &&
            !isShiftRightPressed;

        if (enterPressedWithoutShift) {
          sendMessage();
          return KeyEventResult.handled;
        }

        if (event is KeyRepeatEvent) {
          // Disable holding enter
          return KeyEventResult.handled;
        }

        return KeyEventResult.ignored;
      },
    );

    focusNode.addListener(() async {
      if (focusNode.hasFocus) {
        await waitForKeyboardOpen();
        widget.scrollToBottom();
      }
    });
  }

  Future<void> waitForKeyboardOpen() async {
    await Future.delayed(const Duration(milliseconds: 375));
  }

  @override
  void dispose() {
    textEditingController?.dispose();
    focusNode.dispose();
    super.dispose();
  }

  Future<void> sendMessage() async {
    if (!isMessageValid) return;

    try {
      final controller = context.read<FeedbackDetailsPageController>();
      controller.sendResponse(message!);
      setState(() => message = null);
      textEditingController?.clear();
      // Wait a moment to make sure the message is visible in the UI so that we
      // can so that we can scroll to the message.
      await Future.delayed(const Duration(milliseconds: 100));
      widget.scrollToBottom();
    } on Exception catch (e) {
      if (!mounted) return;
      showSnackSec(
        context: context,
        text: context.l10n.feedbackDetailsSendError('$e'),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Divider(height: 0),
        SafeArea(
          child: MaxWidthConstraintBox(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: ConstrainedBox(
                          constraints: BoxConstraints(
                            maxHeight: MediaQuery.of(context).size.height * 0.3,
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              TextField(
                                controller: textEditingController,
                                decoration: InputDecoration(
                                  hintText:
                                      context.l10n.feedbackDetailsResponseHint,
                                ),
                                focusNode: focusNode,
                                onChanged: (value) {
                                  setState(() => message = value);
                                },
                                textInputAction: TextInputAction.newline,
                                textCapitalization:
                                    TextCapitalization.sentences,
                                maxLines: null,
                              ),
                              if (context.isDesktopModus) const _NewLineHint(),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      _SendMessageButton(
                        onPressed: isMessageValid ? () => sendMessage() : null,
                      ),
                    ],
                  ),
                  SizedBox(height: MediaQuery.of(context).viewInsets.bottom),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _SendMessageButton extends StatelessWidget {
  const _SendMessageButton({required this.onPressed});

  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final isEnabled = onPressed != null;
    return Padding(
      padding: const EdgeInsets.only(top: 12),
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 350),
        child: IconButton.filled(
          key: ValueKey(isEnabled),
          tooltip: context.l10n.feedbackSendTooltip,
          icon: const Icon(Icons.send),
          onPressed: isEnabled ? () => onPressed!() : null,
        ),
      ),
    );
  }
}

class _NewLineHint extends StatelessWidget {
  const _NewLineHint();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 4),
      child: Text(
        context.l10n.feedbackNewLineHint,
        style: TextStyle(
          fontSize: 11,
          color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5),
        ),
      ),
    );
  }
}

class _ChatBubble extends StatelessWidget {
  const _ChatBubble({
    required this.text,
    required this.backgroundColor,
    required this.alignment,
    required this.sentAt,
  });

  final String text;
  final Color backgroundColor;
  final Alignment alignment;
  final String sentAt;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: alignment,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 400),
        child: Padding(
          padding: const EdgeInsets.only(bottom: 4),
          child: Container(
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: BorderRadius.only(
                topLeft: const Radius.circular(12),
                topRight: const Radius.circular(12),
                bottomLeft:
                    alignment == Alignment.centerRight
                        ? const Radius.circular(12)
                        : const Radius.circular(0),
                bottomRight:
                    alignment == Alignment.centerLeft
                        ? const Radius.circular(12)
                        : const Radius.circular(0),
              ),
            ),
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment:
                  alignment == Alignment.centerRight
                      ? CrossAxisAlignment.end
                      : CrossAxisAlignment.start,
              children: [
                MarkdownBody(data: text, selectable: true, softLineBreak: true),
                const SizedBox(height: 4),
                Text(
                  sentAt,
                  style: TextStyle(
                    fontSize: 10,
                    color: Theme.of(
                      context,
                    ).colorScheme.onSurface.withValues(alpha: 0.5),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _DeviceInformation extends StatelessWidget {
  const _DeviceInformation({required this.deviceInformation});

  final String deviceInformation;

  @override
  Widget build(BuildContext context) {
    return _FeedbackTile(
      leading: const Icon(Icons.phone_android),
      title: Text(deviceInformation),
    );
  }
}

class _CreatedOn extends StatelessWidget {
  const _CreatedOn({required this.createdOn});

  final String createdOn;

  @override
  Widget build(BuildContext context) {
    return _FeedbackTile(
      leading: const Icon(Icons.today),
      title: Text(createdOn),
    );
  }
}

class _Rating extends StatelessWidget {
  const _Rating({required this.rating});

  final String rating;

  @override
  Widget build(BuildContext context) {
    return _FeedbackTile(
      leading: const FeedbackRatingIcon(),
      title: Text(rating),
    );
  }
}

class _Likes extends StatelessWidget {
  const _Likes({required this.likes});

  final String likes;

  @override
  Widget build(BuildContext context) {
    return _FeedbackTile(
      leading: const FeedbackLikesIcon(),
      title: Text(likes),
    );
  }
}

class _Dislikes extends StatelessWidget {
  const _Dislikes({required this.dislikes});

  final String dislikes;

  @override
  Widget build(BuildContext context) {
    return _FeedbackTile(
      leading: const FeedbackDislikesIcon(),
      title: Text(dislikes),
    );
  }
}

class _Missing extends StatelessWidget {
  const _Missing({required this.missing});

  final String missing;

  @override
  Widget build(BuildContext context) {
    return _FeedbackTile(
      leading: const FeedbackMissingIcon(),
      title: Text(missing),
    );
  }
}

class _HeardFrom extends StatelessWidget {
  const _HeardFrom({required this.heardFrom});

  final String heardFrom;

  @override
  Widget build(BuildContext context) {
    return _FeedbackTile(
      leading: const FeedbackHeardFromIcon(),
      title: Text(heardFrom),
    );
  }
}

class _FeedbackTile extends StatelessWidget {
  const _FeedbackTile({required this.title, this.leading});

  final Widget? leading;
  final Widget title;

  @override
  Widget build(BuildContext context) {
    final isLoading = context.select<FeedbackDetailsPageController, bool>(
      (c) => c.state is FeedbackDetailsPageLoading,
    );
    return GrayShimmer(
      enabled: isLoading,
      child: ListTile(
        leading: leading,
        title:
            isLoading
                ? Container(
                  height: 20,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(5),
                  ),
                )
                : title,
      ),
    );
  }
}
