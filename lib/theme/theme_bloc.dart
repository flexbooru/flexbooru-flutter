import 'package:bloc/bloc.dart';
import 'package:flexbooru/helper/settings.dart';
import 'package:flexbooru/theme/theme_model.dart';
import 'theme_event.dart';
import 'theme_state.dart';

final ThemeBloc themeBloc = ThemeBloc()..onDecideTheme();

class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {

  void onLightTheme() => dispatch(LightTheme());
  void onDarkTheme() => dispatch(DarkTheme());
  void onDecideTheme() => dispatch(DecideTheme());

  @override
  ThemeState get initialState => ThemeState.lightTheme();

  @override
  Stream<ThemeState> mapEventToState(ThemeEvent event) async* {
    if (event is DecideTheme) {
      final ThemeType type = await Settings.instance.getTheme();
      if (type == ThemeType.light) {
        yield ThemeState.lightTheme();
      } else {
        yield ThemeState.darkTheme();
      }
    } else if (event is DarkTheme) {
      yield ThemeState.darkTheme();
      Settings.instance.saveTheme(ThemeType.dark);
    } else if (event is LightTheme) {
      yield ThemeState.lightTheme();
      Settings.instance.saveTheme(ThemeType.light);
    }
  }
}