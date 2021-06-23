import 'package:common_domain_models/common_domain_models.dart';
import 'package:hausaufgabenheft_logik/src/models/homework/homework.dart';
import 'package:hausaufgabenheft_logik/src/models/homework/homework_completion_status.dart';
import 'package:hausaufgabenheft_logik/src/models/date.dart';
import 'package:hausaufgabenheft_logik/src/models/title.dart';
import 'package:hausaufgabenheft_logik/src/models/subject.dart';
import 'package:test/test.dart';

import 'create_homework_util.dart';

enum HomeworkParameter { id, subject, title, done, date }
void main() {
  group('Homework', () {
    test('cant be created with a null subject', () {
      expectThrowsArgumentError(
        () => createWith(HomeworkParameter.subject, null),
      );
    });
    test('is overdue when the todoDate is before now', () {
      final h = createHomework(todoDate: Date(year: 2019, month: 02, day: 03));
      final today = Date(year: 2019, month: 02, day: 18);
      expect(h.isOverdueRelativeTo(today), true);
    });
    test('is not overdue when the todoDate equals the day given', () {
      var date = Date(year: 2019, month: 02, day: 03);
      final h = createHomework(todoDate: date);
      expect(h.isOverdueRelativeTo(date), false);
    });

    test('is not overdue when the todoDate is after the day given', () {
      final h = createHomework(todoDate: Date(year: 2019, month: 02, day: 03));
      final today = Date(year: 2019, month: 01, day: 02);
      expect(h.isOverdueRelativeTo(today), false);
    });
  });
}

void expectThrowsArgumentError(Function f) {
  expect(() => f(), throwsArgumentError);
}

HomeworkReadModel createWith(HomeworkParameter nullParameter, dynamic instead) {
  final title = Title('SomeTitle');
  final subject = Subject('SomeSubject');
  final id = HomeworkId('SomeId');
  final done = CompletionStatus.open;
  final todoDate = Date(year: 2019, month: 02, day: 03).asDateTime();
  final withSubmissions = true;
  switch (nullParameter) {
    case HomeworkParameter.id:
      return HomeworkReadModel(
          title: title,
          subject: subject,
          id: instead,
          status: done,
          todoDate: todoDate,
          withSubmissions: withSubmissions);
      break;
    case HomeworkParameter.subject:
      return HomeworkReadModel(
        title: title,
        subject: instead,
        id: id,
        status: done,
        todoDate: todoDate,
        withSubmissions: withSubmissions,
      );
      break;
    case HomeworkParameter.title:
      return HomeworkReadModel(
        title: instead,
        subject: subject,
        id: id,
        status: done,
        todoDate: todoDate,
        withSubmissions: withSubmissions,
      );
      break;
    case HomeworkParameter.done:
      return HomeworkReadModel(
        title: title,
        subject: subject,
        id: id,
        status: instead,
        todoDate: todoDate,
        withSubmissions: withSubmissions,
      );
      break;
    case HomeworkParameter.date:
      return HomeworkReadModel(
        title: title,
        subject: subject,
        id: id,
        status: done,
        todoDate: instead,
        withSubmissions: withSubmissions,
      );
      break;
    default:
      throw UnimplementedError('Case not covered');
  }
}
