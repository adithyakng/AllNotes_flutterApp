import 'package:AllNote/models/notes.dart';
import 'package:flutter/cupertino.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';


class DbNotesHelper extends ChangeNotifier {
  static Database _db;
  static const String DB_NAME = "notes";
  static const String ID = "id";
  static const String CREATED_ON = "createdOn";
  static const String UPDATED_ON = "updatedOn";
  static const String TITLE = "title";
  static const String DATA = "data";
  static const String FAVOURITE = "favourite";

  Future<Database> get db async {
    if (_db != null) {
      return _db;
    } else {
      return await initDB();
    }
  }

  Future<Database> initDB() async {
    var appDir = await getApplicationDocumentsDirectory();
    var path = join(appDir.path, DB_NAME);
    var db = await openDatabase(path, version: 1, onCreate: _createTable);
    return db;
  }

  _createTable(Database db, int version) async {
    await db.execute("CREATE TABLE $DB_NAME ("
        "id TEXT PRIMARY KEY,"
        "title TEXT,"
        "data TEXT,"
        "createdOn TEXT,"
        "updatedOn TEXT,"
        "favourite INTEGER)");
  }

  Future<int> insert(Notes note) async {
    var database = await db;
    var p = await database.insert(DB_NAME, note.toMap());
    print(p);
    notifyListeners();
    return p;
  }

  Future<List<Notes>> getAllNotes() async {
    var database = await db;
    List<Map<String, dynamic>> list = await database.query(DB_NAME);
    List<Notes> notesList =new List<Notes>();
    list.forEach((element) {
      print(element);
      notesList.add(Notes.fromMap(element));
    });
    return notesList;
  }

  delete(Notes note) async{
    var database = await db;
    await database.delete(DB_NAME,where: "$ID = ?",whereArgs: [note.id.toIso8601String()]);
  }

  toggleFavourite(Notes note) async{
    var database = await db;
    await database.update(DB_NAME, note.toMap(),where: "$ID = ?",whereArgs: [note.id.toIso8601String()]);
  }

}
