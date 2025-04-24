import 'package:flutter/material.dart';

const Color primaryGreen = Color(0xFF397C1B);
const Color secondaryOrange = Color(0xFFF5972D);
const Color tertiaryTan = Color(0xFFCFA45F);
const Color accentYellow = Color(0xFFFFD966);
const Color darkGreen = Color(0xFF2A4020);

// --- Light Mode Color Scheme ---
const lightColorScheme = ColorScheme(
  brightness: Brightness.light,

  primary: primaryGreen,                // Verde principale
  onPrimary: Color(0xFFFFFFFF),         // Testo/icone su primario (bianco)
  primaryContainer: accentYellow,         // Contenitore primario (giallo chiaro)
  onPrimaryContainer: darkGreen,          // Testo/icone su contenitore primario (verde scuro)

  secondary: secondaryOrange,            // Arancione secondario
  onSecondary: Color(0xFFFFFFFF),       // Testo/icone su secondario (bianco)
  secondaryContainer: Color(0xFFFFE0B2), // Contenitore secondario (arancione chiaro derivato)
  onSecondaryContainer: Color(0xFF2C1700), // Testo/icone su contenitore secondario (marrone scuro derivato)

  tertiary: tertiaryTan,                 // Marrone chiaro terziario
  onTertiary: Color(0xFFFFFFFF),         // Testo/icone su terziario (bianco)
  tertiaryContainer: Color(0xFFF8E1BB),   // Contenitore terziario (marrone molto chiaro derivato)
  onTertiaryContainer: Color(0xFF2A1800), // Testo/icone su contenitore terziario (marrone scuro derivato)

  error: Color(0xFFB3261E),              // Rosso errore standard M3
  onError: Color(0xFFFFFFFF),            // Testo/icone su errore (bianco)
  errorContainer: Color(0xFFF9DEDC),      // Contenitore errore standard M3
  onErrorContainer: Color(0xFF410E0B),    // Testo/icone su contenitore errore standard M3

  surface: Color(0xFFFFFBF7),             // Superficie come sfondo
  onSurface: darkGreen,                   // Testo/icone su superficie (verde scuro)

  surfaceContainerHighest: Color(0xFFE7F5E3),     // Variante superficie (verde molto chiaro derivato)
  onSurfaceVariant: Color(0xFF424940),     // Testo/icone su variante superficie (grigio scuro/verde derivato)

  outline: Color(0xFF72796F),              // Bordo (grigio/verde medio derivato)
  outlineVariant: Color(0xFFC2C9BE),     // Variante Bordo (grigio chiaro/verde derivato)

  shadow: Color(0xFF000000),              // Ombra (nero)
  scrim: Color(0xFF000000),              // Scrim (nero)

  inverseSurface: Color(0xFF30312C),      // Superficie inversa (grigio scuro/verde derivato)
  onInverseSurface: Color(0xFFF1F2E7),    // Testo/icone su superficie inversa (grigio chiaro/verde derivato)
  inversePrimary: Color(0xFFADDD8E),      // Primario inverso (verde chiaro derivato)
  surfaceTint: primaryGreen,             // Tinta superficie (colore primario)
);


// --- Dark Mode Color Scheme ---
const darkColorScheme = ColorScheme(
  brightness: Brightness.dark,

  primary: accentYellow,                 // Giallo chiaro come primario nel tema scuro
  onPrimary: darkGreen,                  // Testo/icone su primario (verde scuro)
  primaryContainer: primaryGreen,          // Contenitore primario (verde originale)
  onPrimaryContainer: Color(0xFFD4FABC), // Testo/icone su contenitore primario (verde molto chiaro)

  secondary: secondaryOrange,             // Arancione secondario
  onSecondary: darkGreen,                 // Testo/icone su secondario (verde scuro)
  secondaryContainer: Color(0xFF6A4000),  // Contenitore secondario (marrone scuro derivato dall'arancione)
  onSecondaryContainer: Color(0xFFFFDDB9),// Testo/icone su contenitore secondario (arancione chiaro)

  tertiary: tertiaryTan,                  // Marrone chiaro terziario
  onTertiary: darkGreen,                  // Testo/icone su terziario (verde scuro)
  tertiaryContainer: Color(0xFF5F4523),    // Contenitore terziario (marrone medio-scuro)
  onTertiaryContainer: Color(0xFFF8E1BB),  // Testo/icone su contenitore terziario (marrone molto chiaro)

  error: Color(0xFFF2B8B5),               // Rosso errore chiaro standard M3
  onError: Color(0xFF601410),             // Testo/icone su errore (rosso scuro)
  errorContainer: Color(0xFF8C1D18),       // Contenitore errore standard M3
  onErrorContainer: Color(0xFFF9DEDC),     // Testo/icone su contenitore errore standard M3

  surface: Color(0xFF1B1C18),              // Superficie leggermente diversa dallo sfondo (grigio molto scuro/verde)
  onSurface: Color(0xFFE4E3DB),            // Testo/icone su superficie (grigio chiaro/verde)

  surfaceContainerHighest: Color(0xFF424940),      // Variante superficie (grigio scuro/verde)
  onSurfaceVariant: Color(0xFFC2C9BE),      // Testo/icone su variante superficie (grigio chiaro/verde)

  outline: Color(0xFF8C9388),               // Bordo (grigio/verde medio-chiaro)
  outlineVariant: Color(0xFF424940),      // Variante Bordo (grigio scuro/verde)

  shadow: Color(0xFF000000),               // Ombra (nero)
  scrim: Color(0xFF000000),               // Scrim (nero)

  inverseSurface: Color(0xFFE4E3DB),       // Superficie inversa (grigio chiaro/verde)
  onInverseSurface: Color(0xFF30312C),     // Testo/icone su superficie inversa (grigio scuro/verde)
  inversePrimary: primaryGreen,           // Primario inverso (verde originale)
  surfaceTint: accentYellow,              // Tinta superficie (colore primario del tema scuro)
);

ThemeData lightTheme = ThemeData.from(
      colorScheme: lightColorScheme,
      useMaterial3: true,
    );

    ThemeData darkTheme = ThemeData.from(
      colorScheme: darkColorScheme,
      useMaterial3: true,
    );