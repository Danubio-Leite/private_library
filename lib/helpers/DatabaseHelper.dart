import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io' as io;
import 'dart:async';
import '../models/book_model.dart';
import 'package:path/path.dart';

class DatabaseHelper extends ChangeNotifier {
  static final _databaseName = "indices.db";
  static final _databaseVersion = 1;
  static final DatabaseHelper _instance = new DatabaseHelper.internal();
  factory DatabaseHelper() => _instance;
  static Database? _db;

  // torna a classe singleton
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  // tem somente uma referência ao banco de dados
  static Database? _database;
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await setDB();
    return _database!;
  }

  Future<Database> get db async {
    if (_db != null) return _db!;
    _db = await setDB();
    return _db!;
  }

  DatabaseHelper.internal();

  setDB() async {
    String path = join(await getDatabasesPath(), _databaseName);
    return await openDatabase(path,
        version: _databaseVersion, onCreate: _onCreate);
  }

  void _onCreate(Database db, int version) async {
    await db.execute(
        "CREATE TABLE Book(id INTEGER PRIMARY KEY, isbn TEXT, title TEXT, author TEXT, publisher TEXT, genre TEXT, publishedDate TEXT, synopsis TEXT, subtitle TEXT, shelf TEXT, loanDate TEXT, returnDate TEXT, loanUserId INTEGER, format TEXT, cover TEXT)");
  }

  Future<int> saveBook(Book book) async {
    var dbClient = await db;
    int res = await dbClient.insert("Book", book.toMap());
    return res;
  }

  Future<List<Book>> getBooks() async {
    var dbClient = await db;
    List<Map> list = await dbClient.rawQuery('SELECT * FROM Book');
    List<Book> books = List<Book>.empty(growable: true);
    for (int i = 0; i < list.length; i++) {
      var book = new Book(
        id: list[i]["id"],
        isbn: list[i]["isbn"],
        title: list[i]["title"],
        author: list[i]["author"],
        publisher: list[i]["publisher"],
        genre: list[i]["genre"],
        publishedDate: list[i]["publishedDate"],
        synopsis: list[i]["synopsis"],
        subtitle: list[i]["subtitle"],
        shelf: list[i]["shelf"],
        loanDate: list[i]["loanDate"],
        returnDate: list[i]["returnDate"],
        loanUserId: list[i]["loanUserId"],
        format: list[i]["format"],
        cover: list[i]["cover"],
      );
      books.add(book);
    }
    return books;
  }
}
