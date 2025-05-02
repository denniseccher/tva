import 'dart:ui';

import 'package:flutter/material.dart';

class CustomTheme extends ThemeExtension<CustomTheme> {
  final Color brandColor;
  final TextStyle specialTextStyle;
  final double customSpacing;

  const CustomTheme({
    required this.brandColor,
    required this.specialTextStyle,
    required this.customSpacing,
  });

  @override
  CustomTheme copyWith({
    Color? brandColor,
    TextStyle? specialTextStyle,
    double? customSpacing,
  }) {
    return CustomTheme(
      brandColor: brandColor ?? this.brandColor,
      specialTextStyle: specialTextStyle ?? this.specialTextStyle,
      customSpacing: customSpacing ?? this.customSpacing,
    );
  }

  @override
  ThemeExtension<CustomTheme> lerp(covariant ThemeExtension<CustomTheme>? other, double t) {
    if (other is! CustomTheme) {
      return this;
    }
    return CustomTheme(
      brandColor: Color.lerp(brandColor, other.brandColor, t)!,
      specialTextStyle: TextStyle.lerp(specialTextStyle, other.specialTextStyle, t)!,
      customSpacing: lerpDouble(customSpacing, other.customSpacing, t)!,
    );
  }

  // Metodo per creare un tema di default (opzionale)
  static const light = CustomTheme(
    brandColor: Colors.green,
    specialTextStyle: TextStyle(fontSize: 20, fontStyle: FontStyle.italic, color: Colors.black54),
    customSpacing: 24.0,
  );

  // Metodo per creare un tema scuro (opzionale)
  static const dark = CustomTheme(
    brandColor: Colors.lightGreenAccent,
    specialTextStyle: TextStyle(fontSize: 20, fontStyle: FontStyle.italic, color: Colors.white70),
    customSpacing: 24.0,
  );
}