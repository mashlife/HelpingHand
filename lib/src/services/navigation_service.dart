import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

enum AnimationType {
  slideLeft,
  slideRight,
  slideUp,
  slideDown,
}

class NavService {
  static GlobalKey<NavigatorState> get navigatorKey => _navigatorKey;
  static final GlobalKey<NavigatorState> _navigatorKey =
      GlobalKey<NavigatorState>();

  add(Widget widget,
      {Function? callback,
      AnimationType? animationType = AnimationType.slideLeft}) {
    FocusManager.instance.primaryFocus!.unfocus();

    if (animationType == AnimationType.slideLeft) {
      navigatorKey.currentState!.push(slideLeft(widget)).then((dynamic value) {
        if (callback != null && value != null) callback(value);
      });
    } else if (animationType == AnimationType.slideRight) {
      navigatorKey.currentState!.push(slideRight(widget)).then((dynamic value) {
        if (callback != null && value != null) callback(value);
      });
    } else if (animationType == AnimationType.slideUp) {
      navigatorKey.currentState!.push(slideUp(widget)).then((dynamic value) {
        if (callback != null && value != null) callback(value);
      });
    } else if (animationType == AnimationType.slideDown) {
      navigatorKey.currentState!.push(slideDown(widget)).then((dynamic value) {
        if (callback != null && value != null) callback(value);
      });
    }
  }

  static addWithAnimation(Widget widget, {Function? callback}) {
    navigatorKey.currentState!
        .push(
      PageTransition(
          duration: const Duration(milliseconds: 300),
          type: PageTransitionType.leftToRight,
          child: widget),
    )
        .then((value) {
      if (callback != null && value != null) callback(value);
    });
  }

  static replaceWithAnimation(Widget widget, {Function? callback}) {
    navigatorKey.currentState!
        .pushReplacement(
      PageTransition(
          duration: const Duration(milliseconds: 200),
          type: PageTransitionType.fade,
          child: widget),
    )
        .then((value) {
      if (callback != null && value != null) callback(value);
    });
  }

  static replace(Widget widget, {Function? callback}) {
    navigatorKey.currentState!
        .pushReplacement(PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => widget,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return child;
      },
    ))
        .then((value) {
      if (callback != null && value != null) callback(value);
    });
  }

  static remove({dynamic value}) {
    print("remove $value");
    navigatorKey.currentState!.pop(value ?? false);
  }

  static removeAllAndOpen(Widget widget) {
    navigatorKey.currentState!.pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => widget),
      (Route<dynamic> route) => false,
    );
  }

  static openDialog(Widget widget, {Function? callback}) {
    navigatorKey.currentState!
        .push(PageRouteBuilder(
      opaque: false,
      pageBuilder: (context, animation, _) {
        return widget;
      },
    ))
        .then((value) {
      if (callback != null) {
        callback(value);
      }
    });
  }

  static void openBottomSheet(BuildContext context, Widget widget,
      {Function? callback, borderRadius}) {
    showModalBottomSheet(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius ?? 10.0),
        ),
        isScrollControlled: true,
        context: context,
        builder: (context) {
          return SingleChildScrollView(child: widget);
        });
  }

  static void openBottomSheetWithScroll(BuildContext context, Widget widget,
      {Function? callback}) {
    showModalBottomSheet(
        enableDrag: false,
        isScrollControlled: true,
        isDismissible: false,
        context: context,
        builder: (context) {
          return SingleChildScrollView(
            child: widget,
          );
        });
  }

  slideLeft(Widget nextScreen) {
    return PageRouteBuilder(
        pageBuilder: ((context, animation, secondaryAnimation) => nextScreen),
        transitionDuration: const Duration(milliseconds: 300),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(1.0, 0.0);
          const end = Offset.zero;
          const curve = Curves.ease;

          final tween =
              Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

          return SlideTransition(
            position: animation.drive(tween),
            child: child,
          );
        });
  }

  slideRight(Widget nextScreen) {
    return PageRouteBuilder(
        pageBuilder: ((context, animation, secondaryAnimation) => nextScreen),
        transitionDuration: const Duration(milliseconds: 300),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(-1.0, 0.0);
          const end = Offset.zero;
          const curve = Curves.ease;

          final tween =
              Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

          return SlideTransition(
            position: animation.drive(tween),
            child: child,
          );
        });
  }

  slideUp(Widget nextScreen) {
    return PageRouteBuilder(
        pageBuilder: ((context, animation, secondaryAnimation) => nextScreen),
        transitionDuration: const Duration(milliseconds: 300),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(0.0, 1.0);
          const end = Offset.zero;
          const curve = Curves.ease;

          final tween =
              Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

          return SlideTransition(
            position: animation.drive(tween),
            child: child,
          );
        });
  }

  slideDown(Widget nextScreen) {
    return PageRouteBuilder(
        pageBuilder: ((context, animation, secondaryAnimation) => nextScreen),
        transitionDuration: const Duration(milliseconds: 300),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(0.0, -1.0);
          const end = Offset.zero;
          const curve = Curves.ease;

          final tween =
              Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

          return SlideTransition(
            position: animation.drive(tween),
            child: child,
          );
        });
  }
}
