import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/preferences_model.dart';

class PreferencesDbHelper extends ChangeNotifier {
  static const _databaseName = "myDatabase.db";
  static const _databaseVersion = 1;

  static const table = 'preferences';

  static const columnId = 'id';
  static const columnLibraryName = 'libraryName';
  static const columnUserName = 'userName';
  static const columnLogoPath = 'logoPath';
  static const columnTheme = 'theme';
  static const columnLanguage = 'language';

  static final PreferencesDbHelper _instance = PreferencesDbHelper._internal();
  factory PreferencesDbHelper() => _instance;
  static Database? _database;

  PreferencesDbHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<void> init() async {
    _database = await _initDatabase();
  }

  _initDatabase() async {
    String path = join(await getDatabasesPath(), _databaseName);
    return await openDatabase(path,
        version: _databaseVersion, onCreate: _onCreate);
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
          CREATE TABLE $table (
            $columnId INTEGER PRIMARY KEY,
            $columnLibraryName TEXT NOT NULL,
            $columnUserName TEXT NOT NULL,
            $columnLogoPath TEXT,
            $columnTheme TEXT NOT NULL,
            $columnLanguage TEXT
          )
          ''');
  }

  Future<int> insert(Preferences preferences) async {
    Database db = await _instance.database;
    int id = await db.insert(table, preferences.toMap());
    notifyListeners();
    return id;
  }

  Future<List<Preferences>> queryAllRows() async {
    Database db = await _instance.database;
    var res = await db.query(table);
    List<Preferences> list =
        res.isNotEmpty ? res.map((c) => Preferences.fromMap(c)).toList() : [];
    return list;
  }

  Future<int> update(Preferences preferences) async {
    Database db = await _instance.database;
    int id = await db.update(table, preferences.toMap(),
        where: '$columnId = ?', whereArgs: [preferences.id]);
    notifyListeners();
    return id;
  }

  Future<int> delete(int id) async {
    Database db = await _instance.database;
    int result =
        await db.delete(table, where: '$columnId = ?', whereArgs: [id]);
    notifyListeners();
    return result;
  }
}
