
/// Der EventChangeType gibt an, wie sich der Termin zu den Stundenverhält.
/// [NONE] => Stunden bleiben so.
/// [CHANGE] => Der Termin stellt eine Änderung der Stunden dar
/// [ELIMINATION] => Durch den Termin entfallen die Stunden.
enum CalendricalEventChangeType {
  none,
  change,
  elimination,
}
