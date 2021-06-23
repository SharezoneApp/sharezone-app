import 'package:purchases_flutter/object_wrappers.dart';

class PurchasesErrorTranslator {
  static String getTranslatedMessage(PurchasesErrorCode error) {
    const tryItAgain = 'Versuche es einfach nochmal 👍';
    const plsContactSupport = 'Bitte kontaktiere den Support.';

    if (error == PurchasesErrorCode.networkError) {
      return 'Es gab einen Fehler mit deiner Internetverbindung! $tryItAgain';
    }
    if (error == PurchasesErrorCode.operationAlreadyInProgressError) {
      return 'Es scheint so, dass ein bereits getätigter Kauf noch verarbeitet wird. Warte einfach einen kurzen Moment, bis dieser verarbeitet wurde.';
    }
    if (error == PurchasesErrorCode.invalidCredentialsError) {
      return 'Der API-Key wurde falsch konfiguriert. $plsContactSupport';
    }
    if (error == PurchasesErrorCode.invalidAppUserIdError) {
      return 'Deine User-Id ist ungültig. $plsContactSupport';
    }
    if (error == PurchasesErrorCode.purchaseCancelledError) {
      return 'Der Kauf wurde abgebrochen.';
    }
    if (error == PurchasesErrorCode.invalidReceiptError) {
      return 'Es gab einen Fehler bei der Rechnung. $plsContactSupport';
    }
    if (error == PurchasesErrorCode.productNotAvailableForPurchaseError) {
      return 'Dieses Produkt ist nicht mehr verfügbar.';
    }
    if (error == PurchasesErrorCode.receiptAlreadyInUseError) {
      return 'Die Rechnung wird bereits von einem anderen User verwendet. $plsContactSupport';
    }
    if (error == PurchasesErrorCode.missingReceiptFileError) {
      // Dieser Fehler tritt bei Sandbox-Testing häufiger auf.
      return 'Es ist kein Rechnung vorhanden... $plsContactSupport';
    }
    if (error == PurchasesErrorCode.purchaseNotAllowedError) {
      return 'Dieses Gerät darf keine Käufe tätigen 🙁';
    }
    if (error == PurchasesErrorCode.paymentPendingError) {
      return 'Es ist ein weiterer Schritt bei der Bezahlung notwenig. Bitte beende diesen Schritt.';
    }
    if (error == PurchasesErrorCode.purchaseInvalidError) {
      return 'Es gab einen Fehler beim Kauf. Bitte überprüfe, ob die Zahlungsmethode gültig ist.';
    }
    if (error == PurchasesErrorCode.productAlreadyPurchasedError) {
      return 'Das Produkt wurde bereits gekauft.';
    }
    if (error == PurchasesErrorCode.storeProblemError) {
      return 'Es gab einen Fehler beim App- oder PlayStore. $tryItAgain';
    }
    if (error == PurchasesErrorCode.unexpectedBackendResponseError) {
      return 'Es gab eine unerwartete Fehlermeldung vom Server. $plsContactSupport';
    }
    if (error == PurchasesErrorCode.unknownBackendError) {
      return 'Es gab einen Fehler beim Server. $plsContactSupport';
    }
    return 'Es gab beim Kauf einen unbekannten Fehler. $plsContactSupport';
  }
}
