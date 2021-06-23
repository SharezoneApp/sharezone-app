### Group Join Documentation ###

# Zusammenfassung
Das GroupJoin System dient dem Beitreten einer Gruppe mittels eines **Sharecodes** oder eines **JoinLinks**. Dabei sendet der Client eine Join Anfrage an die https-Call Cloudfunction *JoinGroupByValue*. Diese verarbeitet die Anfrage anschließend.

# Parameter bei Anfrage
Folgende Daten müssen an die Cloudfunction übergeben:
- "value" [string]: Der Sharecode oder der JoinLink
- "memberID" [string]: Die UserId des Client Nutzers
- "version" [number]: Die Client-Version, welche GroupJoin Features unterstützt werden. Aktuell verfügbar {1, 2}
- "courseList" [List<string>]: Eine Liste mit courseIds, für das Beitreten einer Klasse. Dieser Parameter ist nur in version 2 verfügbar.

# Response der Anfrage
Als Ergebnis der Anfrage gibt es folgende Responses:
- SuccessfullJoinResult
- RequireCourseSelectionsJoinResult (ab Version 2)
- ErrorJoinResult

# Details zu ErrorJoinResult
Es kann verschiedene Fehler geben, welche zu einem gescheiterten Join Versuch führen:
- NotFound: Der Sharecode/Joinlink ist fehlerhaft und wurde nicht gefunden
- AlreadyMember: Der Nutzer ist bereits Mitglied dieser Gruppe
- NotPublic: Ein Admin der Gruppe hat das Beitreten deaktiviert
- Unknown: Beschreibt einen Unbekannten Fehler in der CloudFunction
- NoInternet: Keine Internetverbindung, diese Fehlermeldung wird auf dem *client* verarbeitet

# Details zu RequireCourseSelectionsJoinResult
Um Wahlkurse in Klassen besser zu unterstützen, kann man bei zukünftigen Beitritsversuchen direkt Auswählen, welchen Kursen man beitreten möchte. Ältere Clients treten automatisch allen Kursen der Klasse bei. Der Ablauf ist dabei folgender:
1. Nutzer schickt Joinanfrage mittels Sharecode/JoinLink
2. Als Response gibt es ein **RequireCourseSelectionsJoinResult**. Dieses beinhaltet als Information eine Map mit Informationen über verfügbare Kurse.
3. Der Nutzer wählt beim sich öffnenden Dialog die gewünschten Kurse aus und schickt erneut eine Anfrage, dieses mal fügt er die gewünschten Kurse als Liste hinzu.
4. Der Client wirft ein **SuccessfullJoinResult** zurück.

# Edge-Cases

- *Was passiert, wenn während des JoinVersuchs ein neuer Kurs hinzugefügt wird?*
Aktuell wird der Nutzer dann diesem Kurs nicht hinzugefügt, wenn er eine eigene Auswahl erledigt hat. Stattdessen tritt er nur den Kursen seiner Auswahl bei. Alternative Ideen siehe: https://gitlab.com/codingbrain/sharezone/sharezone-app/-/merge_requests/377#note_383244137 
