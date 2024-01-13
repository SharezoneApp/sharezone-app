// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

part of '../dashboard_page.dart';

class _LessonRow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<DashboardBloc>(context);
    return StreamBuilder<List<LessonView>>(
      stream: bloc.lessonViews,
      builder: (context, snapshot) {
        if (!snapshot.hasData) return Container();
        if (snapshot.data!.isEmpty) return _NoLessonsToday();
        final views = snapshot.data!;

        int currentIndex;
        try {
          currentIndex = getCurrentLessonIndex(views);
        } on AllLessonsAreOverException {
          return _SchoolIsOver();
        }

        // Breite einer [_LessonCard] inkl. Padding
        const lessonWidth = 72.0;

        // Durch den [initialScrollOffset]-Wert wird automatisch eine
        // LessonsCard weitergescrollt, wenn eine Stunde schon bereits
        // stattgefunden hat. So werden umso früher die späteren Stunden
        // sichtbar, wenn die ersten schon stattgefunden haben. Ansonsten
        // muss man manuell weiterscrollen, um die späteren Stunden zu
        // sehen. Das vergisst man oft, weswegen man diese übersieht.
        final initialScrollOffset = currentIndex * lessonWidth;

        return Center(
          child: SingleChildScrollView(
            controller:
                ScrollController(initialScrollOffset: initialScrollOffset),
            scrollDirection: Axis.horizontal,
            child: Row(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top: 14),
                  child: AnimationLimiter(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        views.length,
                        (index) => AnimationConfiguration.staggeredList(
                          position: index,
                          duration: const Duration(milliseconds: 250),
                          child: SlideAnimation(
                            verticalOffset: 10,
                            child: FadeInAnimation(
                              child: _LessonCard(views[index]),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _NoLessonsToday extends StatelessWidget {
  @override
  Widget build(BuildContext context) =>
      const _EmptyStateMsg("Yeah! Heute stehen keine Schulstunden an! 😍");
}

class _SchoolIsOver extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const _EmptyStateMsg("Endlich Schulschluss! 😍");
  }
}

class _EmptyStateMsg extends StatelessWidget {
  const _EmptyStateMsg(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: GestureDetector(
          onTap: () {
            final navigationBloc = BlocProvider.of<NavigationBloc>(context);
            navigationBloc.navigateTo(NavigationItem.timetable);
          },
          child: Text(
            text,
            style: TextStyle(
                fontSize: 18,
                color: Theme.of(context).isDarkTheme
                    ? Colors.lightBlue
                    : darkBlueColor),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
