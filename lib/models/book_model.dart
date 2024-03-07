class Book {
  final int id;
  final String? isbn;
  final String title;
  final String author;
  final String? publisher;
  final String? genre;
  final String? publishedDate;
  final String? synopsis;
  final String? subtitle;
  final String? shelf;
  final String? loanDate;
  final String? returnDate;
  final int? loanUserId;
  final String? format;
  final String? cover;

  Book({
    required this.id,
    this.isbn,
    required this.title,
    required this.author,
    this.publisher,
    this.genre,
    this.publishedDate,
    this.synopsis,
    this.subtitle,
    this.shelf,
    this.loanDate,
    this.returnDate,
    this.loanUserId,
    this.format,
    this.cover,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'isbn': isbn,
      'title': title,
      'author': author,
      'publisher': publisher,
      'genre': genre,
      'publishedDate': publishedDate,
      'synopsis': synopsis,
      'subtitle': subtitle,
      'shelf': shelf,
      'loanDate': loanDate,
      'returnDate': returnDate,
      'loanUserId': loanUserId,
      'format': format,
      'cover': cover,
    };
  }

  factory Book.fromMap(Map<String, dynamic> map) {
    return Book(
      id: map['id'],
      isbn: map['isbn'],
      title: map['title'],
      author: map['author'],
      publisher: map['publisher'],
      genre: map['genre'],
      publishedDate: map['publishedDate'],
      synopsis: map['synopsis'],
      subtitle: map['subtitle'],
      shelf: map['shelf'],
      loanDate: map['loanDate'],
      returnDate: map['returnDate'],
      loanUserId: map['loanUserId'],
      format: map['format'],
      cover: map['cover'],
    );
  }
}
