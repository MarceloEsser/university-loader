import 'package:commons/model/university.dart';

abstract class DaoCallback {
  void insertUniversities(List<University>? data);

  Future<List<University>?> loadUniversities();
}
