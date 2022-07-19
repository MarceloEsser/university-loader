import 'package:core/country_repository.dart';
import 'package:core/dao/app_dao.dart';
import 'package:core/network/services/university_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:university_loader/list/university_screen.dart';
import 'package:university_loader/list/university_bloc.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  //TODO: Translate all the Strings
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lista de universidades',
      theme: ThemeData(
        primarySwatch: Colors.pink,
      ),
      home: BlocProvider(
        create: (context) => UniversityBloc(UniversityService(AppDao()), CountryRepository()),
        child: const UniversityScreen(),
      ),
    );
  }
}
