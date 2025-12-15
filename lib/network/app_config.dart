abstract class AppConfig {
  static String BASE_URL_CONFIG = "production";

  // static String BASE_URL_CONFIG = "test";
  static bool isProduction() {
    if (BASE_URL_CONFIG == 'production') {
      return true;
    } else {
      return false;
    }

    // return const bool.fromEnvironment('dart.vm.product');
  }
  static String login =  "login";
}