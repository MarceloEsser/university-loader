import 'dart:convert';
import 'dart:isolate';

import 'package:commons/model/country.dart';
import 'package:commons/model/university.dart';
import 'package:http/http.dart' as http;
import 'package:http_interceptor/http/http.dart';

import '../../dao/dao_callback.dart';
import '../data_bound_resource.dart';
import '../utils/logging_interceptor.dart';
import '../wraper/resource.dart';

class UniversityService {
  final DaoCallback dao;
  final String baseUrl = "http://universities.hipolabs.com/search?country=";

  UniversityService(this.dao);

  ReceivePort loadUniversities(Country? country) {
    String countryCode = country?.code ?? "Brazil";
    var url = Uri.parse(baseUrl + countryCode);

    return DataBoundResource<List<University>>(
      createCall: () async {
        http.Response response = await client.get(url);

        if (response.statusCode == 200) {
          List<dynamic>? mappedResponse = json.decode(response.body);
          var universityList =
              mappedResponse?.map((i) => University.fromMap(i)).toList();

          return Resource.success(universityList);
        }

        String reason = response.reasonPhrase ?? "Erro na chamada";
        return Resource.error(reason);
      },
      fetchFromDatabase: () async {
        //TODO: Load a country with a list of universities
        return await dao.loadUniversities();
      },
      saveCallResult: (data) {
        //TODO: Insert a country with a list of universities
        dao.insertUniversities(data);
      },
    ).build();
  }
}

final http.Client client = InterceptedClient.build(
  interceptors: [LoggingInterceptor()],
  requestTimeout: const Duration(seconds: 60),
);
