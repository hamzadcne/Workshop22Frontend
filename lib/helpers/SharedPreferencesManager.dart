import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesManager {
  getAuthToken() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    return localStorage.getString('token');
  }

  getCurrentUser() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    return jsonDecode(localStorage.getString('user'));
  }
}
