import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class DatabaseConnection{
  setDatabase() async{
    var directory = await getApplicationDocumentsDirectory();
    var path = join(directory.path, 'db.ok');
    var database = await openDatabase(path, version: 1, onCreate: _onCreatingdatabase);
    return database;
  }

  _onCreatingdatabase(Database database, int version) async {
    return await database.execute("CREATE TABLE helloworld(id INTEGER  PRIMARY KEY, name TEXT, description TEXT)");
  }
}