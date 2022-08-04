import 'package:flutter/material.dart';

import 'extensions.dart';

final lightTheme = ThemeData(
  primaryColor: _labelPrimary,
  backgroundColor: _backPrimary,
  scaffoldBackgroundColor: _backPrimary,
  appBarTheme: const AppBarTheme(backgroundColor: _backPrimary),
  colorScheme: ColorScheme.fromSeed(
    seedColor: _blue,
    background: _backPrimary,
    onPrimary: _labelPrimary,
    onSecondary: _labelSecondary,
    surface: _backsecondary,
  ),
  iconTheme: const IconThemeData(color: _blue),
  disabledColor: _labelDisable,
  floatingActionButtonTheme: const FloatingActionButtonThemeData(
    backgroundColor: _blue,
  ),
  // extensions: [
  //   customColorsLight,
  //   layoutColorsLight,
  // ],
);
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
const Color _backsecondary = Color(0xFFF7F6F2);

///Back [Light] / Elevated
const Color _backElevated = Color(0xFFFFFFFF);