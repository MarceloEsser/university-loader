class University {
  int? id;
  String? alphaTwoCode;
  String? country;
  String? name;

  University({this.alphaTwoCode, this.country, this.name});

  static University fromMap(dynamic map) {
    return University(
      alphaTwoCode: map['alpha_two_code']?.toString(),
      country: map['country']?.toString(),
      name: map['name']?.toString(),
    );
  }

  static const String tableName = "University";

  static String table() {
    return "CREATE TABLE $tableName ("
        "id INTEGER PRIMARY KEY AUTOINCREMENT,"
        "alpha_two_code TEXT,"
        "country TEXT,"
        "name TEXT)";
  }

  Map<String, dynamic> toMap() {
    return {
      'alpha_two_code': alphaTwoCode,
      'country': country,
      'name': name,
    };
  }
}
