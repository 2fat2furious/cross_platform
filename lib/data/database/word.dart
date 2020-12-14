class Word {
  int id;
  String word;
  String language;

  Word({
    this.id,
    this.word,
    this.language,
  });

  factory Word.fromMap(Map<String, dynamic> json) => Word(
    id: json['id'],
    word: json['word'],
    language: json['language'],
  );

  Map<String, dynamic> toMap() => {
    'id': id,
    'word': word,
    'language': language,
  };
}