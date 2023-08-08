// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

// part of './timetable_page.dart';

// class _TimetablePageEmpty extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return SingleChildScrollView(
//       padding: const EdgeInsets.all(12),
//       child: SafeArea(
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: <Widget>[
//             Center(
//                 child: Text("Einrichtung",
//                     style: Theme.of(context).textTheme.title,
//                     textAlign: TextAlign.center)),
//             Center(
//               child: Text(
//                   "Bitte lege die Stundenzeiten von deinem Stundenplan fest. Dabei kannst du bereits vorhandene Vorlagen verwenden oder eigene Zeiten erstellen.",
//                   textAlign: TextAlign.center),
//             ),
//             const SizedBox(height: 24),
//             _CustomPeriod(),
//             const SizedBox(height: 24),
//             _PeriodPresents(),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class _CustomPeriod extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return _Section(
//       title: "Benutzerdefiniert",
//       child: ButtonTheme(
//         minWidth: MediaQuery.of(context).size.width,
//         child: RaisedButton(
//           child: const Text("EIGENE STUNDENZEITEN ERSTELLEN"),
//           textColor: Colors.white,
//           color: Theme.of(context).primaryColor,
//           onPressed: () {},
//         ),
//       ),
//     );
//   }
// }

// class _PeriodPresents extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return _Section(
//       title: "Vorlagen",
//       child: SizedBox(
//         width: MediaQuery.of(context).size.width,
//         child: Wrap(
//           alignment: WrapAlignment.spaceBetween,
//           runAlignment: WrapAlignment.spaceBetween,
//           children: <Widget>[
//             _Start745With45Min(),
//             _Start800With45Min(),
//             _Start815With45Min(),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class _Start745With45Min extends StatelessWidget {
//   const _Start745With45Min({
//     Key key,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return _PeriodCard(
//       title: const Text("8:00 Start & 45 Min."),
//       periods: Periods({
//         1: Period(
//           number: 1,
//           startTime: Time(hour: 7, minute: 45),
//           endTime: Time(hour: 8, minute: 30),
//         ),
//         2: Period(
//           number: 2,
//           startTime: Time(hour: 8, minute: 35),
//           endTime: Time(hour: 9, minute: 20),
//         ),
//         3: Period(
//           number: 3,
//           startTime: Time(hour: 9, minute: 40),
//           endTime: Time(hour: 10, minute: 35),
//         ),
//         4: Period(
//           number: 4,
//           startTime: Time(hour: 10, minute: 40),
//           endTime: Time(hour: 11, minute: 25),
//         ),
//       }),
//     );
//   }
// }

// class _Start800With45Min extends StatelessWidget {
//   const _Start800With45Min({
//     Key key,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return _PeriodCard(
//       title: const Text("8:00 Start & 45 Min."),
//       periods: Periods({
//         1: Period(
//           number: 1,
//           startTime: Time(hour: 8, minute: 0),
//           endTime: Time(hour: 8, minute: 45),
//         ),
//         2: Period(
//           number: 2,
//           startTime: Time(hour: 8, minute: 50),
//           endTime: Time(hour: 9, minute: 35),
//         ),
//       }),
//     );
//   }
// }

// class _Start815With45Min extends StatelessWidget {
//   const _Start815With45Min({
//     Key key,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return _PeriodCard(
//       title: const Text("8:00 Start & 45 Min."),
//       periods: Periods({
//         1: Period(
//           number: 1,
//           startTime: Time(hour: 8, minute: 0),
//           endTime: Time(hour: 8, minute: 45),
//         ),
//         2: Period(
//           number: 2,
//           startTime: Time(hour: 8, minute: 50),
//           endTime: Time(hour: 9, minute: 35),
//         ),
//       }),
//     );
//   }
// }

// class _PeriodCard extends StatelessWidget {
//   const _PeriodCard({
//     Key key,
//     this.title,
//     this.periods,
//   }) : super(key: key);

//   final Widget title;
//   final Periods periods;

//   @override
//   Widget build(BuildContext context) {
//     final fullWidth = MediaQuery.of(context).size.width;
//     final halfWidth = (fullWidth / 2) - 36;
//     const breakpoint = 400;
//     final width = fullWidth < breakpoint ? fullWidth : halfWidth;
//     log("width $fullWidth");
//     return SizedBox(
//       width: width,
//       child: Padding(
//         padding: const EdgeInsets.only(bottom: 12),
//         child: CustomCard(
//           onTap: () {},
//           padding: const EdgeInsets.only(bottom: 12, left: 12),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: <Widget>[
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: <Widget>[
//                   DefaultTextStyle(
//                     style: Theme.of(context).textTheme.title,
//                     child: Flexible(
//                         child: Padding(
//                       padding: const EdgeInsets.only(top: 8),
//                       child: title,
//                     )),
//                   ),
//                   IconButton(
//                     icon: const Icon(Icons.edit),
//                     color: Colors.grey[600],
//                     onPressed: () {},
//                   )
//                 ],
//               ),
//               for (final period in periods.getPeriods())
//                 Padding(
//                   padding: const EdgeInsets.only(right: 12),
//                   child: Text(
//                     "${period.number}. ${period.startTime.toString()} : ${period.endTime.toString()}",
//                     style: TextStyle(color: Colors.grey[600]),
//                   ),
//                 )
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

// class _Section extends StatelessWidget {
//   const _Section({Key key, this.title, this.child}) : super(key: key);

//   final String title;
//   final Widget child;

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: <Widget>[
//         if (isNotEmptyOrNull(title)) ...[
//           Text(title, style: TextStyle(color: Colors.grey)),
//           const SizedBox(height: 4)
//         ],
//         child ?? Container(),
//       ],
//     );
//   }
// }
