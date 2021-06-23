### Anmeldungsflow für den QR-Code-Login:

Geräte:
* Gerät 1 "Handy" (Authentifiziert)
* Gerät 2 "Web-App" (Unauthentifiziert)
* Server "Cloud-Function" (Authentifiziert) - Wird von uns als sicher betrachtet, d.h. führt 100% unseren Code unverändert aus.

Glossar:  
* **AES-Verschlüsselung** - Eine symmetrische Verschlüsselung. Arbeitet auch bei großen Datenmengen sehr schnell.
*  **IV** - Ein Initalisierungvektor für die AES-Verschlüsselung. Wird als zufälliger "Startpunkt" der Verschlüsselung benutzt, damit nicht gleiche Nachrichten die gleichen "Kennzeichen" aufweisen (nach meinem Verständnis).
* **RSA-Verschlüsselung** - Eine asymmetrische Verschlüsselung, wo es einen privaten und öffentlichen Schlüssel gibt. Ist langsam und für große Datenmengen ungeeignet.
*  **privater (RSA)-Schlüssel** - Der Schlüssel, welcher private (also bei der Web-App) bleibt, um die mit dem öffentlichen RSA-Schlüssel verschlüsselten Daten zu entschlüsseln.
*  **öffentlicher (RSA)-Schlüssel** - Der Schlüssel, mit welchem der Server Daten verschlüsseln kann, die nur der Halter des privaten Schlüssels entschlüsseln kann (Web-App)
*  **Nutzer-ID** - Die eindeutige User-ID, von Firebase Auth bei Registrierung generiert
*  **QR-Code-ID** - Ein eindeutige, zufällige ID, die genau auf diesen QR-Code weißt.
*  **Custom-Token** - Ein JWT (JSON-Web-Token), mit welchem sich ein Client per Firebase Authentication anmelden kann. Dieser kann nur von einem Server generiert werden. 

***Web-App Seite zur QR-Code Anmeldung wird geöffnet***
1. Web-App generiert einen privaten und öffentlichen RSA-Schlüssel.  
2. Web-App generiert einen QR-Code mit einer zufälligen ID.  
3. Web-App speichert in Firestore ein Dokument mit der QR-Code-ID, und dem öffentlichen Schlüssel.  
4. Web-App hört auf Änderungen dieses Dokumentes.

***Handy wird zum Einscannen des QR-Codes benutzt***
1. Handy scannt QR-Code ein und erhält die QR-Code-ID.    
2. Handy schickt die Nutzer-ID und die QR-Code-ID an eine Cloud-Function.

***Cloud-Function wird aktiviert***
1. Cloud-Function erhält die Nutzer-ID und die QR-Code-ID des Nutzers.  
2. Cloud-Function erstellt für die erhaltende Nutzer-ID ein Custom-Token.
3. Cloud-Function verschlüsselt den Custom-Token per AES (1)
4. Cloud-Function verschlüsselt den AES-Schlüssel per öffentlichen RSA-Schlüssel
5. Cloud-Function fügt den verschlüsselten Custom-Token, den verschlüsselten AES-Schlüssel, und den IV zu dem Dokument hinzu. (2)

***Web-App wird über die Veränderten Daten in dem Dokument informiert***
1. Web-App entschlüsselt den verschlüsselten AES-Schlüssel mithilfe des privaten RSA-Schlüssels.
2. Web-App entschlüsselt den verschlüsselten Custom-Token per entschlüsselten AES-Schlüssel.
3. Web-App authentifiziert sich mithilfe des Custom-Tokens bei Firebase Authentication.


(1) **Warum wird AES + RSA benutzt - warum reicht RSA alleine nicht aus**?      
Die RSA Verschlüsselung ist begrenzt. Nicht nur ist diese langsamer, sie kann nur eine bestimmte Größe verschlüsseln. Ein 2048bit Schlüssel kann bloß (2048 / 8) -11 bytes verschlüsseln, also 245 bytes. Siehe: https://security.stackexchange.com/questions/33434/rsa-maximum-bytes-to-encrypt-comparison-to-aes-in-terms-of-security Ein Token mit höherer BitSize ist daher zu lang und würde riesige PublicKeys benötigen, diese zu generieren würde schon ewig lange dauern. Nun gibt es zwei Möglichkeiten: Token spliten und in <245bytes Teilen verschlüsseln. Dabei entsteht pro Part ein Overhead von 11 bytes + Performance Nachteile. Oder eben mit einer symetrischen Verschlüsselung. Dann wird nur der Schlüssel der symetrischen Verschlüsselung dann bloß asymetrisch verschlüsselt. Ist gängige Praxis diese Kombination von asymetrischer und symmetrischer Verschlüsselung. https://security.stackexchange.com/questions/203286/how-to-combine-symmetric-and-asymmetric-encryption-to-encrypt-large-files

(2) Der IV muss zwar bei einer einmaligen Verschlüsselung nicht unbedingt gegeben sein, die Libraries wollen aber das man einen angibt.