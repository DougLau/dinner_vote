import 'dart:io';
import 'package:sqflite/sqflite.dart';
import 'package:synchronized/synchronized.dart';
import 'meal.dart';

class DbHelper {
  static final DbHelper _singleton = DbHelper._internal();

  factory DbHelper() => _singleton;

  final _lock = new Lock();
  Database _db;

  DbHelper._internal();

  Future<Database> get db async {
    if (_db == null) {
      await _lock.synchronized(() async {
        // Need to check again after lock is held
        if (_db == null) {
          _db = await _initDB();
        }
      });
    }
    return _db;
  }

  _initDB() async {
    var dbPath = await getDatabasesPath();
    var path = [dbPath, "dinnervote.db"].join("");
    await Directory(dbPath).create(recursive: true);
    return await openDatabase(path,
        version: 1,
        onOpen: (db) {},
        onConfigure: (db) => _configureDB(db),
        onCreate: (db, version) => _createDB(db, version));
  }

  _configureDB(Database db) async {
    await db.execute("PRAGMA foreign_keys = ON");
  }

  _createDB(Database db, int version) async {
    await db.execute("CREATE TABLE meal ("
        "id INTEGER PRIMARY KEY,"
        "title TEXT NOT NULL,"
        "description TEXT,"
        "on_menu INTEGER NOT NULL" // 0: no, 1: yes
        ")");
    await db.execute("CREATE TABLE person ("
        "id INTEGER PRIMARY KEY,"
        "name TEXT"
        ")");
    await db.execute("CREATE TABLE vote ("
        "id INTEGER PRIMARY KEY,"
        "meal INTEGER NOT NULL,"
        "person INTEGER NOT NULL,"
        "requested TEXT NOT NULL," // ISO-8601: YYYY-MM-DD
        "prepared TEXT," //           NULL if not prepared yet
        "FOREIGN KEY (meal) REFERENCES meal,"
        "FOREIGN KEY (person) REFERENCES person"
        ")");
  }

  Future<int> saveMeal(Meal meal) async {
    var dbi = await db;
    return await dbi.insert('meal', meal.toMap());
  }

  Future<List> getAllMeals() async {
    var dbi = await db;
    var meals = await dbi.query('meal', columns: ['id', 'title', 'description', 'on_menu']);
    return meals.toList();
  }

  Future<int> deleteMeal(int id) async {
    var dbi = await db;
    return await dbi.delete('meal', where: 'id = ?', whereArgs: [id]);
  }

  Future<int> updateMeal(Meal meal) async {
    var dbi = await db;
    return await dbi.update('meal', meal.toMap(), where: 'id = ?', whereArgs: [meal.id]);
  }
}
