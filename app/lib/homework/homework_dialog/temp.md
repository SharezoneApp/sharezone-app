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

Was passiert wenn man den aktiv ausgewählten Chip (5.-nächste Stunde) löscht? Bleibt der Chip dann einfach
implizit aktiv, solange man keinen anderen auswählt (oder ein anders Datum nimmt) oder wird dann der Wert
aus dem Datumsfeld gelöscht und kein Chip ist aktiv?

Falls noch kein Kurs ausgewählt wurde, dann kann man keinen Stundenchip benutzen (ausgrauen?)
Falls ein ausgwählter Kurs keine Stundenbelegungen hat, dann kann man keine Stundenchips benutzen (ausgrauen?)
--> "Nächster Schultag" ist nicht ausgegraut und auswählbar
--> Sollte "Benutzerdefiniert" auch ausgegraut sein? Hätte ja gesagt, weil es einheitlicher mit den ausgegrauten Stundenchips
    aussehen wird und man dort ja eh nur Stundenchips erstellen kann, die man nicht auswählen kann.

States:
1. Kein Kurs ausgewählt --> Ausgegraute Chips außer "Nächster Schultag"
2. Ein Default-Chip ausgewählt
3. Ein Benutzerdefinierten-Chip ausgewählt (und vielleicht einen anderen nicht ausgewählt)