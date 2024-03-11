import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import '../models/wish_model.dart';

class WishDbHelper extends ChangeNotifier {
  static const _databaseName = "wishes.db";
  static const _databaseVersion = 1;
  static final WishDbHelper _instance = WishDbHelper.internal();
  factory WishDbHelper() => _instance;
  static Database? _db;

  WishDbHelper.internal();

  Future<Database> get db async {
    if (_db != null) return _db!;
    _db = await setDB();
    return _db!;
  }

  setDB() async {
    String path = join(await getDatabasesPath(), _databaseName);
    return await openDatabase(path,
        version: _databaseVersion, onCreate: _onCreate);
  }

  void _onCreate(Database db, int version) async {
    await db.execute(
        "CREATE TABLE Wish(id INTEGER PRIMARY KEY, title TEXT, author TEXT)");
  }

  Future<int> saveWish(Wish wish) async {
    var dbClient = await db;
    int res = await dbClient.insert("Wish", wish.toMap());
    notifyListeners();
    return res;
  }

  Future<List<Wish>> getWishes() async {
    var dbClient = await db;
    List<Map> list = await dbClient.rawQuery('SELECT * FROM Wish');
    List<Wish> wishes = List<Wish>.empty(growable: true);
    for (int i = 0; i < list.length; i++) {
      var wish = Wish(
        id: list[i]["id"],
        title: list[i]["title"],
        author: list[i]["author"],
      );
      wishes.add(wish);
    }
    return wishes;
  }

  Future<int> deleteWish(int id) async {
    var dbClient = await db;
    int res = await dbClient.rawDelete('DELETE FROM Wish WHERE id = ?', [id]);
    notifyListeners();
    return res;
  }
}
