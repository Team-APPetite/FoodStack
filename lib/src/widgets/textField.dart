import 'package:flutter/material.dart';
import 'package:foodstack/src/styles/textStyles.dart';
import 'package:foodstack/src/styles/themeColors.dart';

class AppTextField extends StatefulWidget {
  final String hintText;
  final TextInputType textInputType;
  final bool obscureText;
  final void Function(String) onChanged;


  AppTextField({
    @required this.hintText,
    this.textInputType = TextInputType.text,
    this.obscureText = false,
    this.onChanged
  });

  @override
  _AppTextFieldState createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  @override
  Widget build(BuildContext context) {
    return TextField(
      keyboardType: widget.textInputType,
      obscureText: widget.obscureText,
      decoration: InputDecoration(
        hintText: widget.hintText,
        hintStyle: TextStyles.hintText(),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: ThemeColors.teals,
            width: 2.0,
          ),
        ),
      ),
      onChanged: widget.onChanged
    );
  }
}
