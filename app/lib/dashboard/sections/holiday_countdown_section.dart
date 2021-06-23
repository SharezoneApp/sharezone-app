part of '../dashboard_page.dart';

class _HolidayCountdownSection extends StatelessWidget {
  const _HolidayCountdownSection({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<HolidayBloc>(context);
    return BlocProvider(
      bloc: bloc,
      child: _Section(
        title: const Text("Ferien-Countdown"),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
          child: CustomCard(
            child: SizedBox(
              width: double.infinity,
              child: StreamBuilder<bool>(
                stream: bloc.userState
                    .map((state) => state != StateEnum.notSelected),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) return Container(height: 50);
                  final hasUserSelectedState = snapshot.data;
                  if (hasUserSelectedState) return const _HolidayCounter();
                  return const _SelectStateDropdown();
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _HolidayCounter extends StatelessWidget {
  const _HolidayCounter();

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<HolidayBloc>(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: StreamBuilder<List<Holiday>>(
        stream: bloc.holidays,
        builder: (context, snapshot) {
          if (snapshot.hasError) return handleError(snapshot.error);
          if (!snapshot.hasData)
            return const Center(child: AccentColorCircularProgressIndicator());
          if (snapshot.data.isEmpty) return handleError(null);
          return _HolidayText(
            maxItems: 2,
            holidayList: snapshot.data,
          );
        },
      ),
    );
  }

  Widget handleError(Object error) {
    if (error is UnsupportedStateException)
      return Text(
          "Ferien können für dein ausgewähltes Bundesland nicht angezeigt werden! 😫\nDu kannst das Bundesland in den Einstellungen ändern.");
    return Center(
        child: Text(
      "💣 Boooomm.... Etwas ist kaputt gegangen. Starte am besten die App einmal neu 👍",
      textAlign: TextAlign.center,
    ));
  }
}

class _HolidayText extends StatelessWidget {
  final int maxItems;
  final List<Holiday> holidayList;

  const _HolidayText({
    Key key,
    @required this.maxItems,
    @required this.holidayList,
  })  : assert(maxItems > 0),
        assert(holidayList != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: _buildHolidayWidgets(holidayList, maxItems ?? 3),
    );
  }

  Text handleError(
      AsyncSnapshot<List<Holiday>> snapshot, BuildContext context) {
    print("Error when displaying Holidays: ${snapshot.error}");
    if (snapshot.error is UnsupportedStateException) {
      return Text("Ferien konnten für dein Bundesland nicht angezeigt werden");
    }
    return Text(
        "Es gab einen Fehler beim Anzeigen von den Ferien.\nFalls dieser Fehler öfters auftaucht kontaktiere uns bitte.");
  }

  List<Widget> _buildHolidayWidgets(List<Holiday> holidayList, int maxItems) {
    List<Widget> widgetList = [];
    if (holidayList.length > maxItems)
      holidayList = List.from(holidayList.getRange(0, maxItems));
    // For each Holiday create a Widget and add to the list.
    holidayList.forEach((holiday) {
      int daysTillHolidayBeginn =
          holiday.start.difference(DateTime.now()).inDays;
      String holidayTitle = capitalize(holiday.name);

      String emoji;
      Text textWidget;
      if (daysTillHolidayBeginn > 0) {
        emoji = daysTillHolidayBeginn > 24 ? "😴" : "😍";
        String text = daysTillHolidayBeginn > 1
            ? "In $daysTillHolidayBeginn Tagen $emoji"
            : "Morgen 😱🎉";
        textWidget = Text("$holidayTitle: $text");
      } else if (daysTillHolidayBeginn == 0) {
        emoji = "🎉🎉🙌";
        textWidget = Text("$holidayTitle: JETZT, WOOOOOOO! $emoji");
      } else {
        int daysTillHolidayEnd = holiday.end.difference(DateTime.now()).inDays;
        if (daysTillHolidayEnd == 0) {
          textWidget = Text("$holidayTitle: Letzer Tag 😱");
        } else {
          emoji = daysTillHolidayEnd > 4 ? "☺🎈" : "😔";
          textWidget = Text(
              "$holidayTitle: Noch $daysTillHolidayEnd ${daysTillHolidayEnd > 1 ? "Tage" : "Tag"} $emoji");
        }
      }

      widgetList.add(textWidget);
    });
    return widgetList;
  }
}

class _SelectStateDropdown extends StatelessWidget {
  const _SelectStateDropdown({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<HolidayBloc>(context);
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        children: <Widget>[
          const SizedBox(height: 4),
          DropdownButton<StateEnum>(
            hint: const Text("Bundesland auswählen"),
            isDense: true,
            isExpanded: true,
            items: StateEnum.values
                .sublist(0, StateEnum.values.length - 1)
                .map(
                  (state) => DropdownMenuItem(
                    child: Text(stateEnumToString[state]),
                    value: state,
                  ),
                )
                .toList(),
            onChanged: (state) {
              showSelectedStateSnackBar(context, state);
              bloc.changeState(state);
            },
          ),
          const SizedBox(height: 16),
          Text(
            "Durch das Auswählen eines Bundeslandes können wir berechnen, wie lange du dich noch in der Schule quälen musst, bis endlich die Ferien sind 😉",
            style: TextStyle(color: Colors.grey, fontSize: 12),
          )
        ],
      ),
    );
  }

  /// [navigationBloc] wird benötigt, da nicht mehr mit dem Context
  /// navigiert werden kann. Das [_SelectStateDropdown] Widget verschwindet
  /// sofort, sobald der Nutzer ein Bundesland auswählt, womit auch der
  /// Context ungültigt wird. Würde man nun über den Context navigieren,
  /// so würde es zu einer Fehlermeldung kommen.
  void showSelectedStateSnackBar(BuildContext context, StateEnum state) {
    final navigationService = BlocProvider.of<NavigationService>(context);
    showSnackSec(
      context: context,
      seconds: 5,
      behavior: SnackBarBehavior.fixed,
      text: "Bundesland ${stateEnumToString[state]} ausgewählt",
      action: SnackBarAction(
        label: "Ändern".toUpperCase(),
        onPressed: () => navigationService.pushWidget(ChangeStatePage(),
            name: ChangeStatePage.tag),
      ),
    );
  }
}

String capitalize(String s) => s[0].toUpperCase() + s.substring(1);
