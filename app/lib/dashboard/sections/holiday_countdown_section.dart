// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

part of '../dashboard_page.dart';

@visibleForTesting
class HolidayCountdownSection extends StatelessWidget {
  const HolidayCountdownSection({super.key});

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<HolidayBloc>(context);
    return BlocProvider(
      bloc: bloc,
      child: _Section(
        title: Text(context.l10n.dashboardHolidayCountdownTitle),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
          child: CustomCard(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: SizedBox(
              width: double.infinity,
              child: StreamBuilder<bool>(
                stream: bloc.hasStateSelected,
                builder: (context, snapshot) {
                  if (!snapshot.hasData) return Container(height: 50);
                  final hasUserSelectedState = snapshot.data!;
                  if (hasUserSelectedState) return const _HolidayCounter();
                  return const _SelectStateDialog();
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
      child: StreamBuilder<List<Holiday?>>(
        stream: bloc.holidays,
        builder: (context, snapshot) {
          if (snapshot.hasError) return handleError(context, snapshot.error);
          if (!snapshot.hasData) {
            return const Center(child: AccentColorCircularProgressIndicator());
          }
          if (snapshot.data!.isEmpty) return handleError(context, null);
          return DefaultTextStyle(
            style: DefaultTextStyle.of(context).style,
            textAlign: TextAlign.center,
            child: _HolidayText(maxItems: 2, holidayList: snapshot.data!),
          );
        },
      ),
    );
  }

  Widget handleError(BuildContext context, Object? error) {
    if (error is UnsupportedStateException) {
      return Center(
        child: Text(
          context.l10n.dashboardHolidayCountdownUnsupportedStateError,
          textAlign: TextAlign.center,
        ),
      );
    }
    return Center(
      child: Text(
        context.l10n.dashboardHolidayCountdownGeneralError,
        textAlign: TextAlign.center,
      ),
    );
  }
}

class _HolidayText extends StatelessWidget {
  final int maxItems;
  final List<Holiday?> holidayList;

  const _HolidayText({required this.maxItems, required this.holidayList})
    : assert(maxItems > 0);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: _buildHolidayWidgets(context, holidayList, maxItems),
    );
  }

  Text handleError(
    AsyncSnapshot<List<Holiday>> snapshot,
    BuildContext context,
  ) {
    log(
      "Error when displaying Holidays: ${snapshot.error}",
      error: snapshot.error,
      stackTrace: snapshot.stackTrace,
    );
    if (snapshot.error is UnsupportedStateException) {
      return Text(
        context.l10n.dashboardHolidayCountdownUnsupportedStateShortError,
      );
    }
    return Text(context.l10n.dashboardHolidayCountdownDisplayError);
  }

  List<Widget> _buildHolidayWidgets(
    BuildContext context,
    List<Holiday?> holidayList,
    int maxItems,
  ) {
    List<Widget> widgetList = [];
    if (holidayList.length > maxItems) {
      holidayList = List.from(holidayList.getRange(0, maxItems));
    }
    // For each Holiday create a Widget and add to the list.
    for (var holiday in holidayList) {
      int daysTillHolidayBeginn = holiday!.start.difference(clock.now()).inDays;
      String holidayTitle = capitalize(holiday.name);

      String emoji;
      Text textWidget;
      if (daysTillHolidayBeginn > 0) {
        emoji = daysTillHolidayBeginn > 24 ? "😴" : "😍";
        String text =
            daysTillHolidayBeginn > 1
                ? context.l10n.dashboardHolidayCountdownInDays(
                  daysTillHolidayBeginn,
                  emoji,
                )
                : context.l10n.dashboardHolidayCountdownTomorrow;
        textWidget = Text(
          context.l10n.dashboardHolidayCountdownHolidayLine(text, holidayTitle),
        );
      } else if (daysTillHolidayBeginn == 0) {
        emoji = "🎉🎉🙌";
        textWidget = Text(
          context.l10n.dashboardHolidayCountdownHolidayLine(
            context.l10n.dashboardHolidayCountdownNow(emoji),
            holidayTitle,
          ),
        );
      } else {
        int daysTillHolidayEnd = holiday.end.difference(clock.now()).inDays;
        if (daysTillHolidayEnd == 0) {
          textWidget = Text(
            context.l10n.dashboardHolidayCountdownHolidayLine(
              context.l10n.dashboardHolidayCountdownLastDay,
              holidayTitle,
            ),
          );
        } else {
          emoji = daysTillHolidayEnd > 4 ? "☺🎈" : "😔";
          textWidget = Text(
            context.l10n.dashboardHolidayCountdownHolidayLine(
              context.l10n.dashboardHolidayCountdownRemaining(
                daysTillHolidayEnd > 1
                    ? context.l10n.dashboardHolidayCountdownDayUnitDays
                    : context.l10n.dashboardHolidayCountdownDayUnitDay,
                daysTillHolidayEnd,
                emoji,
              ),
              holidayTitle,
            ),
          );
        }
      }

      final isFirstText = holidayList.first!.slug == holiday.slug;
      if (!isFirstText) {
        // Add padding between the text widgets
        widgetList.add(const SizedBox(height: 4));
      }

      widgetList.add(textWidget);
    }
    return widgetList;
  }
}

class _SelectStateDialog extends StatelessWidget {
  const _SelectStateDialog();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        children: <Widget>[
          const SizedBox(height: 4),
          MaxWidthConstraintBox(
            maxWidth: 500,
            child: SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: () => showStateSelectionDialog(context),
                child: Text(
                  context.l10n.dashboardSelectStateButton,
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            context.l10n.dashboardHolidayCountdownSelectStateHint,
            style: const TextStyle(color: Colors.grey, fontSize: 12),
          ),
        ],
      ),
    );
  }
}

String capitalize(String s) => s[0].toUpperCase() + s.substring(1);
