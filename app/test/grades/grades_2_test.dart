import 'package:flutter_test/flutter_test.dart';
import 'package:sharezone/grades/grades_service.dart';
import 'package:test_randomness/test_randomness.dart';

void main() {
  group('grades', () {
    test('the term grade of two different subjects in term', () {
      var term = Term(id: TermId('2. Halbjahr'));
      final englisch = Subject('Englisch');

      term = term.addSubject(englisch);
      term = term.subject(englisch.id).addGrade(gradeWith(value: 3.0));
      term = term.subject(englisch.id).addGrade(gradeWith(value: 1.0));
      expect(term.subject(englisch.id).gradeVal, 2.0);

      final mathe = Subject('Mathe');
      term = term.addSubject(mathe);
      term = term.subject(mathe.id).addGrade(gradeWith(value: 2.0));
      term = term.subject(mathe.id).addGrade(gradeWith(value: 4.0));

      expect(term.subject(mathe.id).gradeVal, 3.0);
    });

    test(
        'the term grade should equal the average of the average grades of every subject',
        () {
      var term = Term(id: TermId('2. Halbjahr'));
      final englisch = Subject('Englisch');

      term = term.addSubject(englisch);
      term = term.subject(englisch.id).addGrade(gradeWith(value: 3.0));
      term = term.subject(englisch.id).addGrade(gradeWith(value: 1.0));

      final mathe = Subject('Mathe');
      term = term.addSubject(mathe);
      term = term.subject(mathe.id).addGrade(gradeWith(value: 2.0));
      term = term.subject(mathe.id).addGrade(gradeWith(value: 4.0));

      expect(term.getTermGrade(), 2.5);
    });
    test(
        'the term grade should equal the average of the average grades of every subject taking weightings into account',
        () {
      var term = Term(id: TermId('2. Halbjahr'));
      final englisch = Subject('Englisch');
      term = term.addSubject(englisch);
      term = term.subject(englisch.id).addGrade(gradeWith(value: 3.0));

      final mathe = Subject('Mathe');
      term = term.addSubject(mathe);
      term = term.subject(mathe.id).addGrade(gradeWith(value: 2.0));

      final informatik = Subject('Informatik');
      term = term.addSubject(informatik);
      term = term.subject(informatik.id).addGrade(gradeWith(value: 1.0));

      term = term.subject(englisch.id).changeWeightingForTermGrade(0.5);
      term = term.subject(mathe.id).changeWeightingForTermGrade(1);
      term = term.subject(informatik.id).changeWeightingForTermGrade(2);

      const weight1 = 0.5; // weight for English
      const weight2 = 1; // weight for Math
      const weight3 = 2; // weight for Computer Science

      const sumOfWeights = weight1 + weight2 + weight3;

      const expected = (3 * weight1 + 2 * weight2 + 1 * weight3) / sumOfWeights;
      expect(term.getTermGrade(), expected);
    });
    test(
        'one can add grades that are not taken into account for the term and subject grade',
        () {
      var term = Term(id: TermId('2. Halbjahr'));
      final englisch = Subject('Englisch');
      term = term.addSubject(englisch);
      term = term.subject(englisch.id).addGrade(gradeWith(value: 1.0));
      term = term
          .subject(englisch.id)
          .addGrade(gradeWith(value: 1.0), takeIntoAccount: false);
      expect(term.subject(englisch.id).gradeVal, 1.0);

      final mathe = Subject('Mathe');
      term = term.addSubject(mathe);
      term = term.subject(mathe.id).addGrade(gradeWith(value: 1.0));
      term = term
          .subject(mathe.id)
          .addGrade(gradeWith(value: 3.0), takeIntoAccount: false);
      expect(term.subject(mathe.id).gradeVal, 1.0);

      expect(term.getTermGrade(), 1.0);
    });

    test('subjects can have custom weights per grade type (e.g. presentation)',
        () {
      var term = Term(id: TermId('2. Halbjahr'));
      final englisch = Subject('Englisch');
      term = term.addSubject(englisch);

      term = term
          .subject(englisch.id)
          .changeWeightingType(WeightType.perGradeType);
      term = term
          .subject(englisch.id)
          .addGrade(gradeWith(value: 2.0, type: GradeType('presentation')));
      term = term
          .subject(englisch.id)
          .addGrade(gradeWith(value: 1.0, type: GradeType('exam')));
      term = term
          .subject(englisch.id)
          .addGrade(gradeWith(value: 1.0, type: GradeType('vocabulary test')));
      term = term
          .subject(englisch.id)
          .changeGradeTypeWeighting(GradeType('presentation'), weight: 0.7);
      term = term
          .subject(englisch.id)
          .changeGradeTypeWeighting(GradeType('exam'), weight: 1.5);

      const weight1 = 0.7; // weight for presentation
      const weight2 = 1.5; // weight for exam
      const weight3 = 1; // default weight for vocabulary test

      const sumOfWeights = weight1 + weight2 + weight3;

      const expected = (2 * weight1 + 1 * weight2 + 1 * weight3) / sumOfWeights;
      expect(term.subject(englisch.id).gradeVal, expected);
    });

    test(
        'subjects can have custom weights per grade type 2 (e.g. presentation)',
        () {
      // Aus Beispiel: https://www.notenapp.com/2023/08/01/notendurchschnitt-berechnen-wie-mache-ich-es-richtig/
      var term = Term(id: TermId('2. Halbjahr'));
      final mathe = Subject('Mathe');
      term = term.addSubject(mathe);

      term =
          term.subject(mathe.id).changeWeightingType(WeightType.perGradeType);

      term = term
          .subject(mathe.id)
          .changeGradeTypeWeighting(GradeType('Schulaufgabe'), weight: 2);
      term = term
          .subject(mathe.id)
          .changeGradeTypeWeighting(GradeType('Abfrage'), weight: 1);
      term = term
          .subject(mathe.id)
          .changeGradeTypeWeighting(GradeType('Mitarbeitsnote'), weight: 1);
      term = term
          .subject(mathe.id)
          .changeGradeTypeWeighting(GradeType('Referat'), weight: 1);

      term = term
          .subject(mathe.id)
          .addGrade(gradeWith(value: 2.0, type: GradeType('Schulaufgabe')));
      term = term
          .subject(mathe.id)
          .addGrade(gradeWith(value: 3.0, type: GradeType('Schulaufgabe')));
      term = term
          .subject(mathe.id)
          .addGrade(gradeWith(value: 1.0, type: GradeType('Abfrage')));
      term = term
          .subject(mathe.id)
          .addGrade(gradeWith(value: 3.0, type: GradeType('Abfrage')));
      term = term
          .subject(mathe.id)
          .addGrade(gradeWith(value: 2.0, type: GradeType('Mitarbeitsnote')));
      term = term
          .subject(mathe.id)
          .addGrade(gradeWith(value: 1.0, type: GradeType('Referat')));

      expect(term.subject(mathe.id).gradeVal, 2.125);
    });
    test('subjects can have custom weights per grade', () {
      var term = Term(id: TermId('2. Halbjahr'));
      final englisch = Subject('Englisch');
      term = term.addSubject(englisch);

      final grade1 = gradeWith(value: 1.0);
      final grade2 = gradeWith(value: 4.0);
      final grade3 = gradeWith(value: 3.0);

      term = term.subject(englisch.id).addGrade(grade1);
      term = term.subject(englisch.id).addGrade(grade2);
      term = term.subject(englisch.id).addGrade(grade3);
      term = term.subject(englisch.id).changeWeightingType(WeightType.perGrade);

      term =
          term.subject(englisch.id).grade(grade1.id).changeWeight(weight: 0.2);
      term = term.subject(englisch.id).grade(grade2.id).changeWeight(weight: 2);
      // grade3 has the default weight of 1

      const weight1 = 0.2;
      const weight2 = 2;
      const weight3 = 1; // default weight

      const sumOfWeights = weight1 + weight2 + weight3;

      const expected = (1 * weight1 + 4 * weight2 + 3 * weight3) / sumOfWeights;
      expect(expected, closeTo(3.5, 0.01));
      expect(term.subject(englisch.id).gradeVal, expected);
    });
    test(
        'grades for a subject will be weighted by the settings in term by default',
        () {
      var term = Term(id: TermId('2. Halbjahr'));
      final englisch = Subject('Englisch');
      term = term.addSubject(englisch);

      final grade1 = gradeWith(value: 1.0, type: GradeType('foo'));
      final grade2 = gradeWith(value: 3.0, type: GradeType('bar'));
      term = term.subject(englisch.id).addGrade(grade1);
      term = term.subject(englisch.id).addGrade(grade2);

      term = term.changeWeightingOfGradeType(grade1.type, weight: 3);
      term = term.changeWeightingOfGradeType(grade2.type, weight: 1);

      expect(term.subject(englisch.id).gradeVal, 1.5);
      expect(term.getTermGrade(), 1.5);
    });
    test(
        'weighting of grades can be changed for a subject, then overridden by the term settings and then changed again so that the first settings are used again',
        () {
      var term = Term(id: TermId('2. Halbjahr'));
      final englisch = Subject('Englisch');
      term = term.addSubject(englisch);

      final grade1 = gradeWith(value: 1.0, type: GradeType('foo'));
      final grade2 = gradeWith(value: 3.0, type: GradeType('bar'));
      term = term.subject(englisch.id).addGrade(grade1);
      term = term.subject(englisch.id).addGrade(grade2);

      term = term
          .subject(englisch.id)
          .changeWeightingType(WeightType.perGradeType);
      term = term
          .subject(englisch.id)
          .changeGradeTypeWeighting(grade1.type, weight: 3);

      expect(term.subject(englisch.id).gradeVal, 1.5);

      // Shouldn't change the grade because custom settings are used in the subject
      term = term.changeWeightingOfGradeType(grade1.type, weight: 1);
      term = term.changeWeightingOfGradeType(grade2.type, weight: 1);

      expect(term.subject(englisch.id).gradeVal, 1.5);
      expect(term.getTermGrade(), 1.5);

      term = term
          .subject(englisch.id)
          .changeWeightingType(WeightType.inheritFromTerm);

      expect(term.subject(englisch.id).gradeVal, 2);
      expect(term.getTermGrade(), 2);

      // Old settings are persisted
      term = term
          .subject(englisch.id)
          .changeWeightingType(WeightType.perGradeType);

      expect(term.subject(englisch.id).gradeVal, 1.5);
      expect(term.getTermGrade(), 1.5);
    });
    test('weight by grade setting in subject is persisted', () {
      var term = Term(id: TermId('2. Halbjahr'));
      final englisch = Subject('Englisch');
      term = term.addSubject(englisch);

      final grade1 = gradeWith(value: 1.0);
      final grade2 = gradeWith(value: 3.0);
      term = term.subject(englisch.id).addGrade(grade1);
      term = term.subject(englisch.id).addGrade(grade2);

      term = term.subject(englisch.id).changeWeightingType(WeightType.perGrade);
      term = term.subject(englisch.id).grade(grade1.id).changeWeight(weight: 3);

      term = term
          .subject(englisch.id)
          .changeWeightingType(WeightType.inheritFromTerm);
      term = term
          .subject(englisch.id)
          .changeWeightingType(WeightType.perGradeType);
      term = term.subject(englisch.id).changeWeightingType(WeightType.perGrade);
      // Old settings are persisted
      expect(term.subject(englisch.id).gradeVal, 1.5);
    });
    test('The "Endnote" grade type overrides the subject grade', () {
      var term = Term(id: TermId('2. Halbjahr'));
      final mathe = Subject('Mathe');
      term = term.addSubject(mathe);
      term = term.setFinalGradeType(GradeType('Endnote'));

      final grade1 = gradeWith(value: 1.0);
      final grade2 = gradeWith(value: 3.0, type: GradeType('Endnote'));
      final grade3 = gradeWith(value: 2.0);
      term = term.subject(mathe.id).addGrade(grade1);
      term = term.subject(mathe.id).addGrade(grade2);
      term = term.subject(mathe.id).addGrade(grade3);

      expect(term.subject(mathe.id).gradeVal, 3.0);
      expect(term.getTermGrade(), 3.0);
    });
    test(
        'Every subject can have a "Endnote" that overrides the terms "Endnote"',
        () {
      var term = Term(id: TermId('2. Halbjahr'));
      final mathe = Subject('Mathe');
      final englisch = Subject('Englisch');
      term = term.addSubject(mathe);
      term = term.addSubject(englisch);
      term = term.setFinalGradeType(GradeType('Endnote'));

      final grade1 = gradeWith(value: 1.0, type: GradeType('Endnote'));
      final grade2 = gradeWith(value: 3.0, type: GradeType('foo'));
      final grade3 = gradeWith(value: 3.0);
      final grade4 = gradeWith(value: 2.0, type: GradeType('Endnote'));
      term = term.subject(mathe.id).addGrade(grade1);
      term = term.subject(mathe.id).addGrade(grade2);
      term = term.subject(englisch.id).addGrade(grade3);
      term = term.subject(englisch.id).addGrade(grade4);

      term = term.subject(mathe.id).changeFinalGradeType(GradeType('foo'));

      expect(term.subject(mathe.id).gradeVal, 3.0);
      expect(term.getTermGrade(), 2.5);

      term = term.subject(mathe.id).inheritFinalGradeTypeFromTerm();
      expect(term.subject(mathe.id).gradeVal, 1.0);
      expect(term.getTermGrade(), 1.5);
    });
  });
}

Grade gradeWith({
  required double value,
  GradeType type = const GradeType('testGradeType'),
}) {
  return Grade(id: GradeId(randomAlphaNumeric(5)), value: value, type: type);
}
