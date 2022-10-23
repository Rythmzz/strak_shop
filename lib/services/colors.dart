import 'dart:ui';

class StrakColor{

  static final Color colorTheme1 = hexToColor("#051e3e");
  static final Color colorTheme2 = hexToColor("#251e3e");
  static final Color colorTheme3 = hexToColor("#451e3e");
  static final Color colorTheme4 = hexToColor("#651e3e");
  static final Color colorTheme5 = hexToColor("#851e3e");

  static final Color colorTheme6 = hexToColor("#e7eff6 ");
  static final Color colorProduct = Color(223263);

  static final Color colorTheme7 = hexToColor("#223263");

}

Color hexToColor(String code) {
  return new Color(int.parse(code.substring(1, 7), radix: 16) + 0xFF000000);
}
