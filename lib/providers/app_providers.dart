

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';


final themeModeProvider = StateProvider<ThemeMode>((ref) {
  return ThemeMode.system;
});

final sharedPreferencesProvider = StateProvider<Future<SharedPreferences>>((ref) {
  return SharedPreferences.getInstance();
});