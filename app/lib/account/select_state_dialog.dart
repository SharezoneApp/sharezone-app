import 'package:bloc_provider/bloc_provider.dart';
import 'package:flutter/material.dart';
import 'package:sharezone/holidays/holiday_bloc.dart';
import 'package:sharezone_localizations/sharezone_localizations.dart';
import 'package:sharezone_widgets/sharezone_widgets.dart';
import 'package:user/user.dart';

/// Shows a dialog to first select the country and then the state.
///
/// After selecting the state, a confirmation snack bar is shown.
Future<void> showStateSelectionDialog(BuildContext context) async {
  final selectedState = await showDialog<StateEnum?>(
    context: context,
    builder: (context) => const _SelectStateDialog(),
  );

  if (selectedState != null && context.mounted) {
    _showSelectedStateSnackBar(context, selectedState);
  }
}

void _showSelectedStateSnackBar(BuildContext context, StateEnum state) {
  showSnackSec(
    context: context,
    seconds: 5,
    behavior: SnackBarBehavior.fixed,
    text: context.l10n.selectStateDialogConfirmationSnackBar(
      state.getDisplayName(context),
    ),
  );
}

class _SelectStateDialog extends StatefulWidget {
  const _SelectStateDialog();

  @override
  State<_SelectStateDialog> createState() => _SelectStateDialogState();
}

class _SelectStateDialogState extends State<_SelectStateDialog> {
  HolidayCountry? selectedCountry;
  StateEnum? selectedState;

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<HolidayBloc>(context);
    final isSelectingCountry = selectedCountry == null;
    return AlertDialog(
      title:
          isSelectingCountry
              ? Text(context.l10n.selectStateDialogSelectCountryTitle)
              : _SelectingStateTitle(country: selectedCountry!),
      content:
          isSelectingCountry
              ? _CountrySelectionList(
                onCountrySelected:
                    (country) => setState(() => selectedCountry = country),
              )
              : _StateSelectionList(
                country: selectedCountry!,
                onStateSelected: (state) {
                  bloc.changeState(state);
                  Navigator.of(context).pop(state);
                },
              ),
      actions: [
        if (!isSelectingCountry)
          TextButton(
            key: const Key('back-button'),
            onPressed: () => setState(() => selectedCountry = null),
            child: Text(context.l10n.commonActionBack),
          ),
        TextButton(
          key: const Key('cancel-button'),
          onPressed: () => Navigator.of(context).pop(),
          child: Text(context.l10n.commonActionsCancel),
        ),
      ],
    );
  }
}

class _SelectingStateTitle extends StatelessWidget {
  const _SelectingStateTitle({required this.country});

  final HolidayCountry country;

  @override
  Widget build(BuildContext context) {
    return Text(switch (country) {
      HolidayCountry.germany ||
      HolidayCountry.austria => context.l10n.selectStateDialogSelectBundesland,
      HolidayCountry.switzerland => context.l10n.selectStateDialogSelectCanton,
    });
  }
}

class _CountrySelectionList extends StatelessWidget {
  final ValueChanged<HolidayCountry> onCountrySelected;

  const _CountrySelectionList({required this.onCountrySelected});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          ...HolidayCountry.values.map(
            (country) => ListTile(
              key: ValueKey(country),
              leading: Text(
                country.getFlagEmoji(),
                style: const TextStyle(fontSize: 24),
              ),
              title: Text(country.getDisplayName(context)),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => onCountrySelected(country),
            ),
          ),
          const Divider(),
          ListTile(
            key: const ValueKey(StateEnum.anonymous),
            leading: const Icon(Icons.account_circle),
            title: Text(context.l10n.selectStateDialogStayAnonymous),
            onTap: () {
              final bloc = BlocProvider.of<HolidayBloc>(context);
              bloc.changeState(StateEnum.anonymous);
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }
}

class _StateSelectionList extends StatelessWidget {
  final HolidayCountry country;
  final ValueChanged<StateEnum> onStateSelected;

  const _StateSelectionList({
    required this.country,
    required this.onStateSelected,
  });

  @override
  Widget build(BuildContext context) {
    final states = holidayStatesByCountry[country] ?? [];
    return SingleChildScrollView(
      child: Column(
        children: [
          for (final state in states)
            ListTile(
              key: ValueKey(state),
              title: Text(state.getDisplayName(context)),
              onTap: () => onStateSelected(state),
            ),
        ],
      ),
    );
  }
}
