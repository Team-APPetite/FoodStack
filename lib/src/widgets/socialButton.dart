import 'package:flutter/material.dart';

class SocialButton extends StatefulWidget {
  final Image image;
  final void Function() onPressed;
  SocialButton({
    @required this.image,
    this.onPressed
  });

  @override
  _SocialButtonState createState() => _SocialButtonState();
}

class _SocialButtonState extends State<SocialButton> {
  @override
  Widget build(BuildContext context) {
    return FittedBox(
      fit: BoxFit.scaleDown,
      child: SizedBox(
        height: 60,
        width: 60,
        child: ElevatedButton(
          child: widget.image,
          style: ElevatedButton.styleFrom(
              shape: CircleBorder(), primary: Colors.white),
          onPressed: widget.onPressed,
        ),
      ),
    );
  }
}
