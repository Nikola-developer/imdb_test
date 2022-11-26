import 'package:flutter/material.dart';
import 'package:imdb_test/theme/colors.dart';

ThemeData MyThemeData() {
  return ThemeData(
    brightness: Brightness.dark,
    backgroundColor: BackgroundColor,
    scaffoldBackgroundColor: BackgroundColor,
    primaryColor: PrimaryColor,
    accentColor: PrimaryColor,
    fontFamily: 'SF Pro Display',
    appBarTheme: const AppBarTheme(
      color: BackgroundColor,
      elevation: 0,
    ),
    textTheme: const TextTheme(
      bodyText2: TextStyle(color: TextColor),
      headline4: TextStyle(color: TextColor),
    ),
  );
}
