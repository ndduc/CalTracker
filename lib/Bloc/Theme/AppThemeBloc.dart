// ignore_for_file: file_names
// ignore_for_file: library_prefixes
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: constant_identifier_names

import 'package:flutter/material.dart';
class AppThemeBloc{
  static final appThemData={
    AppTheme.lightTheme:ThemeData(
      scaffoldBackgroundColor: Colors.white,
      primarySwatch: Colors.lightBlue,
      backgroundColor: Colors.white,
      textTheme: const TextTheme(
        bodyText1: TextStyle(
          color: Colors.black,
        ),
      ),
    ),
    AppTheme.darkTheme:ThemeData(
      scaffoldBackgroundColor: Colors.black,
      primarySwatch: Colors.teal,
      backgroundColor: Colors.black,
      textTheme: const TextTheme(
        bodyText1: TextStyle(
          color: Colors.white,
        ),
      ),
    )
  };
}
enum AppTheme {
  lightTheme,
  darkTheme,
}