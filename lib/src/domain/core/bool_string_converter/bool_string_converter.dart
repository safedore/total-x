class BoolStringListConverter {
  static dynamic fromJson(dynamic json) {
    if (json == null) {
      return null;
    }
    if (json == false) {
      return null;
    }
    if (json is String) {
      return json;
    }
    if (json is List<dynamic>?) {
      return json;
    }
    if (json is DateTime) {
      return json.toIso8601String();
    }
    return json;
  }
}
