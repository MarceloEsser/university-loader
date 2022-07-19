import 'package:bloc/bloc.dart';
import 'package:commons/model/country.dart';
import 'package:commons/model/university.dart';
import 'package:core/country_repository.dart';
import 'package:core/network/services/university_service.dart';
import 'package:core/network/wraper/resource.dart';
import 'package:core/network/wraper/status.dart';

class UniversityBloc extends Cubit<Status> {
  final UniversityService service;
  final CountryRepository countryRepository;

  UniversityBloc(this.service, this.countryRepository) : super(Status.loading);

  String? message;
  List<University> data = [];
  List<Country> countryList = [];
  //TODO: Use shared preferences to save the selected country
  Country? selectedCountry;

  Future loadCountries() async {
    countryList = await countryRepository.getCountries();
  }

  void loadList() async {
    emit(Status.loading);
    await loadCountries();

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
