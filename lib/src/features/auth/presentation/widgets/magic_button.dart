import 'package:flutter/material.dart';
import 'package:search3/src/core/presentation/colors/colors.dart';

class MagicButton extends StatelessWidget {

  final String text;
  final Color color;
  final double width;
  final double height;
  final Color textColor;
  final double textSize;
  final Function onClick;

  const MagicButton({
    super.key,
    required this.text,
    required this.onClick,
    this.width = double.maxFinite,
    this.height = 60,
    this.textSize = 24,
    this.color = AppColors.mainColor,
    this.textColor = AppColors.textColor
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onClick(),
      child: IntrinsicWidth(
        child: Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(30)
          ),
          width: width,
          height: height,
          child: Text(
            text,
            style: TextStyle(
              color: textColor,
              fontSize: textSize
            ),
          ),
        ),
      ),
    );
  }
}