import 'package:bloc/bloc.dart';
import 'package:commons/model/country.dart';
import 'package:commons/model/university.dart';
import 'package:core/network/services/university_service.dart';
import 'package:core/network/wraper/resource.dart';
import 'package:core/network/wraper/status.dart';

class UniversityBloc extends Cubit<Status> {
  final UniversityService service;

  UniversityBloc(this.service) : super(Status.loading);

  String? message;
  List<University> data = [];
  List<Country> countryList = [
    Country("Brasil", "Brazil"),
    Country("Estados Unidos", "United+States"),
  ];
  //TODO: Use shared preferences to save the selected country
  Country? selectedCountry;

  void loadList() {
    emit(Status.loading);
    service.loadUniversities(selectedCountry).listen((message) {
      Resource resource = message;
      if (resource.status == Status.success) {
        var data = resource.data as List<University>?;
        this.data = data ?? [];
        emit(Status.success);
      }
      if (resource.status == Status.error) {
        this.message = resource.message;
        emit(Status.error);
      }
    }).onError((message) {
      this.message = message;
      emit(Status.error);
    });
  }
}
