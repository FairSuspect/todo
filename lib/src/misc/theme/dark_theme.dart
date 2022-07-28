import 'package:flutter/material.dart';

import 'extensions.dart';

final darkTheme = ThemeData(
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
const Color _separator = Color(0x330FFFFF);

/// Support [Light] / Overlay
const Color _overlay = Color(0x52000000);

const Color _primary = Color(0xFFFFFFFF);
const Color _secondary = Color(0x99FFFFFF);
const Color _tertiary = Color(0x66FFFFFF);
const Color _disable = Color(0x26FFFFFF);

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
