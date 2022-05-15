import 'package:commons/model/university.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DaoHelper {
  insert(List<University>? data) async {
    if (_openDatabase() == null) {
      throw Exception("Houve um erro ao gerar o banco de dados");
    }

    if (data != null) {
      _openDatabase()?.then((database) {
        for (var item in data) {
          database.insert(
            University.tableName,
            item.toMap(),
            conflictAlgorithm: ConflictAlgorithm.replace,
          );
        }
      }).onError((error, stackTrace) => throw stackTrace);
    }
  }

  Future<List<University>?> loadMatchUpHistory() async {
    if (_openDatabase() == null) {
      throw Exception("Houve um erro ao gerar o banco de dados");
    }

    return _openDatabase()?.then((database) async {
      database
          .query(University.tableName)
          .then((value) => value.map((i) => University.fromMap(i)).toList())
          .onError((error, stackTrace) => throw stackTrace);
    });
  }

  Future<Database>? _openDatabase() {
    return getDatabasesPath().then((value) {
      String path = join(value, 'university_loader.db');

      return openDatabase(
        path,
        onCreate: (db, version) => _createTable(db),
        version: 1,
        onDowngrade: onDatabaseDowngradeDelete,
      );
    }).onError((error, stackTrace) => throw stackTrace);
  }

  _createTable(Database db) {
    db.execute(University.table());
  }
}
