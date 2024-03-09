import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:async';
import '../models/book_model.dart';
import 'package:path/path.dart';

class BookDbHelper extends ChangeNotifier {
  static const _databaseName = "indices.db";
  static const _databaseVersion = 1;
  static final BookDbHelper _instance = BookDbHelper.internal();
  factory BookDbHelper() => _instance;
  static Database? _db;

  // torna a classe singleton
  BookDbHelper._privateConstructor();
  static final BookDbHelper instance = BookDbHelper._privateConstructor();

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

  BookDbHelper.internal();

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
    notifyListeners();
    return res;
  }

  Future<List<Book>> getBooks() async {
    var dbClient = await db;
    List<Map> list = await dbClient.rawQuery('SELECT * FROM Book');
    List<Book> books = List<Book>.empty(growable: true);
    for (int i = 0; i < list.length; i++) {
      var book = Book(
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

  Future<List<Book>> searchBooks(String query) async {
    var dbClient = await db;
    List<Map> list = await dbClient
        .rawQuery('SELECT * FROM Book WHERE title LIKE ?', ['%$query%']);
    List<Book> books = List<Book>.empty(growable: true);
    for (int i = 0; i < list.length; i++) {
      var book = Book(
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

  Future<void> deleteBook(int id) async {
    var dbClient = await db;
    await dbClient.delete(
      'Book',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> deleteBooks(List<Book> books) async {
    var dbClient = await db;
    var batch = dbClient.batch();
    for (var book in books) {
      batch.delete(
        'Book',
        where: 'id = ?',
        whereArgs: [book.id],
      );
    }
    await batch.commit(noResult: true);
    notifyListeners();
  }
}
