import 'package:flutter/material.dart';

import 'extensions.dart';

final lightTheme = ThemeData(
    primaryColor: _primary,
    colorScheme: ColorScheme.fromSeed(
        seedColor: _primary, secondary: _secondary, tertiary: _tertiary),
    disabledColor: _disable,
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
    ]);

/// Support [Light] / Separator
const Color _separator = Color(0x33000000);

/// Support [Light] / Overlay
const Color _overlay = Color(0x0F000000);

const Color _primary = Color(0xFF000000);
const Color _secondary = Color(0x99000000);
const Color _tertiary = Color(0x4D000000);
const Color _disable = Color(0x26000000);

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
