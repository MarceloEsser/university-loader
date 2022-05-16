import 'package:commons/model/university.dart';
import 'package:path/path.dart' as p;
import 'package:sqflite/sqflite.dart';

class DaoHelper {
  
  //TODO: Insert by country
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

    return _openDatabase()?.then((database) {
      return database
          .query(University.tableName)
          .then((value) => value.map((i) => University.fromMap(i)).toList())
          .onError((error, stackTrace) => throw stackTrace);
    });
  }

  Future<Database>? _openDatabase() async {
    String directory = await getDatabasesPath();
    String path = p.join(directory.toString(), 'university_loader.db');

    return openDatabase(
      path,
      onCreate: (db, version) => _createTable(db),
      version: 1,
      onDowngrade: onDatabaseDowngradeDelete,
    );
  }

  _createTable(Database db) {
    db.execute(University.table());
  }
}
