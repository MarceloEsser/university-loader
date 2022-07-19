class Country {
  final String name;
  final String displayName;
  final String code;
  final String isoTwo;

  String get flagEmoji => _countryCodeToEmoji();

  Country(this.name, this.displayName, this.code, this.isoTwo);

  static Country fromJson(Map<String, dynamic>? jsonData) {
    if (jsonData == null) return Country("", "", "", "");
    return Country(jsonData["name"], jsonData["display_name_no_e164_cc"],
        "+${jsonData["e164_cc"]}", jsonData["iso2_cc"]);
  }

  String _countryCodeToEmoji() {
    if (isoTwo.isEmpty) return "";
    final int firstLetter = isoTwo.codeUnitAt(0) - 0x41 + 0x1F1E6;
    final int secondLetter = isoTwo.codeUnitAt(1) - 0x41 + 0x1F1E6;
    return String.fromCharCode(firstLetter) + String.fromCharCode(secondLetter);
  }
}
