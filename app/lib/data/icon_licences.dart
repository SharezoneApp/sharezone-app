import 'package:sharezone/widgets/settings/icon_license.dart';

class IconsLicenses {
  static String freepik = "Freepik";
  static String pixelPerfect = "Pixel Perfect";
  static String daveGandy = "Dave Gandy";
  static String icomoon = "Icomoon";
  static String smashicons = "Smashicons";

  static String flationURL = "https://www.flaticon.com";
  static String freepikURL = "https://www.flaticon.com/authors/freepik";
  static String daveGandyURL = "https://www.flaticon.com/authors/dave-gandy";
  static String icomoonURL = "https://www.flaticon.com/authors/icomoon";
  static String smashiconsURL = "https://www.flaticon.com/authors/smashicons";

  static String licenseFlation = "Flaticon Basic License";
  static String licenseCC = "Attribution 3.0 Unported (CC BY 3.0)";

  static List<IconListTitle> icons = [
    IconListTitle(
        author: freepik,
        iconPath: 'assets/icons/fire.svg',
        url: freepikURL,
        license: licenseFlation),
    IconListTitle(
        author: freepik,
        iconPath: 'assets/icons/professor.svg',
        url: freepikURL,
        license: licenseFlation),
    IconListTitle(
        author: freepik,
        iconPath: 'assets/icons/ghost.svg',
        url: freepikURL,
        license: licenseFlation),
    IconListTitle(
        author: freepik,
        iconPath: 'assets/icons/parents.svg',
        url: freepikURL,
        license: licenseFlation),
    IconListTitle(
        author: freepik,
        iconPath: 'assets/icons/students.svg',
        url: freepikURL,
        license: licenseFlation),
    IconListTitle(
        author: pixelPerfect,
        iconPath: 'assets/icons/instagram.svg',
        url: flationURL,
        license: licenseFlation),
    IconListTitle(
        author: smashicons,
        iconPath: 'assets/icons/game-controller.svg',
        url: smashiconsURL,
        license: licenseFlation),
    IconListTitle(
        author: daveGandy,
        iconPath: 'assets/icons/email.svg',
        url: daveGandyURL,
        license: licenseCC),
  ];
}
