import 'dart:ffi';

import 'package:sqflite/sqflite.dart';
import 'package:todo_app/models/task.dart';

class DbHelper {
  static Database? _db;
  static const int _version = 1;
  static const String _tableName = "todos";

  static Future<void> initDb() async {
    if (_db != null) {
      return;
    }
    try {
      String path = await getDatabasesPath() + "todos.db";
      _db = await openDatabase(
        path,
        version: _version,
        onCreate: (db, version) {
          print("veritabanı oluşturuldu $_tableName");
          return db.execute(
            "CREATE TABLE todos(id INTEGER PRIMARY KEY AUTOINCREMENT, title STRING, note TEXT , date STRING,remind INTEGER, repeat STRING,color INTEGER, startTime STRING, isCompleted INTEGER,endTime STRING)",
          );
        },
      );
    } catch (e) {
      print(e);
    }
  }

  static Future<int> instert(Task? task) async {
    print("Ekleme metodu ${task!.title.toString()} $_tableName eklendi");
    return await _db?.insert(_tableName, task.toJson()) ?? 1;
  }

  static Future<List<Map<String, dynamic>>> query() async {
    print("$_tableName Okuma metodu çalıştı");
    var queries = await _db!.query(_tableName);
    if (queries != null) {
      return queries;
    } else {
      return queries;
      print("$_tableName is null");
    }
  }

  static delete(Task task) async {
    print("${task.id} silindi");
    await _db!.delete(_tableName, where: 'id=?', whereArgs: [task.id]);
  }

  static update(int id) async {
    return await _db!.rawUpdate('''
      UPDATE todos 
      SET isCompleted = ?
      WHERE id =?
      ''', [1, id]);
  }
}
