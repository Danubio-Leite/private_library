import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/loan_model.dart';
import '../models/book_model.dart';
import '../models/user_model.dart';
import 'book_db_helper.dart';
import 'user_db_helper.dart';

class LoanDbHelper extends ChangeNotifier {
  static const _databaseName = "loans.db";
  static const _databaseVersion = 1;
  static final LoanDbHelper _instance = LoanDbHelper.internal();
  factory LoanDbHelper() => _instance;
  static Database? _db;

  LoanDbHelper.internal();

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
        "CREATE TABLE Loan(id INTEGER PRIMARY KEY, userId INTEGER, bookId INTEGER, startDateLoan TEXT, endDateLoan TEXT, loanNote TEXT)");
  }

  Future<int> saveLoan(Loan loan) async {
    var dbClient = await db;
    int res = await dbClient.insert("Loan", loan.toMap());
    return res;
  }

  Future<Book> getBook(int id) async {
    var dbClient = await BookDbHelper().db;
    List<Map> result =
        await dbClient.query("Book", where: "id = ?", whereArgs: [id]);
    return Book.fromMap(result.first as Map<String, dynamic>);
  }

  Future<User> getUser(int id) async {
    var dbClient = await UserDbHelper().db;
    List<Map> result =
        await dbClient.query("User", where: "id = ?", whereArgs: [id]);
    return User.fromMap(result.first as Map<String, dynamic>);
  }

  Future<List<Loan>> getLoans() async {
    var dbClient = await db;
    List<Map> list = await dbClient.rawQuery('SELECT * FROM Loan');
    List<Loan> loans = List<Loan>.empty(growable: true);
    for (int i = 0; i < list.length; i++) {
      var loan = Loan(
        id: list[i]["id"],
        user: await getUser(list[i]["userId"]),
        book: await getBook(list[i]["bookId"]),
        startDateLoan: DateTime.parse(list[i]["startDateLoan"]),
        endDateLoan: list[i]["endDateLoan"] != null
            ? DateTime.parse(list[i]["endDateLoan"])
            : null,
        loanNote: list[i]["loanNote"],
      );
      loans.add(loan);
    }
    return loans;
  }
}
