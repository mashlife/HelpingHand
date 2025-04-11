import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:helping_hand/src/utils/colors.dart';
import 'package:helping_hand/src/utils/text.dart';

class SubmitButton extends StatelessWidget {
  final Color? buttonColor;
  final double horizontalPadding;
  final double verticalPadding;
  final double buttonHeight;
  final double buttonWidth;
  final double buttonRadius;
  final VoidCallback onPress;
  final String? text;
  final bool isLoading;
  final double fontSize;
  final FontWeight fontWeight;
  final Color fontColor;
  final bool isOutlined;
  const SubmitButton({
    super.key,
    this.buttonColor,
    this.buttonHeight = 46,
    this.horizontalPadding = 0,
    this.verticalPadding = 0,
    this.buttonRadius = 10,
    this.buttonWidth = double.infinity,
    required this.onPress,
    this.text,
    this.isLoading = false,
    this.isOutlined = false,
    this.fontSize = 20,
    this.fontWeight = FontWeight.w600,
    this.fontColor = AppColors.creamWhite,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: horizontalPadding, vertical: verticalPadding),
      child: SizedBox(
        width: buttonWidth,
        height: buttonHeight,
        child: ElevatedButton(
            onPressed: onPress,
            style: ElevatedButton.styleFrom(
                backgroundColor:
                    buttonColor ?? AppColors.secondaryGradient.withGreen(40),
                padding: const EdgeInsets.all(0),
                shape: RoundedRectangleBorder(
                  side: BorderSide(
                      color: isOutlined
                          ? AppColors.secondary
                          : Colors.transparent),
                  borderRadius: BorderRadius.circular(buttonRadius),
                )),
            child: Center(
              child: isLoading
                  ? const CupertinoActivityIndicator(
                      color: Colors.white,
                    )
                  : MyText(
                      text: text ?? "Continue",
                      fontColor: fontColor,
                      fontWeight: fontWeight,
                      fontSize: fontSize,
                    ),
            )),
      ),
    );
  }
}
