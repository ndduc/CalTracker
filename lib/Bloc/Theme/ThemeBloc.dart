// ignore_for_file: file_names
// ignore_for_file: library_prefixes
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: constant_identifier_names

import 'dart:async';
import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

import 'AppThemeBloc.dart';


class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  ThemeBloc() : super(ThemeState(themeData: AppThemeBloc.appThemData[AppTheme.lightTheme]));

  @override
  Stream<ThemeState> mapEventToState(ThemeEvent event  ) async* {
    try {
      if (event is ThemeEvent) {
        yield ThemeState(
          themeData: AppThemeBloc.appThemData[event.appTheme],
        );
      }
    }
    catch( e)
    {
      print(e.toString());
    }
  }
}

@immutable
class ThemeEvent {
  final AppTheme appTheme;
  const ThemeEvent({required this.appTheme});
}

@immutable
class ThemeState {
  final ThemeData? themeData;
  const ThemeState({required this.themeData});
}

