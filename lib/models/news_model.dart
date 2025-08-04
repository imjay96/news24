class News {
  final String title;
  final String author;
  final String description;
  final String urlToImage;
  final String publishedAt;
  final String category;
  final String authorImageUrl; // ✅ เพิ่มตรงนี้

  News({
    required this.title,
    required this.author,
    required this.description,
    required this.urlToImage,
    required this.publishedAt,
    this.category = '',
    this.authorImageUrl = '', // ✅ ค่าเริ่มต้น
  });

  factory News.fromJson(Map<String, dynamic> json, {String category = ''}) {
    return News(
      title: json['title'] ?? 'No Title',
      author: json['author'] ?? 'Unknown',
      description: json['description'] ?? '',
      urlToImage: json['urlToImage'] ?? '',
      publishedAt: json['publishedAt'] ?? '',
      category: category,
      // ✅ ปัจจุบัน API ยังไม่มีรูปผู้เขียน จึงใส่ default ว่างไว้
      authorImageUrl: '',
    );
  }

  /// หากรูปข่าวไม่มี จะใช้ลิงก์ default
  String get imageUrl =>
      urlToImage.isNotEmpty
          ? urlToImage
          : 'https://example.com/default-image.png';

  /// แปลงวันที่เป็น DateTime สำหรับใช้กับ timeago หรืออื่นๆ
  DateTime? get publishedDateTime {
    try {
      return DateTime.parse(publishedAt);
    } catch (e) {
      return null;
    }
  }
}
