class Book {
  final String id;
  final String title;
  final String author;
  final String genre;
  final String description;
  final DateTime? publishedDate;
  final String? coverImage;

  Book({
    required this.id,
    required this.title,
    required this.author,
    required this.genre,
    required this.description,
    this.publishedDate,
    this.coverImage,
  });

  factory Book.fromJson(Map<String, dynamic> json) {
    return Book(
      id: json['_id'],
      title: json['title'],
      author: json['author'] ?? '',
      genre: json['genre'] ?? '',
      description: json['description'] ?? '',
      publishedDate: json['publishedDate'] != null
          ? DateTime.tryParse(json['publishedDate'])
          : null,
      coverImage: json['coverImage'],
    );
  }

  Map<String, String?> toJson() => {
    'title': title,
    'author': author,
    'genre': genre,
    'description': description,
    'publishedDate': publishedDate?.toIso8601String(),
  };
}
