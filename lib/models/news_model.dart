class News {
  final String title;
  final String author;
  final String description;
  final String url;
  final String urlToImage;
  final String publishedAt;
  final String category;
  final String authorImageUrl;

  News({
    required this.title,
    required this.author,
    required this.description,
    required this.url,
    required this.urlToImage,
    required this.publishedAt,
    this.category = '',
    this.authorImageUrl = '',
  });

  factory News.fromJson(Map<String, dynamic> json, {String category = ''}) {
    return News(
      title: json['title'] ?? 'No Title',
      author: json['author'] ?? 'Unknown',
      description: json['description'] ?? '',
      url: json['url'] ?? '',
      urlToImage: json['urlToImage'] ?? '',
      publishedAt: json['publishedAt'] ?? '',
      category: category,
      authorImageUrl: '',
    );
  }

  String get imageUrl =>
      urlToImage.isNotEmpty
          ? urlToImage
          : 'https://example.com/default-image.png';

  DateTime? get publishedDateTime {
    try {
      return DateTime.parse(publishedAt);
    } catch (e) {
      return null;
    }
  }

  
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is News && runtimeType == other.runtimeType && url == other.url;

  @override
  int get hashCode => url.hashCode;
}
