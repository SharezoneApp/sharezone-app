part of '../timetable_add_event_page.dart';

class _DateTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<TimetableAddEventBloc>(context);
    return _TimetableAddSection(
      index: 3,
      title: 'Wähle ein Datum aus',
      child: StreamBuilder<Date>(
        stream: bloc.date,
        builder: (context, snapshot) {
          final selectedWeekDay = snapshot.hasData ? snapshot.data : null;
          return _DateField(selectedWeekDay);
        },
      ),
    );
  }
}

class _DateField extends StatelessWidget {
  final Date selectedDate;
  const _DateField(this.selectedDate);
  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<TimetableAddEventBloc>(context);
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Center(
          child: EditDateField(
            date: selectedDate,
            onChanged: (newDate) {
              bloc.changeDate(newDate);
              navigateToNextTab(context);
            },
          ),
        ),
      ),
    );
  }
}
