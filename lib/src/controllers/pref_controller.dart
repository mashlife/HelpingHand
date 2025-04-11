import 'dart:convert';

import 'package:helping_hand/src/models/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PrefController {
  static Future<bool> saveListConnectedIndex(var val) async {
    final SharedPreferences sp = await SharedPreferences.getInstance();
    return sp.setString(Pref.listIndex, jsonEncode(val));
  }

  static Future<bool> saveUser(UserModel userModel) async {
    final SharedPreferences sp = await SharedPreferences.getInstance();
    sp.setString(Pref.userDataKey, json.encode(userModel));
    return sp.setBool(Pref.isLoggedIn, true);
  }

  static Future<bool> isLoggedIn() async {
    final SharedPreferences sp = await SharedPreferences.getInstance();

    final data = sp.getBool(Pref.isLoggedIn);
    return data ?? false;
  }

  static Future<UserModel?> readUser() async {
    final SharedPreferences sp = await SharedPreferences.getInstance();

    String user = sp.getString(Pref.userDataKey) ?? "";
    UserModel userModel =
        user.isEmpty ? UserModel() : UserModel.fromJson(json.decode(user));
    return userModel;
  }

  static Future<bool> setFirstUser() async {
    final SharedPreferences sp = await SharedPreferences.getInstance();
    return sp.setInt(Pref.isFirstTime, 1);
  }

  static Future<bool> isFirstTime() async {
    final SharedPreferences sp = await SharedPreferences.getInstance();
    int firstTime = sp.getInt(Pref.isFirstTime) ?? 0;
    return firstTime == 0 ? true : false;
  }
}

class Pref {
  static String listIndex = "SelectedIndex";
  static String isFirstTime = "FirstTimeUser";
  static String userDataKey = "userDataKey";
  static String isLoggedIn = "loggedIn";
}
