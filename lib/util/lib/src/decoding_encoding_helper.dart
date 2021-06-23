bool parseBool(String boolString) {
  var lowerCase = boolString.toLowerCase();
  if (lowerCase == 'true') return true;
  if (lowerCase == 'false') return false;
  throw Exception('Konnte bool von dem String $boolString nicht parsen');
}
