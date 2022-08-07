import 'package:flutter/material.dart';

import 'extensions.dart';

final darkTheme = ThemeData(
  primaryColor: _labelPrimary,
  backgroundColor: _backPrimary,
  scaffoldBackgroundColor: _backPrimary,
  appBarTheme: const AppBarTheme(backgroundColor: _backPrimary),
  textTheme: const TextTheme(
    titleLarge:
        TextStyle(fontSize: 32, height: 38 / 32, fontWeight: FontWeight.w500),
    titleMedium:
        TextStyle(fontSize: 20, height: 32 / 20, fontWeight: FontWeight.w500),
    bodyMedium:
        TextStyle(fontSize: 16, height: 20 / 16, fontWeight: FontWeight.w400),
    titleSmall:
        TextStyle(fontSize: 14, height: 20 / 14, fontWeight: FontWeight.w400),
  ),
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
    surface: _backsecondary,
  ),
  iconTheme: const IconThemeData(color: _blue),
  disabledColor: _labelDisable,
  hintColor: _labelTertiary,
  floatingActionButtonTheme: const FloatingActionButtonThemeData(
    backgroundColor: _blue,
  ),
  extensions: [
    CustomColors(
      red: _red,
      green: _green,
      blue: _blue,
      gray: _gray,
      grayLight: _grayLight,
      white: _white,
    ),
    LayoutColors(
      seperatorColor: _separator,
      overlayColor: _overlay,
    ),
  ],
);

/// Support [Light] / Separator
const Color _separator = Color(0x330FFFFF);

/// Support [Light] / Overlay
const Color _overlay = Color(0x52000000);

const Color _labelPrimary = Color(0xFFFFFFFF);
const Color _labelSecondary = Color(0x99FFFFFF);
const Color _labelTertiary = Color(0x66FFFFFF);
const Color _labelDisable = Color(0x26FFFFFF);

/// Color [Light] / Red
const Color _red = Color(0xFFFF453A);

/// Color [Light] / Green
const Color _green = Color(0xFF32D74B);

/// Color [Light] / Blue
const Color _blue = Color(0xFF0A84FF);

/// Color [Light] / Gray
const Color _gray = Color(0xFF8E8E93);

/// Color [Light] / Gray Light
const Color _grayLight = Color(0xFF48484A);

/// Color [Light] / White
const Color _white = Color(0xFFFFFFFF);

/// Back [Dark] / Primary
const Color _backPrimary = Color(0xFF16161B);

/// Back [Dark] / Secondary
const Color _backsecondary = Color(0xFF252528);

/// Back [Dark] / Elevated
const Color _backElevated = Color(0xFF3C3C3F);
