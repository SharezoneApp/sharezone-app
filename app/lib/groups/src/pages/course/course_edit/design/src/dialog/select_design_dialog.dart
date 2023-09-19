// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

part of '../../course_edit_design.dart';

class SelectDesignPopResult {
  final Design? design;
  final bool removePersonalColor;
  final bool navigateBackToSelectType;

  const SelectDesignPopResult({
    this.design,
    this.removePersonalColor = false,
    this.navigateBackToSelectType = false,
  });
}

@visibleForTesting
Future<SelectDesignPopResult?> selectDesign(
  BuildContext context,
  Design? currentDesign, {
  EditDesignType type = EditDesignType.personal,
}) async {
  return await showDialog<SelectDesignPopResult>(
    context: context,
    builder: (context) =>
        _SelectDesignAlert(currentDesign: currentDesign, type: type),
  );
}

class _SelectDesignAlert extends StatelessWidget {
  const _SelectDesignAlert({
    Key? key,
    this.currentDesign,
    required this.type,
  }) : super(key: key);

  final Design? currentDesign;
  final EditDesignType type;

  @override
  Widget build(BuildContext context) {
    final hasUserPersonalColor =
        type == EditDesignType.personal && currentDesign != null;
    final isUnlocked = context
        .read<SubscriptionService>()
        .hasFeatureUnlocked(SharezonePlusFeature.moreGroupColors);
    return AlertDialog(
      contentPadding:
          EdgeInsets.fromLTRB(24, 24, 24, hasUserPersonalColor ? 12 : 24),
      content: SingleChildScrollView(
        child: MaxWidthConstraintBox(
          maxWidth: 400,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              if (isUnlocked)
                _PlusColors(selectedDesign: currentDesign)
              else
                _FreeColors(selectedDesign: currentDesign),
              if (hasUserPersonalColor) _RemovePersonalColor(),
              if (hasUserPersonalColor) const SizedBox(height: 4),
              if (!hasUserPersonalColor) const SizedBox(height: 16),
              if (!isUnlocked) const _SharezonePlusAd(),
            ],
          ),
        ),
      ),
    );
  }
}

class _SharezonePlusAd extends StatelessWidget {
  const _SharezonePlusAd();

  @override
  Widget build(BuildContext context) {
    return SharezonePlusFeatureInfoCard(
      withLearnMoreButton: true,
      onLearnMorePressed: () => navigateToSharezonePlusPage(context),
      child: const Text(
          'Nicht genug Farben? Schalte mit Sharezone Plus +200 zusätzliche Farben frei.'),
    );
  }
}

class _RemovePersonalColor extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () => Navigator.pop(
          context, const SelectDesignPopResult(removePersonalColor: true)),
      style: TextButton.styleFrom(
        foregroundColor: Colors.grey[700],
      ),
      child: const Text("Persönliche Farbe entfernen"),
    );
  }
}

class _FreeColors extends StatelessWidget {
  const _FreeColors({
    this.selectedDesign,
  });

  final Design? selectedDesign;

  bool _isDesignSelected(Design design) => selectedDesign == design;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _BackToSelectTypeButton(),
        const SizedBox(height: 16),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: [
            ...Design.freeDesigns
                .map(
                  (design) => _ColorCircleSelectDesign(
                    design: design,
                    isSelected: _isDesignSelected(design),
                    onTap: () => Navigator.pop(
                      context,
                      SelectDesignPopResult(design: design),
                    ),
                  ),
                )
                .toList(),
          ],
        ),
      ],
    );
  }
}

/// This widget is used to select a base color and then select from the base
/// color the accurate color.
class _PlusColors extends StatefulWidget {
  const _PlusColors({
    this.selectedDesign,
  });

  final Design? selectedDesign;

  @override
  State<_PlusColors> createState() => _PlusColorsState();
}

class _PlusColorsState extends State<_PlusColors> {
  /// The base color that was selected in the first page.
  ///
  /// If this is null, the first page is shown. If this is not null, the second
  /// page is shown.
  MaterialColor? baseColor;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        // This is a hack to make sure that the dialog has the same size when
        // switching between the two pages. Otherwise the dialog changes its
        // size when switching between the two pages which looks weird.
        const Opacity(
          opacity: 0,
          child: IgnorePointer(
            child: Stack(
              children: [
                _PlusBaseColors(),
                _PlusAccurateColors(baseColor: Colors.amber)
              ],
            ),
          ),
        ),
        PageTransitionSwitcher(
          reverse: baseColor != null,
          transitionBuilder: (
            Widget child,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
          ) {
            return SharedAxisTransition(
              animation: animation,
              secondaryAnimation: secondaryAnimation,
              transitionType: SharedAxisTransitionType.vertical,
              fillColor: Colors.transparent,
              child: child,
            );
          },
          duration: const Duration(milliseconds: 250),
          // The user can first select a base color and then select from the
          // base color the accurate color.
          child: baseColor == null
              ? _PlusBaseColors(
                  key: const Key('plus-accurate-colors'),
                  onBaseColorChanged: (color) =>
                      setState(() => baseColor = color))
              : _PlusAccurateColors(
                  key: const Key('plus-accurate-colors'),
                  baseColor: baseColor!,
                  onBackButtonPressed: () => setState(() => baseColor = null),
                  selectedDesign: widget.selectedDesign,
                ),
        ),
      ],
    );
  }
}

class _PlusBaseColors extends StatelessWidget {
  const _PlusBaseColors({
    super.key,
    this.onBaseColorChanged,
  });

  final ValueChanged<MaterialColor>? onBaseColorChanged;

  static const _baseColors = <MaterialColor>[
    Colors.red,
    Colors.pink,
    Colors.purple,
    Colors.deepPurple,
    Colors.indigo,
    Colors.blue,
    Colors.lightBlue,
    Colors.cyan,
    Colors.teal,
    Colors.green,
    Colors.lightGreen,
    Colors.lime,
    Colors.yellow,
    Colors.amber,
    Colors.orange,
    Colors.deepOrange,
    Colors.brown,
    Colors.blueGrey,
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _BackToSelectTypeButton(),
        const SizedBox(height: 16),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: [
            ..._baseColors.map(
              (color) {
                final design = Design.fromColor(color);
                return _ColorCircleSelectDesign(
                  design: design,
                  onTap: () => onBaseColorChanged!(color),
                );
              },
            ).toList(),
          ],
        ),
      ],
    );
  }
}

class _PlusAccurateColors extends StatelessWidget {
  const _PlusAccurateColors({
    super.key,
    required this.baseColor,
    this.onBackButtonPressed,
    this.selectedDesign,
  });

  final MaterialColor baseColor;
  final Design? selectedDesign;
  final VoidCallback? onBackButtonPressed;

  bool _isDesignSelected(Design design) => selectedDesign == design;

  List<Design> getDesigns() {
    List<Color> colors = [];
    for (final level in [50, 100, 200, 300, 400, 500, 600, 700, 800, 900]) {
      try {
        colors.add(baseColor[level]!);
      } catch (e) {
        // Ignore, color level does not exist.
      }
    }
    return colors.map((c) => Design.fromColor(c)).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        BackButton(
          color: Colors.grey,
          onPressed: onBackButtonPressed,
        ),
        const SizedBox(height: 16),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: [
            ...getDesigns()
                .map(
                  (design) => _ColorCircleSelectDesign(
                    design: design,
                    isSelected: _isDesignSelected(design),
                    onTap: () => Navigator.pop(
                      context,
                      SelectDesignPopResult(design: design),
                    ),
                  ),
                )
                .toList(),
          ],
        ),
      ],
    );
  }
}

class _ColorCircleSelectDesign extends StatelessWidget {
  const _ColorCircleSelectDesign({
    Key? key,
    required this.design,
    this.isSelected = false,
    required this.onTap,
  }) : super(key: key);

  final Design? design;
  final bool isSelected;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    const size = 50.0;
    Widget? child =
        isSelected ? const Icon(Icons.check, color: Colors.white) : null;

    return Material(
      color: design?.color,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(size)),
      child: InkWell(
        borderRadius: BorderRadius.circular(size),
        onTap: onTap,
        child: SizedBox(
          width: size,
          height: size,
          child: child,
        ),
      ),
    );
  }
}

class _BackToSelectTypeButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BackButton(
      color: Colors.grey,
      onPressed: () => Navigator.pop(
        context,
        const SelectDesignPopResult(navigateBackToSelectType: true),
      ),
    );
  }
}
