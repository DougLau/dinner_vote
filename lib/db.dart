import 'package:sqflite/sqflite.dart';

class DBProvider {
  static final db = DBProvider._();

  static Database _database;

  DBProvider._();

  Future<Database> get database async {
    if (_database != null) return _database;
    _database = await initDB();
    return _database;
  }
}

initDB() async {
  var dbPath = await getDatabasesPath();
  var path = [dbPath, "dinnervote.db"].join("");
  return await openDatabase(path,
      version: 1,
      onOpen: (db) {},
      onCreate: (db, version) => createDB(db, version));
}

createDB(Database db, int version) async {
  await db.execute("CREATE TABLE meal ("
      "id INTEGER PRIMARY KEY,"
      "description TEXT"
      ")");
}
