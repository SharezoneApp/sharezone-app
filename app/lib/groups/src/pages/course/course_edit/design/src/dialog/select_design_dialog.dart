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
              _FreeColors(
                selectedDesign: currentDesign,
                type: type,
              ),
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
          'Zu wenig Farben? Schalte +200 weitere Farben mit Sharezone Plus frei.'),
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
    required this.type,
  });

  final Design? selectedDesign;
  final EditDesignType type;

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
                  ),
                )
                .toList(),
          ],
        ),
      ],
    );
  }

  bool _isDesignSelected(Design design) => selectedDesign == design;
}

class _ColorCircleSelectDesign extends StatelessWidget {
  const _ColorCircleSelectDesign({
    Key? key,
    required this.design,
    this.isSelected = false,
  }) : super(key: key);

  final Design? design;
  final bool isSelected;

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
        onTap: () =>
            Navigator.pop(context, SelectDesignPopResult(design: design)),
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
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      color: Colors.grey,
      onPressed: () => Navigator.pop(
        context,
        const SelectDesignPopResult(navigateBackToSelectType: true),
      ),
    );
  }
}
