import 'dart:convert';
import 'package:Travel_Expense_Tracker/constants/global-user.dart';
import 'package:Travel_Expense_Tracker/services/auth-service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefs {
  AuthService authService = new AuthService();

  static storeData({String email, String uid}) async {
    var prefs = await SharedPreferences.getInstance();
    prefs.setString("userData", json.encode({"email": email, "uid": uid}));
  }

  Future<bool> tryAutoLogin() async {
    var prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey("userData")) {
      return false;
    } else {
      final userData = json.decode(prefs.getString("userData").toString());
      GlobalUser.email = userData['email'];
      GlobalUser.uid = userData['uid'];
      return true;
    }
  }

  static logout() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }
}
