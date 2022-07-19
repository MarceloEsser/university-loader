import 'package:commons/model/country.dart';
import 'package:commons/model/university.dart';
import 'package:commons/widget/modal_loader.dart';
import 'package:core/network/wraper/status.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:university_loader/list/university_bloc.dart';

class UniversityScreen extends StatelessWidget {
  const UniversityScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var bloc = BlocProvider.of<UniversityBloc>(context);
    bloc.loadList();

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Lista de universidades"),
      ),
      body: buildBlocBody(bloc),
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        child: Container(height: 50.0),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
              context: context,
              builder: (context) {
                return Container(
                  color: Colors.white,
                  height: 200,
                  child: ListView.builder(
                    itemBuilder: (context, position) {
                      Country country = bloc.countryList[position];
                      return Material(
                        color: Colors.white,
                        child: InkWell(
                          onTap: () {
                            bloc.selectedCountry = country;
                            bloc.loadList();
                          },
                          child: Column(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(vertical: 10),
                                child: Row(
                                  children: [
                                    Text(
                                      country.flagEmoji,
                                      style: GoogleFonts.mukta(fontSize: 24),
                                      textAlign: TextAlign.center,
                                    ),
                                    Text(
                                      country.name,
                                      style: GoogleFonts.mukta(fontSize: 24),
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                margin: const EdgeInsets.symmetric(horizontal: 20),
                                width: double.infinity,
                                height: 1,
                                color: Colors.black12,
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                    itemCount: bloc.countryList.length,
                  ),
                );
              });
        },
        child: const Icon(Icons.account_balance_outlined),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  BlocBuilder<UniversityBloc, Status> buildBlocBody(UniversityBloc bloc) {
    return BlocBuilder<UniversityBloc, Status>(
      bloc: bloc,
      builder: (context, state) {
        if (state == Status.success) {
          if (bloc.data.isNotEmpty) {
            return ListView.builder(
              physics: const BouncingScrollPhysics(),
              itemBuilder: (context, position) {
                University university = bloc.data[position];
                String data = university.name ?? "";
                return Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.1),
                          spreadRadius: 3,
                          blurRadius: 10,
                          offset: const Offset(0, 3),
                        ),
                      ]),
                  padding: const EdgeInsets.all(20),
                  margin:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                  width: double.infinity,
                  child: Text(
                    data,
                    style: GoogleFonts.ubuntu(fontSize: 18),
                    textAlign: TextAlign.center,
                  ),
                );
              },
              itemCount: bloc.data.length,
            );
          }
          return Center(
            child: Container(
              color: Colors.purpleAccent,
            ),
          );
        }

        if (state == Status.error) {
          return Center(
            child: Container(
              color: Colors.red,
            ),
          );
        }

        return const ModalLoader();
      },
    );
  }
}
