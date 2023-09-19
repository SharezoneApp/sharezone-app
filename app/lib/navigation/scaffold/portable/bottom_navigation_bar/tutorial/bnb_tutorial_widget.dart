// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

part of '../extendable_bottom_navigation_bar.dart';

/// A tutorial to show how the [ExtendableBottomNavigationBar] works. To display
/// the BNB it uses the real BNB widget. So if the design / order of times
/// changes, it will also directly changed in the tutorial.
class _BnbTutorial extends StatefulWidget {
  const _BnbTutorial({
    Key? key,
    required this.animationController,
  }) : super(key: key);

  final AnimationController animationController;

  @override
  _BnbTutorialState createState() => _BnbTutorialState();
}

class _BnbTutorialState extends State<_BnbTutorial> {
  bool isTutorialVisible = true;
  bool triedToSwipedUpDemoBnb = false;
  late BnbTutorialBloc bloc;

  @override
  void initState() {
    super.initState();
    bloc = BlocProvider.of<BnbTutorialBloc>(context);
    completeTutorialIfUserOpenedBnBListener();
  }

  void completeTutorialIfUserOpenedBnBListener() {
    widget.animationController.addListener(() {
      // If ExtendableBottomNavigationBar is 85% swiped, the tutorial should be
      // marked as completed.
      if (widget.animationController.value > 0.85 && isTutorialVisible) {
        hideBnbTutorial();
        bloc.markTutorialAsCompleted();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (context.isDesktopModus) return Container();
    return Positioned(
      top: 0,
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 400),
        child: isTutorialVisible
            ? AnimatedBuilder(
                animation: widget.animationController,
                builder: (context, child) {
                  final backgroundHeight = context.mediaQuerySize.height -
                      (80 +
                          (widget.animationController.value * 140) +
                          context.mediaQueryViewPadding.bottom);
                  return Semantics(
                    label:
                        'Schaubild: Wie die Navigationsleiste nach oben gezogen wird, um weitere Navigationselemente zu zeigen.',
                    child: Stack(
                      children: [
                        Container(
                          height: backgroundHeight,
                          width: context.mediaQuerySize.width,
                          color: Colors.black.withOpacity(0.65),
                          child: Align(
                            alignment: Alignment.bottomCenter,
                            child: SingleChildScrollView(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  const _BnBTutorialDescription(),
                                  const SizedBox(height: 68),
                                  _DemoBnb(
                                    onTriedToSwipeUp: () => setState(
                                      () => triedToSwipedUpDemoBnb = true,
                                    ),
                                  ),
                                  const SizedBox(height: 48),
                                  _IconDownArrow(
                                    number: triedToSwipedUpDemoBnb ? 3 : 1,
                                  ),
                                  const SizedBox(height: 32),
                                ],
                              ),
                            ),
                          ),
                        ),
                        _MovingFinger(height: backgroundHeight),
                        _SkipTutorialButton(
                          onTap: () {
                            bloc.markTutorialAsSkipped();
                            hideBnbTutorial();
                          },
                        ),
                      ],
                    ),
                  );
                },
              )
            : Container(),
      ),
    );
  }

  void hideBnbTutorial() {
    setState(() {
      isTutorialVisible = false;
    });
  }
}

class _IconDownArrow extends StatelessWidget {
  const _IconDownArrow({Key? key, this.number = 1}) : super(key: key);

  final int number;

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 350),
      child: Row(
        key: ValueKey('_IconDownArrow:$number'),
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          for (var i = 0; i < number; i++)
            const Icon(
              Icons.arrow_downward,
              color: Colors.white,
              size: 40,
            ),
        ],
      ),
    );
  }
}

class _SkipTutorialButton extends StatelessWidget {
  const _SkipTutorialButton({
    Key? key,
    required this.onTap,
  }) : super(key: key);

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final width = context.mediaQuerySize.width;
    return Positioned(
      top: 40,
      left: (width / 2) - 70,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          foregroundColor: context.primaryColor,
          backgroundColor: Colors.white,
        ),
        child: Text("Überspringen".toUpperCase()),
      ),
    );
  }
}

class _BnBTutorialDescription extends StatelessWidget {
  const _BnBTutorialDescription({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Material(
        borderRadius: BorderRadius.circular(12),
        color: Colors.white,
        child: const Padding(
          padding: EdgeInsets.all(12),
          child: Text(
            "Ziehe die untere Navigationsleiste nach oben, um auf weitere Funktionen zuzugreifen.",
            style: TextStyle(
              color: Colors.black,
              fontSize: 16,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}

class _DemoBnb extends StatelessWidget {
  const _DemoBnb({
    Key? key,
    required this.onTriedToSwipeUp,
  }) : super(key: key);

  /// It can happens that a user tries to swipe up in the [_DemoBnb]. If this
  /// happens, [onTriedToSwipeUp] will be called to display further hints for
  /// the right Bnb.
  final VoidCallback onTriedToSwipeUp;

  @override
  Widget build(BuildContext context) {
    return ExcludeSemantics(
      child: GestureDetector(
        onVerticalDragUpdate: (details) {
          if (hasSwipedUp(details)) {
            onTriedToSwipeUp();
          }
        },
        child: Transform.scale(
          scale: 0.85,
          child: Material(
            borderRadius: BorderRadius.circular(10),
            child: const Padding(
              padding: EdgeInsets.fromLTRB(12, 6, 12, 12),
              child: IgnorePointer(
                child: Column(
                  children: [
                    _SwipeUpLine(),
                    FirstNavigationRow(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  bool hasSwipedUp(DragUpdateDetails details) {
    return details.delta.dy < -1.0;
  }
}

class _MovingFinger extends StatelessWidget {
  const _MovingFinger({
    Key? key,
    required this.height,
  }) : super(key: key);

  final double height;

  @override
  Widget build(BuildContext context) {
    final width = context.mediaQuerySize.width;
    return Positioned(
      bottom: 135,
      left: (width / 2) - 10,
      child: SizedBox(
        height: height,
        child: Align(
          alignment: Alignment.bottomCenter,
          child: Animator<double>(
            tween: Tween<double>(begin: 0, end: -50),
            duration: const Duration(seconds: 2),
            curve: Curves.ease,
            builder: (context, anim, child) => Transform.translate(
              offset: Offset(0, anim.value),
              child: ExcludeSemantics(
                child: PlatformSvg.asset(
                  'assets/icons/finger.svg',
                  height: 50,
                ),
              ),
            ),
            repeats: 999999,
          ),
        ),
      ),
    );
  }
}
