import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

class NativeMethods extends ChangeNotifier {
  static const platform = MethodChannel('helping_hand/native');

  Future launchApp() async {
    try {
      print("Going here");
      final result = await platform.invokeMethod("rocketLaunch");
      print("This is the result: $result");
    } on PlatformException catch (e) {
      print("Error in method: ${e.message}");
    } catch (e) {
      rethrow;
    }
  }

  Future showToastNative(String message) async {
    try {
      await platform.invokeMethod(
          "showToastNative", {"message": "Hello", "duration": "short"});
    } on PlatformException catch (e) {
      print("Error in method: ${e.message}");
    } catch (e) {
      rethrow;
    }
  }

  Future<void> showToast(String message, {String duration = "short"}) async {
    print("Showing toast $message with $duration time");
    try {
      await Future.delayed(
          const Duration(milliseconds: 100)); // ✅ Ensure Flutter is ready
      await platform.invokeMethod(
          "showToastNative", {"message": message, "duration": duration});
    } on PlatformException catch (e) {
      print("Error in method: ${e.message}");
    } catch (e) {
      rethrow;
    }
  }
}
