import 'package:flutter/material.dart';

import 'extensions.dart';

final lightTheme = ThemeData(
  primaryColor: _labelPrimary,
  backgroundColor: _backPrimary,
  scaffoldBackgroundColor: _backPrimary,
  appBarTheme: const AppBarTheme(backgroundColor: _backPrimary),
  canvasColor: _backElevated,
  listTileTheme: const ListTileThemeData(
    // tileColor: _backSecondary,
    textColor: _labelPrimary,
  ),
  toggleableActiveColor: _blue,
  switchTheme:
      SwitchThemeData(trackColor: MaterialStateProperty.resolveWith((states) {
    late final Color color;
    if (states.contains(MaterialState.disabled)) {
      color = _backElevated;
    } else {
      color = _blue;
    }
    return color.withOpacity(.3);
  }), thumbColor: MaterialStateProperty.resolveWith((states) {
    if (states.contains(MaterialState.disabled)) return _backElevated;
    return _blue;
  })),
  // cardColor: _backSecondary,
  textTheme: const TextTheme(
    titleLarge: TextStyle(
        fontSize: 32,
        height: 38 / 32,
        fontWeight: FontWeight.w500,
        color: _labelPrimary),
    titleMedium:
        TextStyle(fontSize: 20, height: 32 / 20, fontWeight: FontWeight.w500),
    bodyMedium: _defaultTextTheme,
    titleSmall:
        TextStyle(fontSize: 14, height: 20 / 14, fontWeight: FontWeight.w400),
  ),
  checkboxTheme: CheckboxThemeData(
      fillColor: MaterialStateProperty.resolveWith((states) => _separator)),
  inputDecorationTheme:
      const InputDecorationTheme(hintStyle: _defaultTextTheme),
  textButtonTheme: TextButtonThemeData(
    style: TextButton.styleFrom(
      primary: _blue,
      textStyle: const TextStyle(
        fontSize: 14,
        height: 24 / 14,
        fontWeight: FontWeight.w500,
      ),
    ),
  ),
  colorScheme: ColorScheme.fromSeed(
    seedColor: _blue,
    background: _backPrimary,
    onPrimary: _labelPrimary,
    onSecondary: _labelSecondary,
    onTertiary: _labelTertiary,
    surface: _backSecondary,
  ),
  iconTheme: const IconThemeData(color: _blue),
  disabledColor: _labelDisable,
  hintColor: _labelTertiary,
  floatingActionButtonTheme: const FloatingActionButtonThemeData(
    backgroundColor: _blue,
  ),
);
const _defaultTextTheme = TextStyle(
    fontSize: 16,
    height: 20 / 16,
    fontWeight: FontWeight.w400,
    color: _labelPrimary);
final customColorsLight = CustomColors(
  red: _red,
  green: _green,
  blue: _blue,
  gray: _gray,
  grayLight: _grayLight,
  white: _white,
);
final layoutColorsLight = LayoutColors(
  seperatorColor: _separator,
  overlayColor: _overlay,
);

/// Support [Light] / Separator
const Color _separator = Color(0x33000000);

/// Support [Light] / Overlay
const Color _overlay = Color(0x0F000000);

const Color _labelPrimary = Color(0xFF000000);
const Color _labelSecondary = Color(0x99000000);
const Color _labelTertiary = Color(0x4D000000);
const Color _labelDisable = Color(0x26000000);

/// Color [Light] / Red
const Color _red = Color(0xFFFF3B30);

/// Color [Light] / Green
const Color _green = Color(0xFF34C759);

/// Color [Light] / Blue
const Color _blue = Color(0xFF007AFF);

/// Color [Light] / Gray
const Color _gray = Color(0xFF8E8E93);

/// Color [Light] / Gray Light
const Color _grayLight = Color(0xFFD1D1D6);

/// Color [Light] / White
const Color _white = Color(0xFFFFFFFF);

///Back [Light] / Primary
const Color _backPrimary = Color(0xFFF7F6F2);

///Back [Light] / Secondary
const Color _backSecondary = Color(0xFFF7F6F2);

///Back [Light] / Elevated
const Color _backElevated = Color(0xFFFFFFFF);
