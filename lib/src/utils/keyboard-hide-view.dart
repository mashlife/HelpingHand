import 'package:flutter/material.dart';

class KeyboardHideView extends StatelessWidget {
  final Widget? child;

  const KeyboardHideView({super.key, @required this.child})
      : assert(child != null);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);

        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: child,
    );
  }
}
