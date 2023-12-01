import 'package:flutter/material.dart';

class MagicInputField extends StatefulWidget {

  final double width;
  final double height;
  final String placeholderText;
  final double textSize;
  final bool isSecret;

  const MagicInputField({
    super.key,
    required this.placeholderText,
    this.width = double.maxFinite,
    this.height = 60,
    this.textSize = 24,
    this.isSecret = false
  });

  @override
  State<MagicInputField> createState() => _MagicInputFieldState();
}

class _MagicInputFieldState extends State<MagicInputField> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width,
      height: widget.height,
      child: TextField(
        obscureText: widget.isSecret,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: widget.textSize
        ),
        decoration: InputDecoration(
          hintText: widget.placeholderText,
          border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(30))
          )
        ),
      ),
    );
  }
}