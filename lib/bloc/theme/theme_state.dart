import 'theme_model.dart';
import 'package:flutter/foundation.dart';

class ThemeState {
  
  ThemeState({@required this.themeModel});
  
  final ThemeModel themeModel;

  factory ThemeState.lightTheme() => 
    ThemeState(themeModel: ThemeModel.getTheme(ThemeType.light));
  factory ThemeState.darkTheme() => 
    ThemeState(themeModel: ThemeModel.getTheme(ThemeType.dark));

}