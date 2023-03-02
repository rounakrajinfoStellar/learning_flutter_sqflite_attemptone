import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper{


  static const dbName = "myDatabase.db";
  static const dbVersion = 1;
  static const dbTable = "myTable";
  static const columnId = "id";
  static const columnName = "name";

  static final DatabaseHelper instance = DatabaseHelper();

  static Database? _database;

  Future<Database?> get database async {
    // _database ?? = await initDB();
    if(_database == null) {
      _database = await initDB();
    }
    return _database;

  }


  initDB() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String path = join(directory.path, dbName);
    return await openDatabase(path,version: dbVersion, onCreate: onCreate);
  }

  Future onCreate(Database db, int version) async {
  db.execute(
      '''
      CREATE TABLE $dbTable (
      $columnId INTEGER PRIMARY KEY,
      $columnName TEXT NOT NULL
      )
      ''');
    }

    //insert method

    insertRecord(Map<String, dynamic> row) async {
    Database? db = await instance.database;
    return await db!.insert(dbTable, row);
    }

    //read/query method

    Future<List<Map<String, dynamic>>> queryDatabase() async {
    Database? db = await instance.database;
    return await db!.query(dbTable);
    }
    //I/flutter ( 8278): [{id: 1, name: Rounak Raj}, {id: 2, name: raj}]

    //update method

    Future<int> updateRecord(Map<String, dynamic> row) async {
    Database? db = await instance.database;
    int id = row[columnId];
    return await db!.update(dbTable, row, where: '$columnId = ?', whereArgs: [id]);
    }

    //delete method
    Future<int> deleteRecord(int id) async {
    Database? db = await instance.database;
    return await db!.delete(dbTable,where: '$columnId = ?', whereArgs: [id]);
    }






}