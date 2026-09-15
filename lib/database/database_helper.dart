import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../models/game.dart';

class DatabaseHelper {
  DatabaseHelper._();

  static final DatabaseHelper instance = DatabaseHelper._();
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, 'games.db');

    return openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE games (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT NOT NULL,
            platform TEXT NOT NULL,
            status TEXT NOT NULL,
            rating REAL,
            notes TEXT NOT NULL DEFAULT ''
          )
        ''');
      },
    );
  }

  Future<int> insertGame(Game game) async {
    final db = await database;
    final data = game.toMap()..remove('id');
    return db.insert('games', data);
  }

  Future<List<Game>> getGames() async {
    final db = await database;
    final result = await db.query('games', orderBy: 'name COLLATE NOCASE ASC');
    return result.map(Game.fromMap).toList();
  }

  Future<int> updateGame(Game game) async {
    final db = await database;
    final data = game.toMap()..remove('id');
    return db.update(
      'games',
      data,
      where: 'id = ?',
      whereArgs: [game.id],
    );
  }

  Future<int> deleteGame(int id) async {
    final db = await database;
    return db.delete('games', where: 'id = ?', whereArgs: [id]);
  }
}
