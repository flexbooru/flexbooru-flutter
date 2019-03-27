import 'package:shared_preferences/shared_preferences.dart';

abstract class ActiveBooruListener {
  void onActiveBooruChanged(int uid);
}

class Settings {
  static const ACTIVE_BOORU_UID_KEY = 'active_booru_uid';
  static const SAFE_MODE_KEY = 'settings_safe_mode';
  static const PAGE_LIMIT_KEY = 'settings_page_limit';
  static const MUZEI_LIMIT_KEY = 'settings_muzei_limit';
  static const BROWSE_SIZE_KEY = 'settings_browse_size';
  static const DOWNLOAD_SIZE_KEY = 'settings_download_size';
  static const MUZEI_SIZE_KEY = 'settings_muzei_size';
  static const POST_SIZE_SAMPLE = 'sample';
  static const POST_SIZE_LARGER = 'larger';
  static const POST_SIZE_ORIGIN = 'origin';
  static const THEME_MODE_KEY = 'settings_theme_mode';
  static const THEME_MODE_SYSTEM = 'system';
  static const THEME_MODE_AUTO_BATTERY = 'battery';
  static const THEME_MODE_DAY = 'day';
  static const THEME_MODE_NIGHT = 'night';
  static const GRID_WIDTH = 'settings_grid_width';
  static const GRID_WIDTH_SMALL = 'small';
  static const GRID_WIDTH_NORMAL = 'normal';
  static const GRID_WIDTH_LARGE = 'large';
  static const ACTIVE_MUZEI_UID_KEY = 'settings_muzei_uid';
  static const SHOW_INFO_BAR_KEY = 'settings_show_info_bar';

  static  SharedPreferences _prefs;
  
  Settings._internal();

  static final Settings instance = Settings._internal();

  factory Settings() => instance;

  Future<SharedPreferences> get sharedPreferences async {
    if(_prefs == null) {
      _prefs = await SharedPreferences.getInstance();
    }
    return _prefs;
  }

  Future<int> getActiveBooruUid() async {
    var prefs = await sharedPreferences;
    return prefs.getInt(ACTIVE_BOORU_UID_KEY) ?? Future.value(-1);
  }

  List<ActiveBooruListener> _booruListeners = [];

  void registerActiveBooruListener(ActiveBooruListener listener) {
    _booruListeners.add(listener);
  }

  void unregisterActiveBooruListener(ActiveBooruListener listener) {
    _booruListeners.remove(listener);
  }

  Future<bool> setActiveBooruUid(int uid) async {
    _booruListeners.forEach((listener) {
      listener.onActiveBooruChanged(uid);
    });
    var prefs = await sharedPreferences;
    return prefs.setInt(ACTIVE_BOORU_UID_KEY, uid);
  }
}