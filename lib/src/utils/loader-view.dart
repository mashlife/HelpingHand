import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:helping_hand/src/utils/colors.dart';
import 'package:helping_hand/src/utils/keyboard-hide-view.dart';

class LoaderView extends StatelessWidget {
  final Color? color;

  const LoaderView({super.key, this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      color: color ?? AppColors.creamWhite,
      child: const Center(
        child: KeyboardHideView(
          child: SpinKitDoubleBounce(
            color: AppColors.primary,
            size: 50.0,
          ),
        ),
      ),
    );
  }
}
