import 'dart:convert';

import 'package:commons/model/country.dart';
import 'package:flutter/services.dart';

class CountryRepository {

  Future <List<Country>> getCountries() async {
    final data = await rootBundle.loadString('assets/countries.json');
    List<dynamic> decodedJson = await jsonDecode(data);
    List<Country> countryData = decodedJson.map((i) => Country.fromJson(i)).toList();
    return countryData;
  }

}