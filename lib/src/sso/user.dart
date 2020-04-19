class User {
  static const String KEY_ID = "id";
  static const String KEY_EMAIL = "email";
  static const String KEY_USERNAME = "username";
  static const String KEY_PASSWORD = "password";
  static const String KEY_TOKEN = "token";
  static const String KEY_EXPIRED_AT = "expired_at";
  static const String KEY_IS_ENABLED = "is_enabled";
  static const String KEY_IS_VERIFIED = "is_verified";

  Map _data = Map();

  User([Map data]) {
    if (data != null) {
      _data = data;
    }
  }

  dynamic get id => get(KEY_ID);

  String get email => get(KEY_EMAIL, def: "");

  String get username => get(KEY_USERNAME, def: "");

  String get password => get(KEY_PASSWORD);

  String get token => get(KEY_TOKEN);

  DateTime get expiredAt => get(KEY_EXPIRED_AT);

  bool get isEnabled => get(KEY_IS_ENABLED, def: false);

  bool get isVerified => get(KEY_IS_VERIFIED, def: false);

  dynamic get(String key, {dynamic def}) => _data[key] ?? def;

  void set(String key, dynamic value) => _data[key] = value;
}
