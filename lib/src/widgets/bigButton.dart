import 'package:flutter/material.dart';

class BigButton extends StatefulWidget {
  final String keyString;
  final String buttonText;
  final IconData icon;
  final Color color;
  final void Function() onPressed;

  BigButton({
    this.keyString,
    @required this.buttonText,
    this.onPressed,
    this.icon,
    this.color,
  });

  @override
  _BigButtonState createState() => _BigButtonState();
}

class _BigButtonState extends State<BigButton> {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      key: Key(widget.keyString),
      onPressed: widget.onPressed,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 40.0),
        child: Column(
          children: [
            Text(
              widget.buttonText,
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontFamily: 'Montserrat',
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold),
            ),
            Icon(
              widget.icon,
              size: 60,
            ),
          ],
        ),
      ),
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
        primary: widget.color,
      ),
    );
  }
}
