// ignore:avoid_web_libraries_in_flutter
import 'dart:html';

void openWebFile(String url, String name) {
  AnchorElement linkElement = AnchorElement();
  linkElement.href = url;
  linkElement.target = '_blank';
  linkElement.click();
}
