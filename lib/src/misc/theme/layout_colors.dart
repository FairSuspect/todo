import 'package:flutter/material.dart';

class LayoutColors extends ThemeExtension<LayoutColors> {
  final Color seperatorColor;
  final Color overlayColor;

  LayoutColors({
    required this.seperatorColor,
    required this.overlayColor,
  });

  @override
  ThemeExtension<LayoutColors> copyWith({
    Color? seperatorColor,
    Color? overlayColor,
  }) {
    return LayoutColors(
      overlayColor: overlayColor ?? this.overlayColor,
      seperatorColor: seperatorColor ?? this.seperatorColor,
    );
  }

  @override
  ThemeExtension<LayoutColors> lerp(
      ThemeExtension<LayoutColors>? other, double t) {
    if (other is! LayoutColors) {
      return this;
    }
    return LayoutColors(
      overlayColor: Color.lerp(overlayColor, other.overlayColor, t)!,
      seperatorColor: Color.lerp(seperatorColor, other.seperatorColor, t)!,
    );
  }
}
