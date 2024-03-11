import 'book_model.dart';

class Reading {
  final int id;
  final Book book;
  final DateTime startDateReading;
  final DateTime? endDateReading;
  final String? readingNote;

  Reading({
    required this.id,
    required this.book,
    required this.startDateReading,
    this.endDateReading,
    this.readingNote,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'bookId': book.id,
      'startDateReading': startDateReading.toIso8601String(),
      'endDateReading': endDateReading?.toIso8601String(),
      'readingNote': readingNote,
    };
  }

  factory Reading.fromMap(Map<String, dynamic> map) {
    return Reading(
      id: map['id'],
      book: Book.fromMap(map),
      startDateReading: DateTime.parse(map['startDateReading']),
      endDateReading: map['endDateReading'] != null
          ? DateTime.parse(map['endDateReading'])
          : null,
      readingNote: map['readingNote'],
    );
  }
}
