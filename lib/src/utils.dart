part of flutter_ezplayer;

class Utils {
  static bool showLog = true;

  static void log(Object object) {
    if (showLog) {
      print(object);
    }
  }
}
