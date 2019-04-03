import 'package:flutter/material.dart';

enum ThemeType { light, dark }

class ThemeModel {
  
  final ThemeData themedata;
  final ThemeType type;

  const ThemeModel({this.type, this.themedata});

  static ThemeModel getTheme(ThemeType type) {
    if (type == ThemeType.light) {
      return ThemeModel(
          type: type,
          themedata: ThemeData.light().copyWith(
            primaryColorBrightness: Brightness.dark,
            primaryColor: Colors.grey[50],
            primaryColorDark: Colors.grey[50],
            primaryColorLight: Colors.grey[50],
            primaryTextTheme: ThemeData.light().primaryTextTheme.apply(
              bodyColor: Colors.black
            ),
            primaryIconTheme: ThemeData.light().primaryIconTheme.copyWith(
              color: Colors.black
            ),
            accentColor: Colors.pinkAccent,
          ),
      );
    } else {
      return ThemeModel(
          type: type,
          themedata: ThemeData.dark().copyWith(
            accentColor: Colors.grey[50],
            canvasColor: ThemeData.dark().primaryColor,
            cardColor: ThemeData.dark().primaryColor,
          )
      );
    }
  }
}