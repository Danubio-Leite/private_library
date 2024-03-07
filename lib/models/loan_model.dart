import 'book_model.dart';
import 'user_model.dart';

class Loan {
  final int id;
  final User user;
  final Book book;
  final DateTime startDateLoan;
  final DateTime? endDateLoan;
  final String? loanNote;

  Loan({
    required this.id,
    required this.user,
    required this.book,
    required this.startDateLoan,
    this.endDateLoan,
    this.loanNote,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': user.id,
      'bookId': book.id,
      'startDateLoan': startDateLoan.toIso8601String(),
      'endDateLoan': endDateLoan?.toIso8601String(),
      'loanNote': loanNote,
    };
  }
}
