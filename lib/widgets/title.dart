import 'package:flutter/material.dart';
import 'package:news24/models/news_model.dart';

class NewsTile extends StatelessWidget {
  final News news;

  const NewsTile({super.key, required this.news});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
      elevation: 0,
      child: ListTile(
        leading:
            news.urlToImage.isNotEmpty
                ? ClipRRect(
                  borderRadius: BorderRadius.circular(0),
                  child: Image.network(
                    news.urlToImage,
                    width: 100,
                    height: 80,
                    fit: BoxFit.cover,
                    errorBuilder:
                        (context, error, stackTrace) =>
                            const Icon(Icons.broken_image),
                  ),
                )
                : const Icon(Icons.image_not_supported),
        title: Text(
          news.title,
          maxLines: 5,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(
              news.category.isNotEmpty ? news.category : 'ไม่ระบุหมวดหมู่',
              style: const TextStyle(fontSize: 12, color: Colors.blueAccent),
            ),
            Text(
              news.author.isNotEmpty ? news.author : 'ไม่ระบุผู้เขียน',
              style: const TextStyle(fontSize: 12, color: Colors.black87),
            ),
            Text(
              news.publishedAt,
              style: const TextStyle(fontSize: 12, color: Colors.black54),
            ),
          ],
        ),
      ),
    );
  }
}
