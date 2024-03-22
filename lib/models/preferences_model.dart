class Preferences {
  int id;
  String libraryName;
  String userName;
  String? logoPath;
  String theme;
  String? language;

  Preferences({
    required this.id,
    required this.libraryName,
    required this.userName,
    this.logoPath,
    required this.theme,
    this.language,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'libraryName': libraryName,
      'userName': userName,
      'logoPath': logoPath,
      'theme': theme,
      'language': language,
    };
  }

  factory Preferences.fromMap(Map<String, dynamic> map) {
    return Preferences(
      id: map['id'],
      libraryName: map['libraryName'],
      userName: map['userName'],
      logoPath: map['logoPath'],
      theme: map['theme'],
      language: map['language'],
    );
  }
}
