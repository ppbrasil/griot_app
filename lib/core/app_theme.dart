import 'package:flutter/material.dart';

class AppTheme {
  AppTheme._();

  // Colors
  static const Color white = Color(0xFFF3F3F3);
  static const Color lightestGreen = Color(0xFF2F8878);
  static const Color lightGreenMainColor = Color(0xFF51AC87);
  static const Color darkGreen = Color(0xFF076767);
  static const Color darkBlue = Color(0xFF111034);
  static const Color darkestGreen = Color(0xFF0D4456);

  static final Color iconColor = Colors.blueAccent.shade200;
  static const Color lightPrimaryColor = lightGreenMainColor;
  static const Color lightPrimaryVariantColor = lightGreenMainColor;
  static const Color lightSecondaryColor = Colors.green;
  static const Color lightOnPrimaryColor = Colors.black;
  static const Color darkPrimaryColor = Colors.white24;
  static const Color darkPrimaryVariantColor = Colors.black;
  static const Color darkSecondaryColor = Colors.white;
  static const Color darkOnPrimaryColor = Colors.white;

  // Font Styles
  static const TextStyle _lightScreenHeading1TextStyle = TextStyle(
    fontSize: 26.0,
    fontWeight: FontWeight.bold,
    color: lightOnPrimaryColor,
    fontFamily: "Poppins",
  );

  static final TextStyle _darkScreenHeading1TextStyle =
      _lightScreenHeading1TextStyle.copyWith(color: darkOnPrimaryColor);

  // Text Themes
  static const TextTheme _lightTextTheme = TextTheme(
    displayLarge: _lightScreenHeading1TextStyle,
  );

  static final TextTheme _darkTextTheme = TextTheme(
    displayLarge: _darkScreenHeading1TextStyle,
  );

  // Themes
  static final ThemeData lightTheme = ThemeData(
    appBarTheme: const AppBarTheme(
      titleTextStyle: TextStyle(
        color: darkSecondaryColor,
        fontFamily: "Poppins",
        fontWeight: FontWeight.bold,
        fontSize: 26,
      ),
      color: lightPrimaryVariantColor,
      iconTheme: IconThemeData(color: lightOnPrimaryColor),
    ),
    colorScheme: const ColorScheme.light(
      primary: lightPrimaryColor,
      secondary: lightSecondaryColor,
      onPrimary: lightOnPrimaryColor,
    ),
    iconTheme: IconThemeData(
      color: iconColor,
    ),
    textTheme: _lightTextTheme,
    dividerTheme: const DividerThemeData(color: Colors.black12),
  );

  static final ThemeData darkTheme = ThemeData(
    scaffoldBackgroundColor: darkPrimaryVariantColor,
    appBarTheme: const AppBarTheme(
      color: darkPrimaryVariantColor,
      iconTheme: IconThemeData(color: darkOnPrimaryColor),
    ),
    colorScheme: const ColorScheme.dark(
      primary: darkPrimaryColor,
      secondary: darkSecondaryColor,
      onPrimary: darkOnPrimaryColor,
      background: Colors.white12,
    ),
    iconTheme: IconThemeData(
      color: iconColor,
    ),
    textTheme: _darkTextTheme,
    dividerTheme: const DividerThemeData(color: Colors.black),
  );
}
