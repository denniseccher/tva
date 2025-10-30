import 'package:flutter/material.dart';

// Definizione dei tuoi ColorScheme (come fornito)
const Color primaryGreen = Color(0xFF397C1B);
const Color secondaryOrange = Color(0xFFF5972D);
const Color tertiaryTan = Color(0xFFCFA45F);
const Color accentYellow = Color(0xFFFFD966);
const Color darkGreen = Color(0xFF2A4020);

// --- Light Mode Color Scheme ---
const lightColorScheme = ColorScheme(
  brightness: Brightness.light,
  primary: primaryGreen,
  onPrimary: Color(0xFFFFFFFF),
  primaryContainer: accentYellow,
  onPrimaryContainer: darkGreen,
  secondary: secondaryOrange,
  onSecondary: Color(0xFFFFFFFF),
  secondaryContainer: Color(0xFFFFE0B2),
  onSecondaryContainer: Color(0xFF2C1700),
  tertiary: tertiaryTan,
  onTertiary: Color(0xFFFFFFFF),
  tertiaryContainer: Color(0xFFF8E1BB),
  onTertiaryContainer: Color(0xFF2A1800),
  error: Color(0xFFB3261E),
  onError: Color(0xFFFFFFFF),
  errorContainer: Color(0xFFF9DEDC),
  onErrorContainer: Color(0xFF410E0B),
  surface: Color(0xFFFFFBF7),
  onSurface: darkGreen,
  surfaceContainerHighest: Color(0xFFE7F5E3),
  onSurfaceVariant: Color(0xFF424940),
  outline: Color(0xFF72796F),
  outlineVariant: Color(0xFFC2C9BE),
  shadow: Color(0xFF000000),
  scrim: Color(0xFF000000),
  inverseSurface: Color(0xFF30312C),
  onInverseSurface: Color(0xFFF1F2E7),
  inversePrimary: Color(0xFFADDD8E),
  surfaceTint: primaryGreen,
  surfaceContainerLow: Color.fromRGBO(244, 244, 244, 1),
);

// --- Dark Mode Color Scheme ---
final darkColorScheme = ColorScheme(
  brightness: Brightness.dark,
  primary: accentYellow,
  onPrimary: darkGreen,
  primaryContainer: primaryGreen,
  onPrimaryContainer: Color(0xFFD4FABC),
  secondary: secondaryOrange,
  onSecondary: darkGreen,
  secondaryContainer: Color(0xFF6A4000),
  onSecondaryContainer: Color(0xFFFFDDB9),
  tertiary: tertiaryTan,
  onTertiary: darkGreen,
  tertiaryContainer: Color(0xFF5F4523),
  onTertiaryContainer: Color(0xFFF8E1BB),
  error: Color(0xFFF2B8B5),
  onError: Color(0xFF601410),
  errorContainer: Color(0xFF8C1D18),
  onErrorContainer: Color(0xFFF9DEDC),
  surface: Color(0xFF1B1C18),
  onSurface: Color(0xFFE4E3DB),
  surfaceContainerHighest: Color(0xFF424940),
  onSurfaceVariant: Color(0xFFC2C9BE),
  outline: Color(0xFF8C9388),
  outlineVariant: Color(0xFF424940),
  shadow: Color(0xFF000000),
  scrim: Color(0xFF000000),
  inverseSurface: Color(0xFFE4E3DB),
  onInverseSurface: Color(0xFF30312C),
  inversePrimary: primaryGreen,
  surfaceTint: accentYellow,
  surfaceContainerLow: Color.fromRGBO(29, 29, 29, 1),
);

ThemeData lightTheme = ThemeData(
  colorScheme: lightColorScheme,
  useMaterial3: true,
  scaffoldBackgroundColor: lightColorScheme.surfaceContainerLowest,
  listTileTheme: ListTileThemeData(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
  ),
);

ThemeData darkTheme = ThemeData(
  colorScheme: darkColorScheme,
  useMaterial3: true,
  scaffoldBackgroundColor: darkColorScheme.surfaceContainerLowest,
  listTileTheme: ListTileThemeData(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
  ),
);

// Esempio di come accedere al valore (da usare nel widget)
// final customTheme = Theme.of(context).extension<CustomTheme>()!;
// Color menuBackgroundColor = customTheme.menuBg;
