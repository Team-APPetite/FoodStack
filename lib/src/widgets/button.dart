import 'package:flutter/material.dart';
import 'package:foodstack/src/styles/themeColors.dart';

class AppButton extends StatefulWidget {
  final String buttonText;
  final void Function() onPressed;

  AppButton({
    @required this.buttonText,
    this.onPressed
  });

  @override
  _AppButtonState createState() => _AppButtonState();
}

class _AppButtonState extends State<AppButton> {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 80.0, vertical: 16.0),
        child: Text(
          widget.buttonText,
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 16.0),
        ),
      ),
      onPressed: widget.onPressed,
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
        primary: ThemeColors.oranges,
      ),
    );
  }
}
