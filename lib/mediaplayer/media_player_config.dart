

// class MediaPlayerConfig {
//   static const String TAG = '_player_config';
//
//   late Map<String, String> _config;
//
//   Map<String, String> get config => _config;
//
//   static MediaPlayerConfig? _instance;
//
//   static MediaPlayerConfig get instance => _instance ?? MediaPlayerConfig._();
//
//   factory MediaPlayerConfig() => instance;
//
//   MediaPlayerConfig._() {
//     _loadPrefs();
//   }
//
//   Future<void> addOrUpdate(String key, String value) async {
//     if (!key.contains(TAG)) {
//       _config[key] = value;
//       key = "$key$TAG";
//     } else {
//       _config[key.replaceAll(TAG, "")] = value;
//     }
//
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     prefs.setString(key, value);
//   }
//
//   Future<void> _loadPrefs() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//
//     _config = new LinkedHashMap();
//     for (String key in prefs.getKeys()
//       ..removeWhere((key) {
//         return !key.contains(TAG);
//       })) {
//       // if(key.contains(TAG))
//       String k = key.replaceAll(TAG, "");
//       _config[k] = prefs.getString(k)!;
//     }
//   }
// }
