import 'package:flutter/material.dart';
import 'package:new_template/models/theme_prefrence.dart';

class DarkTHemeProvider with ChangeNotifier {
  ThemePreference themePreference = ThemePreference();
  bool _darkTheme = false;
  bool get darkTheme => _darkTheme;

  set darkTheme(bool value) {
    _darkTheme = value;
    themePreference.setTheme(value);
    notifyListeners();
  }
}
