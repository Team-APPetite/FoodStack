import 'package:flutter/material.dart';

class ThemeColors {
  static Color yellows = Color(hexColor('#F8B736'));
  static Color oranges = Color(hexColor('#F78E28'));
  static Color teals = Color(hexColor('#2B888B'));
  static Color greens = Color(hexColor('#27704F'));
  static Color dark = Color(hexColor('#213037'));
  static Color mint = Color(hexColor('#5EA692'));
  static Color light = Color(hexColor('#DFDDDB'));

  static int hexColor(String color) {
    String hexStr = '0xff' + color;
    hexStr = hexStr.replaceAll('#', '');
    int hexColor = int.parse(hexStr);
    return hexColor;
  }
}
