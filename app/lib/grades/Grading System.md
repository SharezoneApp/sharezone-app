# Notensystem

0-15 (Natürliche Zahlen inkl. 0)
1-6 (Natürliche Zahlen)
6-1
1-6 (Mit Kommazahlen)
Prozente 0-100%
“9-1” System
Bestanden/Nicht bestanden

## Bereiche

### Verschiedene Notensysteme

Als erste Stufe könnte ich sagen, dass ein Halbjahr ein gewisses Notensystem hat, und dass nur Noten mit diesem Notensystem mit in den Schnitt eingerechnet werden. Das würde wahrscheinlich auch erstmal bedeuten, dass jedes Fach auch das selbe Notensystem nutzen muss, um die Durchschnittsnote auszurechnen.
In Zukunft könnte man noch "Übersetzungstabellen" für Notensysteme hinzufügen, sodass man z.B. auch Noten aus dem 1-6 System in das 0-15 Punkte System umrechnen kann. Das würde dann heißen, dass alle Noten, die in das vom Halbjahr genutze Notensystem übersetzt werden können, mit in den Schnitt eingerechnet werden.

* Eine Note eines Notensystems in gut/mittel/schlecht kategorisieren.
* Note in Schnitt einbringen, falls Notensystem dem Halbjahr entspricht.
* Darstellungen von Durchschnittsnoten einbauen.

Notizen zur Entwicklung:

Wir können davon ausgehen, dass alle Notensysteme (für jetzt) linear sind.
Wir sollten eigentlich jedes Notensystem an einen Zahlenbereich binden können, womit wir nachher eine Durchschnittsnote als double errechnen können.
Diese Durchschnittsnote müsste dann von Double wieder zurück in das Notensystem übersetzt werden für die Darstellung.

ACHTUNG PLANÄNDEURNG: Nicht nächste Note für Durchscnittsnote verwenden, sondern immer die nächst schlechtere.

Darstellung so: ≈2+ (1,6)
GradesService:
Nächste Note: z.B. 2+ (eigenen Datentyp für Note aus Notensystem?)
Durchschnittsnote: z.B. 2,3 (num)
Controller:
Nächste Note: z.B. 2+ (String)
Durchschnittsnote: z.B. 2,3 (String)

Die Durchschnittsnote, die angezeigt wird, könnte sich auch von den auswählbaren Noten unterscheiden. Beispielsweise kann man im System 1-6(+-) keine 1,5 Note geben, aber die Durchschnittsnote könnte 1,5 sein, also genau zwischen 1- und 2+ liegen. Das könnte man als "1-2" darstellen, auch wenn es dieses Format bei der Eingabe gar nicht gibt.

Warnung bei Note hinzufügen anzeigen, falls das für die Note gewählte Notensystem nicht mit dem Notensystem übereinstimmt, welches für das Halbjahr gewählt wurde. Es sollte vielleicht auch zusätzlich auch der Toggle "Note in Schnitt einbringen" deaktiviert werden, dass keine Verwirrung entsteht, ob es jetzt in den Schnitt einfließt oder nicht.

#### PR Notizen

* Für das Notensystem 1+-6 würde ich erstmal nur eine Kommanote anzeigen, anstatt z.B. 2+. Das reduziert erstmal Komplexität. Nachher können wir das noch erweitern.
* Noch keine Icons für GradeTypes eingebaut, da ich noch nicht weiß, wie die Daten dafür genau aussehen.

TODOs:

* Was ist wenn in den weight maps von Firestore eine unbekannte GradeTypeId drinnen steht, der entsprechende GradeType aber nicht im Dokument steht?
* Was ist wenn in den weight maps von Firestore eine unbekannte SubjectId drinnen steht, das entsprechende Subject aber nicht im Dokument steht?
* GradePerformance implementieren

### Kurse und Fächer

UI: Liste wird angezeigt mit den aktiven Kursen des Nutzers und alle Kurse, die eine Note eingetraben haben, aber der Nutzer nicht mehr in dem Kurs ist.

---

Text / Kein Notensystem → z.B. um Zeiten/Ergebnisse bei Sport einzutragen? Würde für uns wenig extra Arbeit sein, aber könnte viele Anwendungsfälle der Nutzer abdecken, an die wir noch gar nicht denken

takeIntoAccount muss bei changeWeight geändert werden, z.B. falls takeIntoAccount erst true war, dann muss die Note 0 weight haben und falls das weight geändert wird, muss takeIntoAccount auf true gesetzt werden.

weight in Prozent und Faktor angebbar

WeightType sollte auch WeightType.inherit haben, dass das vom Term übernommen wird.

Weight bei Grade ist nur bei individuellen Noten relevant, bei NotenTypen ist dann die falsche Weight abzulesen. Das ist verwirrend und sollte geändert werden.

Bei test code prüfen, dass grade weights nicht angegeben sind, wenn woanders schon weights angegeben sind (term, subject)

Note mit Klausur per Id verknüpfen?

Notentyp fürs erste erst löschbar machen, wenn keine Noten mehr existieren, die diesen Notentyp verwenden.

Testen, dass überschriebene Weights bei De- und Reaktivierung bestehen bleiben.
--> Was passiert, wenn man einen GradeType löscht, der noch in einer weights map steht?
--> Was passiert, wenn man eine Note löscht, die noch in einer weights map steht?

Überall num anstatt double oder int verwenden

finalGradeType bei erstellung von Term required machen

Bei mehreren final grades, sollte das zuletzt hinzugefügte genommen werden

**Noten mit + und -**:

* 1+ = 0,75
* 1 = 1
* 1- = 1,25
* 2+ = 1,75
* 2 = 2
* 2- = 2,25
* 3+ = 2,75
* 3 = 3
* 3- = 3,25
* 4+ = 3,75
* 4 = 4
* 4- = 4,25
* 5+ = 4,75
* 5 = 5
* 5- = 5,25
* 6 = 6

Weight:

Klausur (3) 10%
Vokabeltest (1) 20%
Klausur (2) 70%

(3+1+2)/3 = 2

--> Was falls nicht 100%?

3*0,1 + 1*0,2 + 2*0,7
0,3+0,2+1,4 = 1,9
1,9/3 = 0,6333333333333333

3 *1-0,1 + 1* 1-0,2 + 2 *1-0,7
3*0,9 + 1*0,8 + 2*0,3 = 2,7 + 0,8 + 0,6 = 4,1

```dart
    test('unknown grade types in weight maps will be ignored', () {
      final controller = GradesTestController();

      final term = termWith(
        gradeTypeWeights: {
          const GradeTypeId('Unknown'): const Weight.factor(3),
          const GradeType.presentation().id: const Weight.factor(3),
        },
        subjects: [
          subjectWith(
            id: const SubjectId('Deutsch'),
            grades: [
              gradeWith(value: 3.0, type: const GradeType.presentation().id),
            ],
          ),
        ],
      );
      createTerm() =>
          controller.createTerm(term, createMissingGradeTypes: false);
      changeWeights() => controller.changeTermWeightsForSubject(
              termId: term.id,
              subjectId: const SubjectId('Deutsch'),
              gradeTypeWeights: {
                const GradeType.presentation().id: const Weight.factor(2),
                const GradeTypeId('Foo'): const Weight.factor(3),
                const GradeTypeId('Bar'): const Weight.factor(3),
              });

      expect(createTerm, returnsNormally);
      expect(changeWeights, returnsNormally);
      final termRes = controller.term(term.id);
      expect(
        termRes.gradeTypeWeights.keys,
        [const GradeType.presentation().id],
      );
      expect(
        termRes.subject(const SubjectId('Deutsch')).gradeTypeWeights.keys,
        [const GradeType.presentation().id],
      );
    });
```
