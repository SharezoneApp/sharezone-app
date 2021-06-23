import 'package:authentification_base/authentification_base.dart';
import 'package:flutter_test/flutter_test.dart';

main() {
  /// Es kam vor, dass Nutzer bei der Verknüpfung versehentlich ö anstatt 
  /// o in der E-Mail angegeben haben. Da eine E-Mail Adresse sowieso 
  /// niemals Deutsche Umlaute enthalten darf, können wir diese blocken.  
  group('german umlauts should not be allowed', () {
    void testGermanUmlaut(String umlaut) {
      test(': $umlaut', () {
        expect(AuthentificationValidators.isEmailValid('$umlaut@gmail.com'),
            false);
        expect(
            AuthentificationValidators.isEmailValid('test@$umlaut.com'), false);
      });
    }

    testGermanUmlaut("ö");
    testGermanUmlaut("ä");
    testGermanUmlaut("ü");
    testGermanUmlaut("ß");
  });

  test('email adress should contain "@" and "."', () {
    expect(AuthentificationValidators.isEmailValid('test@gmail.com'), true);
  });
}
