class Vocabulary {
  final String id;
  final String word;
  final String meaning;

  Vocabulary({
    required this.id,
    required this.word,
    required this.meaning,
  });

  Map<String, dynamic> toMap() {
    return {
      'word': word,
      'meaning': meaning,
    };
  }

  factory Vocabulary.fromMap(Map<String, dynamic> map, String docId) {
    return Vocabulary(
      id: docId,
      word: map['word'],
      meaning: map['meaning'],
    );
  }
}
