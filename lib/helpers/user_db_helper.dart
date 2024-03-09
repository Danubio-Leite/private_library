import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/user_model.dart';

class UserDbHelper extends ChangeNotifier {
  static const _databaseName = "users.db";
  static const _databaseVersion = 1;
  static final UserDbHelper _instance = UserDbHelper.internal();
  factory UserDbHelper() => _instance;
  static Database? _db;

  UserDbHelper.internal();

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
        "CREATE TABLE User(id INTEGER PRIMARY KEY, name TEXT, phone TEXT, email TEXT)");
  }

  Future<int> saveUser(User user) async {
    var dbClient = await db;
    int res = await dbClient.insert("User", user.toMap());
    notifyListeners();
    return res;
  }

  Future<List<User>> getUsers() async {
    var dbClient = await db;
    List<Map> list = await dbClient.rawQuery('SELECT * FROM User');
    List<User> users = List<User>.empty(growable: true);
    for (int i = 0; i < list.length; i++) {
      var user = User(
        id: list[i]["id"],
        name: list[i]["name"],
        phone: list[i]["phone"],
        email: list[i]["email"],
      );
      users.add(user);
    }
    return users;
  }

  Future<int> deleteUser(User user) async {
    var dbClient = await db;
    int res =
        await dbClient.rawDelete('DELETE FROM User WHERE id = ?', [user.id]);
    notifyListeners();
    return res;
  }

  Future<int> updateUser(User user) async {
    var dbClient = await db;
    int res = await dbClient.update("User", user.toMap(),
        where: "id = ?", whereArgs: <int>[user.id]);
    notifyListeners();
    return res;
  }
}
