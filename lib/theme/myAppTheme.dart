import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomTheme {
  // Define custom colors
  static const Color coral = Color(0xFFFF7F50); // #FF7F50
  static const Color lightGray = Color(0xFFD8DDDE); // #D8DDDE
  static const Color mutedGray = Color(0xFF6F6866); // #6F6866
  static const Color white = Color(0xFFFFFFFF); // White

  // Define the theme data
  static ThemeData get theme {
    return ThemeData(
      useMaterial3: true, // Enable Material 3

      // Define the color scheme
      colorScheme: ColorScheme.fromSeed(
        seedColor: coral,
        primary: coral,
        secondary: lightGray,
        surface: white,
        background: lightGray,
        error: Colors.red.shade800,
        onPrimary: white,
        onSecondary: mutedGray,
        onSurface: mutedGray,
        onBackground: mutedGray,
        brightness: Brightness.light,
      ),

      // Define the text theme
      textTheme: TextTheme(
        displayLarge: GoogleFonts.poppins(
          fontSize: 72,
          fontWeight: FontWeight.bold,
          color: coral,
        ),
        titleLarge: GoogleFonts.oswald(
          fontSize: 30,
          fontWeight: FontWeight.bold,
          color: mutedGray,
        ),
        bodyLarge: GoogleFonts.montserrat(
          fontSize: 16,
          color: mutedGray,
        ),
        bodyMedium: GoogleFonts.montserrat(
          fontSize: 14,
          color: mutedGray,
        ),
        bodySmall: GoogleFonts.montserrat(
          fontSize: 12,
          color: mutedGray.withOpacity(0.8),
        ),
        titleMedium: GoogleFonts.lora(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: coral,
        ),
      ),

      // AppBar theme
      appBarTheme: AppBarTheme(
        backgroundColor: coral, // App bar background color
        titleTextStyle: GoogleFonts.oswald(
          fontSize: 22,
          fontWeight: FontWeight.bold,
          color: white, // App bar title color
        ),
        elevation: 4,
        iconTheme: IconThemeData(color: white), // App bar icons color
      ),

      // Button themes
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: coral, // Button background color
          foregroundColor: white, // Text color
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10), // Rounded corners
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          side: BorderSide(color: coral), // Border color
          foregroundColor: coral,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: coral, // Text color
        ),
      ),

      // Floating Action Button theme
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: coral,
        foregroundColor: white,
        elevation: 4,
      ),

      // Bottom Navigation Bar theme
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: lightGray,
        selectedItemColor: coral,
        unselectedItemColor: mutedGray.withOpacity(0.8),
        elevation: 8,
      ),

      // Input Decoration theme
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: lightGray,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: mutedGray),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: mutedGray.withOpacity(0.5)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: coral, width: 2),
        ),
        labelStyle: GoogleFonts.montserrat(color: mutedGray),
        hintStyle: GoogleFonts.montserrat(color: mutedGray.withOpacity(0.7)),
      ),

      // Slider theme
      sliderTheme: SliderThemeData(
        activeTrackColor: coral,
        inactiveTrackColor: mutedGray.withOpacity(0.5),
        thumbColor: coral,
        overlayColor: coral.withOpacity(0.2),
        valueIndicatorColor: coral,
      ),

      // Switch theme
      switchTheme: SwitchThemeData(
        thumbColor: MaterialStateProperty.all(coral),
        trackColor: MaterialStateProperty.all(lightGray),
      ),

      // Icon theme
      iconTheme: IconThemeData(color: coral),

      // Chip theme
      chipTheme: ChipThemeData(
        backgroundColor: lightGray,
        selectedColor: coral,
        secondarySelectedColor: coral.withOpacity(0.8),
        labelStyle: GoogleFonts.montserrat(color: mutedGray),
        secondaryLabelStyle: GoogleFonts.montserrat(color: white),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      ),

      // Scaffold and other defaults
      scaffoldBackgroundColor: lightGray,
      cardTheme: CardTheme(
        color: white,
        shadowColor: mutedGray.withOpacity(0.4),
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
    );
  }
}
