// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

part of '../../course_edit_design.dart';

class _SelectDesignPopResult {
  final Design? design;
  final bool removePersonalColor;
  final bool navigateBackToSelectType;

  _SelectDesignPopResult({
    this.design,
    this.removePersonalColor = false,
    this.navigateBackToSelectType = false,
  });
}

@visibleForTesting
Future<_SelectDesignPopResult?> selectDesign(
  BuildContext context,
  Design? currentDesign, {
  _EditDesignType type = _EditDesignType.personal,
}) async {
  return await showDialog<_SelectDesignPopResult>(
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
  final _EditDesignType type;

  @override
  Widget build(BuildContext context) {
    final hasUserPersonalColor =
        type == _EditDesignType.personal && currentDesign != null;
    return AlertDialog(
      contentPadding:
          EdgeInsets.fromLTRB(24, 24, 24, hasUserPersonalColor ? 12 : 24),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            _Colors(
              selectedDesign: currentDesign,
              type: type,
            ),
            if (hasUserPersonalColor) _RemovePersonalColor(),
            if (hasUserPersonalColor) const SizedBox(height: 4),
            if (!hasUserPersonalColor) const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}

class _RemovePersonalColor extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return TextButton(
      child: const Text("Persönliche Farbe entfernen"),
      onPressed: () => Navigator.pop(
          context, _SelectDesignPopResult(removePersonalColor: true)),
      style: TextButton.styleFrom(
        foregroundColor: Colors.grey[700],
      ),
    );
  }
}

class _Colors extends StatelessWidget {
  const _Colors({
    Key? key,
    this.selectedDesign,
    required this.type,
  }) : super(key: key);

  final Design? selectedDesign;
  final _EditDesignType type;

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
    Widget? child = isSelected ? Icon(Icons.check, color: Colors.white) : null;

    return Material(
      color: design?.color,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(size)),
      child: InkWell(
        borderRadius: BorderRadius.circular(size),
        onTap: () =>
            Navigator.pop(context, _SelectDesignPopResult(design: design)),
        child: Container(
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
      icon: Icon(Icons.arrow_back),
      color: Colors.grey,
      onPressed: () => Navigator.pop(
        context,
        _SelectDesignPopResult(navigateBackToSelectType: true),
      ),
    );
  }
}
