import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share/share.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:async';
import '../models/book_model.dart';
import 'package:path/path.dart';

import 'loan_db_helper.dart';
import 'reading_db_helper.dart';

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

  Future<void> exportBooksToJson() async {
    List<Book> books = await getBooks();
    print(
        'Books fetched: ${books.length}'); // Imprime o número de livros buscados

    String jsonBooks = jsonEncode(books.map((book) => book.toMap()).toList());

    // Obtenha o diretório de documentos do aplicativo
    Directory directory = await getApplicationDocumentsDirectory();
    String path = directory.path;
    print('Directory path: $path'); // Imprime o caminho do diretório

    // Crie um arquivo no diretório de documentos
    File file = File('$path/books.json');
    await file.writeAsString(jsonBooks);
    print('File written: ${file.path}'); // Imprime o caminho do arquivo

    // Compartilhe o arquivo
    Share.shareFiles([file.path], text: 'Arquivo de backup dos livros');
  }

  Future<void> importBooksFromJson() async {
    // Deixe o usuário escolher o arquivo para importar
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['json'],
    );

    if (result != null) {
      File file = File(result.files.single.path!);
      String jsonBooks = await file.readAsString();
      List<dynamic> list = jsonDecode(jsonBooks);

      // Obtenha todos os livros existentes e exclua-os
      List<Book> existingBooks = await getBooks();
      await deleteBooks(existingBooks);

      // Agora insira os novos livros do arquivo JSON
      for (var item in list) {
        Book book = Book.fromMap(item);
        await saveBook(book);
      }
    }
  }

  Future<void> deleteBooks(List<Book> books) async {
    var dbClient = await db;
    var loanDbClient = await LoanDbHelper().db;
    var readingDbClient = await ReadingDbHelper().db;
    var batch = dbClient.batch();
    for (var book in books) {
      // Excluir empréstimos e leituras associados
      await loanDbClient.delete(
        'Loan',
        where: 'bookId = ?',
        whereArgs: [book.id],
      );
      await readingDbClient.delete(
        'Reading',
        where: 'bookId = ?',
        whereArgs: [book.id],
      );

      // Excluir o livro
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
