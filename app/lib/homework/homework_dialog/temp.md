Nächster Schultag ist fürs erste Fest.
Es können unterschiedliche Wert für "in _ Stunden" ausgewählt werden.

Wenn ein Datum ausgewählt wird

Bloc muss Datum zurückgeben, aber auch ob das Datum einfach so gewählt wurde oder
eins von den Chips benutzt wurde.

Wenn man einen bereits existierenden Chip erstellt (z.B. Übernächste Stunde), dann wird kein neuer
Chip erstellt sondern der existierende als aktiv ausgewählt.

Was ist, falls bei der Berechnung des letztendlichen Datums (bei in X Stunden) etwas fehlschlägt?
z.B. Ferien können nicht geladen werden, aktuell wird dann einfach die Berechnung ohne Ferien durchgeführt.
Es können aber auch andere Daten (List<Lesson> lessons oder AppUser) potentiell nicht geladen werden.
Sollten wir dann einfach die Berechnung ohne diese Daten durchführen oder den User informieren?
--> Einfach: Falls Ferien nicht geladen werden könnnen, dann ignorieren wir sie einfach.
    Falls ein Fehler auftritt, zeigen wir entweder Dialog oder machen einfach das Datums-Feld rot.
--> Besser/Komplexer: Wenn beim Berechnen der Stunden Ferien mit eingeflossen sind, dann gibt es einen
    kleinen Infotext ("Aufgrund von Ferien wurden X Stunden ignoriert").
    Fehlertext, falls Ferien nicht geladen werden können.

Falls noch kein Kurs ausgewählt wurde, dann kann man keinen Stundenchip benutzen (ausgrauen?)
Falls ein ausgwählter Kurs keine Stundenbelegungen hat, dann kann man keine Stundenchips benutzen (ausgrauen?)