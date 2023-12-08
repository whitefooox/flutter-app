import 'package:flutter/material.dart';

class MagicInputField extends StatefulWidget {

  final double width;
  final double height;
  final String placeholderText;
  final double textSize;
  final bool isSecret;
  final Function(String) onChange;

  const MagicInputField({
    super.key,
    required this.placeholderText,
    required this.onChange,
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
        onChanged: (text) => widget.onChange(text),
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