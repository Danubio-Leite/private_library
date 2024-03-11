class Wish {
  int id;
  String title;
  String? author;

  Wish({
    required this.id,
    required this.title,
    this.author,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'author': author,
    };
  }

  factory Wish.fromMap(Map<String, dynamic> map) {
    return Wish(
      id: map['id'],
      title: map['title'],
      author: map['author'],
    );
  }
}
