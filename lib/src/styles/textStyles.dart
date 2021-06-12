import 'package:flutter/material.dart';
import 'package:foodstack/src/styles/themeColors.dart';

class TextStyles {
  static TextStyle title() {
    return TextStyle(
      fontFamily: 'Avenir',
      fontSize: 60.0,
      fontWeight: FontWeight.bold,
      color: ThemeColors.dark,
    );
  }

  static TextStyle heading1() {
    return TextStyle(
      fontFamily: 'Avenir',
      fontSize: 30.0,
      fontWeight: FontWeight.bold,
      color: ThemeColors.dark,
    );
  }

  static TextStyle heading2() {
    return TextStyle(
      color: ThemeColors.dark,
      fontWeight: FontWeight.bold,
      fontFamily: 'Avenir',
      fontSize: 22.0,
    );
  }

  static TextStyle heading3() {
    return TextStyle(
      color: ThemeColors.dark,
      fontWeight: FontWeight.bold,
      fontSize: 16.0,
    );
  }

  static TextStyle body() {
    return TextStyle(
      color: ThemeColors.dark,
      fontSize: 16.0,
    );
  }

  static TextStyle emphasis() {
    return TextStyle(
      color: ThemeColors.teals,
      fontWeight: FontWeight.bold,
      fontSize: 16.0,
    );
  }

  static TextStyle textButton() {
    return TextStyle(
        color: ThemeColors.oranges,
        fontSize: 16.0,
        fontWeight: FontWeight.bold);
  }

  static TextStyle link() {
    return TextStyle(
      color: Colors.grey,
      fontSize: 16.0,
    );
  }

  static TextStyle details() {
    return TextStyle(
      color: ThemeColors.teals,
      fontWeight: FontWeight.bold,
      fontSize: 12.0,
    );
  }

  static TextStyle hintText() {
    return TextStyle(
      fontSize: 12.0,
      color: Colors.grey,
    );
  }
}
