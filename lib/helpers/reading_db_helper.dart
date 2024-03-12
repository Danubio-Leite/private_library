import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/reading_model.dart';
import '../models/book_model.dart';
import 'book_db_helper.dart';

class ReadingDbHelper extends ChangeNotifier {
  static const _databaseName = "readings.db";
  static const _databaseVersion = 1;
  static final ReadingDbHelper _instance = ReadingDbHelper.internal();
  factory ReadingDbHelper() => _instance;
  static Database? _db;

  ReadingDbHelper.internal();

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
        "CREATE TABLE Reading(id INTEGER PRIMARY KEY, bookId INTEGER, startDateReading TEXT, endDateReading TEXT, readingNote TEXT)");
  }

  Future<int> saveReading(Reading reading) async {
    var dbClient = await db;
    int res = await dbClient.insert("Reading", reading.toMap());
    notifyListeners();
    return res;
  }

  Future<Book> getBook(int id) async {
    var dbClient = await BookDbHelper().db;
    List<Map> result =
        await dbClient.query("Book", where: "id = ?", whereArgs: [id]);
    return Book.fromMap(result.first as Map<String, dynamic>);
  }

  Future<List<Reading>> getReadings() async {
    var dbClient = await db;
    List<Map> list = await dbClient.rawQuery('SELECT * FROM Reading');
    List<Reading> readings = List<Reading>.empty(growable: true);
    for (int i = 0; i < list.length; i++) {
      var reading = Reading(
        id: list[i]["id"],
        book: await getBook(list[i]["bookId"]),
        startDateReading: DateTime.parse(list[i]["startDateReading"]),
        endDateReading: list[i]["endDateReading"] != null
            ? DateTime.parse(list[i]["endDateReading"])
            : null,
        readingNote: list[i]["readingNote"],
      );
      readings.add(reading);
    }
    return readings;
  }

  Future<int> deleteReading(int id) async {
    var dbClient = await db;
    int res =
        await dbClient.rawDelete('DELETE FROM Reading WHERE id = ?', [id]);
    notifyListeners();
    return res;
  }

  Future<int> updateReading(
    Reading reading,
  ) async {
    var dbClient = await db;
    int res = await dbClient.update("Reading", reading.toMap(),
        where: "id = ?", whereArgs: <int>[reading.id]);
    notifyListeners();
    return res;
  }
}
