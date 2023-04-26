
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../Note.dart';

class DatabaseService{

  final String createDatabaseQuery = "CREATE TABLE note(id INTEGER PRIMARY KEY AUTOINCREMENT,title TEXT,description TEXT,timestamp INTEGER)";

  final int databaseVersion = 3;

  Future<Database> initializeDB() async {
    String path = await getDatabasesPath();
    var isCheck = await isDatabaseExists("$path/NOTE.db");
    if(!isCheck){
      return openDatabase(
        join(path, 'NOTE.db'),
        onCreate: (database, version) async{
          await database.execute(createDatabaseQuery);
        },
        version: databaseVersion,
      );
    } else {
      return openDatabase("$path/NOTE.db");
    }
  }

  Future<int?> createItem(Note note) async{
    final Database db = await initializeDB();
    final id = await db.insert('note', note.toMap(),conflictAlgorithm: ConflictAlgorithm.replace);
    return id;
  }

  Future<List<Note>> getAllItem() async {
    final db = await initializeDB();
    final List<Map<String, Object?>> queryResult = await db.query('note', orderBy: "id DESC");
    return queryResult.map((e) => Note.fromMap(e)).toList();
  }

  Future<bool> isDatabaseExists(String path) => databaseFactory.databaseExists(path);

}