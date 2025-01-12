import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LangServices with ChangeNotifier {
  String _selectedLang = 'en';
  Locale _locale = const Locale('en'); 

  Locale get locale => _locale;
  String get selectedLang => _selectedLang;

  Future<void> loadLangFromPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _selectedLang = prefs.getString('selectedLang') ?? 'en';
    _locale = Locale(_selectedLang);
    notifyListeners();
  }

  Future<void> selectLang(String langCode) async {
    _selectedLang = langCode;
    _locale = Locale(langCode);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('selectedLang', langCode);
    notifyListeners(); 
  }
}