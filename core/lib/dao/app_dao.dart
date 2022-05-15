
import 'package:commons/model/university.dart';

import 'dao_callback.dart';
import 'dao_helper.dart';

class AppDao extends DaoCallback {
  DaoHelper daoHelper = DaoHelper();

  @override
  insertUniversities(List<University>? data) {
    daoHelper.insert(data);
  }

  @override
  Future<List<University>?> loadUniversities() {
    return daoHelper.loadMatchUpHistory();
  }
}
