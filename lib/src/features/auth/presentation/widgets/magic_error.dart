import 'package:flutter/material.dart';

class MagicError extends StatelessWidget {

  final double width;
  final double height;
  final double textSize;
  final String message;

  const MagicError({
    super.key,
    required this.message,
    this.height = 60, 
    this.width = double.maxFinite,
    this.textSize = 24,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
          width: width,
          height: height,
          child: Text(
            message,
            style: TextStyle(
              color: Colors.red,
              fontSize: textSize
            ),
          ),
    );
  }

}