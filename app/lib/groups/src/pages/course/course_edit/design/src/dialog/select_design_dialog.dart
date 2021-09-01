part of '../../course_edit_design.dart';

class _SelectDesignPopResult {
  final Design design;
  final bool removePersonalColor;
  final bool navigateBackToSelectType;

  _SelectDesignPopResult({
    this.design,
    this.removePersonalColor = false,
    this.navigateBackToSelectType = false,
  });
}

/// [bottomAction] will be displayed at the bottom of the dialog, e. g. a back button.
Future<_SelectDesignPopResult> _selectDesign(
    BuildContext context, Design currentDesign,
    {_EditDesignType type}) async {
  return await showDialog<_SelectDesignPopResult>(
    context: context,
    builder: (context) =>
        _SelectDesignAlert(currentDesign: currentDesign, type: type),
  );
}

class _SelectDesignAlert extends StatelessWidget {
  const _SelectDesignAlert({Key key, this.currentDesign, this.type})
      : super(key: key);

  final Design currentDesign;
  final _EditDesignType type;

  @override
  Widget build(BuildContext context) {
    final hasUserPersonalColor =
        type == _EditDesignType.personal && currentDesign != null;
    final featureBloc = BlocProvider.of<FeatureBloc>(context);
    return StreamBuilder<bool>(
      stream: featureBloc.isAllColorsUnlocked,
      initialData: true,
      builder: (context, snapshot) {
        final isFullColorSetUnlocked = snapshot.data;
        return AlertDialog(
          contentPadding: EdgeInsets.fromLTRB(24, 24, 24,
              hasUserPersonalColor || !isFullColorSetUnlocked ? 12 : 24),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                _Colors(
                    selectedDesign: currentDesign,
                    type: type,
                    isFullColorSetUnlocked: isFullColorSetUnlocked),
                if (hasUserPersonalColor) _RemovePersonalColor(),
                if (hasUserPersonalColor && !isFullColorSetUnlocked)
                  const SizedBox(height: 4),
                if (!hasUserPersonalColor && !isFullColorSetUnlocked)
                  const SizedBox(height: 16),
                if (!isFullColorSetUnlocked)
                  _ReferralNote(isFullColorSetUnlocked: isFullColorSetUnlocked),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _ReferralNote extends StatelessWidget {
  const _ReferralNote({Key key, @required this.isFullColorSetUnlocked})
      : super(key: key);

  final bool isFullColorSetUnlocked;

  @override
  Widget build(BuildContext context) {
    return Text("Die Nutzung aller Farben wurde geblockt.");
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
        primary: Colors.grey[700],
      ),
    );
  }
}

class _Colors extends StatelessWidget {
  const _Colors(
      {Key key,
      this.selectedDesign,
      this.type,
      @required this.isFullColorSetUnlocked})
      : super(key: key);

  final Design selectedDesign;
  final _EditDesignType type;
  final bool isFullColorSetUnlocked;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: [
        _BackToSelectTypeButton(),
        ...Design.designList
            .sublist(0, 7)
            .map((design) => _ColorCircleSelectDesign(
                design: design, isSelected: _isDesignSelected(design)))
            .toList(),
        ...Design.designList
            .sublist(7)
            .map(
              (design) => _ColorCircleSelectDesign(
                design: design,
                isSelected: _isDesignSelected(design),
                hasPermission: isFullColorSetUnlocked,
              ),
            )
            .toList()
      ],
    );
  }

  bool _isDesignSelected(Design design) => selectedDesign == design;
}

class _ColorCircleSelectDesign extends StatelessWidget {
  const _ColorCircleSelectDesign({
    Key key,
    @required this.design,
    this.isSelected = false,
    this.hasPermission = true,
    this.size = 50,
  }) : super(key: key);

  final Design design;
  final bool isSelected, hasPermission;
  final double size;

  @override
  Widget build(BuildContext context) {
    Widget child;
    if (!hasPermission)
      child = Icon(Icons.lock, color: Colors.white);
    else if (isSelected) child = Icon(Icons.check, color: Colors.white);

    return Material(
      color: design?.color,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(size)),
      child: InkWell(
        borderRadius: BorderRadius.circular(size),
        onTap: hasPermission
            ? () =>
                Navigator.pop(context, _SelectDesignPopResult(design: design))
            : null,
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
          context, _SelectDesignPopResult(navigateBackToSelectType: true)),
    );
  }
}
