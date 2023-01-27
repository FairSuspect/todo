import 'package:flutter/material.dart';

class CustomColors extends ThemeExtension<CustomColors> {
  final Color red;
  final Color green;
  final Color blue;
  final Color gray;
  final Color grayLight;
  final Color white;

  CustomColors(
      {required this.red,
      required this.green,
      required this.blue,
      required this.gray,
      required this.grayLight,
      required this.white});

  @override
  ThemeExtension<CustomColors> copyWith(
      {Color? red,
      Color? green,
      Color? blue,
      Color? gray,
      Color? grayLight,
      Color? white}) {
    return CustomColors(
      red: red ?? this.red,
      blue: blue ?? this.blue,
      gray: gray ?? this.gray,
      green: green ?? this.green,
      grayLight: grayLight ?? this.grayLight,
      white: white ?? this.white,
    );
  }

  @override
  ThemeExtension<CustomColors> lerp(
      ThemeExtension<CustomColors>? other, double t) {
    if (other is! CustomColors) {
      return this;
    }
    return CustomColors(
      red: Color.lerp(red, other.red, t)!,
      green: Color.lerp(green, other.green, t)!,
      blue: Color.lerp(blue, other.blue, t)!,
      gray: Color.lerp(gray, other.gray, t)!,
      grayLight: Color.lerp(grayLight, other.grayLight, t)!,
      white: Color.lerp(white, other.white, t)!,
    );
  }
}
