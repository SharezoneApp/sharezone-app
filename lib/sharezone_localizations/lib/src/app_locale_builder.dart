import 'package:flutter/widgets.dart';
import 'package:sharezone_localizations/sharezone_localizations.dart';

class AppLocaleBuilder extends StatelessWidget {
  final Widget Function(BuildContext context, AppLocales appLocale) builder;
  const AppLocaleBuilder({super.key, required this.builder});

  @override
  Widget build(BuildContext context) {
    final bloc = AppLocaleProviderBloc.of(context);
    return StreamBuilder(
      initialData: bloc.localeSubject.value,
      stream: bloc.localeSubject,
      builder: (context, snapshot) {
        // Will always have a value, as we set the initial value in the bloc.
        return builder(context, snapshot.data!);
      },
    );
  }
}
