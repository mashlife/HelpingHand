import 'package:flutter/material.dart';
import 'package:helping_hand/src/utils/colors.dart';

class MyTextField extends StatelessWidget {
  const MyTextField({
// class CustomTextField extends StatelessWidget {
//   const CustomTextField({
    super.key,
    required this.controller,
    this.hintText,
    this.labelText,
    this.hintFontStyle = FontStyle.normal,
    this.suffixIcon,
    this.prefixIcon,
    this.keyboardType,
    this.obsecureText = false,
    this.validator,
    this.onChanged,
    this.focusNode,
    this.selectionControls,
    this.height = 45,
  });

  final TextEditingController controller;
  final String? hintText;
  final String? labelText;
  final FontStyle hintFontStyle;
  final TextInputType? keyboardType;
  final bool obsecureText;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final String? Function(String?)? validator;
  final String? Function(String?)? onChanged;
  final FocusNode? focusNode;
  final MaterialTextSelectionControls? selectionControls;
  final double height;

  @override
  Widget build(BuildContext context) {
    double borderRadius = 12;
    double fontSize = 12;

    return Container(
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
        color: AppColors.textField,
      ),
      child: TextField(
        autocorrect: false,
        textAlign: TextAlign.start,
        textAlignVertical: TextAlignVertical.center,
        controller: controller,
        style: TextStyle(
          fontSize: fontSize,
          fontWeight: FontWeight.bold,
          color: AppColors.texty,
        ),
        obscureText: obsecureText,
        keyboardType: keyboardType,
        decoration: InputDecoration(
            hintText: hintText,
            labelText: labelText,
            suffixIcon: SizedBox(
              height: 18,
              width: 18,
              child: suffixIcon,
            ),
            prefixIcon: prefixIcon,
            hintStyle: TextStyle(
              fontSize: fontSize,
              fontStyle: hintFontStyle,
              fontWeight: FontWeight.bold,
              color: AppColors.texty,
            ),
            labelStyle:
                const TextStyle(fontWeight: FontWeight.bold, letterSpacing: 3),
            enabledBorder: OutlineInputBorder(
              borderSide:
                  BorderSide(color: AppColors.placeHolder.withOpacity(0.4)),
              borderRadius: BorderRadius.circular(borderRadius),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide:
                  BorderSide(color: AppColors.placeHolder.withOpacity(0.4)),
              borderRadius: BorderRadius.circular(borderRadius),
            ),
            errorBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.red),
              borderRadius: BorderRadius.circular(borderRadius),
            )),
        onChanged: onChanged,
        focusNode: focusNode,
        selectionControls: selectionControls,
      ),
    );
  }
}
