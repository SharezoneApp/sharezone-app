part of '../dashboard_page.dart';

class _UpdateReminder extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<UpdateReminderBloc>(context);
    return FutureBuilder(
      future: bloc.shouldRemindToUpdate(),
      builder: (context, snapshot) {
        if (!snapshot.hasData || snapshot.data == false) return Container();
        return Padding(
          padding: const EdgeInsets.fromLTRB(12, 12, 12, 0),
          child: UpdatePromptCard(),
        );
      },
    );
  }
}
