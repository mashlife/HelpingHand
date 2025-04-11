import 'package:flutter/material.dart';
import 'package:helping_hand/src/utils/colors.dart';

// ignore: must_be_immutable
class MyText extends StatelessWidget {
  String text;
  double fontSize;
  FontWeight fontWeight;
  Color? fontColor;
  double? wordSpacing, letterSpacing;
  TextAlign textAlignment;
  bool textOverflow;
  double height;
  TextDecoration textDecoration;
  List<Shadow>? shadows;
  MyText({
    super.key,
    required this.text,
    this.fontSize = 14,
    this.fontWeight = FontWeight.w400,
    this.fontColor,
    this.textOverflow = false,
    this.textAlignment = TextAlign.start,
    this.height = 1.2,
    this.letterSpacing,
    this.wordSpacing,
    this.textDecoration = TextDecoration.none,
    this.shadows,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      overflow: textOverflow ? TextOverflow.ellipsis : null,
      textAlign: textAlignment,
      style: TextStyle(
          color: fontColor ?? AppColors.texty,
          fontSize: fontSize,
          wordSpacing: wordSpacing,
          letterSpacing: letterSpacing,
          shadows: shadows,
          fontWeight: fontWeight,
          height: height,
          decoration: textDecoration),
    );
  }
}
