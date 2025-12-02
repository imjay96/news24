import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:news24/models/news_model.dart';
import 'package:news24/bookmarkpro.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:share_plus/share_plus.dart';

class newscreen extends ConsumerWidget {
  final News news;

  const newscreen({super.key, required this.news});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bookmarkedList = ref.watch(bookmarkProvider);
    final isBookmarked = bookmarkedList.contains(news);

    void toggleBookmark() {
      ref.read(bookmarkProvider.notifier).toggleBookmark(news);

      final message = isBookmarked ? 'Bookmark deleted' : 'Bookmark added';

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(message)));
    }

    DateTime? publishedDateTime;
    try {
      publishedDateTime = DateTime.parse(news.publishedAt);
    } catch (_) {
      publishedDateTime = null;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          news.title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(fontSize: 16),
        ),
        actions: [
          IconButton(
            icon: Icon(isBookmarked ? Icons.bookmark : Icons.bookmark_border),
            onPressed: toggleBookmark,
            tooltip: isBookmarked ? 'Bookmark deleted' : 'Bookmark added',
          ),
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () {
              final shareText =
                  '${news.title}\n\nอ่านต่อที่: ${news.urlToImage.isNotEmpty ? news.urlToImage : ''}';
              Share.share(shareText);
            },
            tooltip: 'Share',
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (news.urlToImage.isNotEmpty)
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  news.urlToImage,
                  errorBuilder:
                      (context, error, stackTrace) => Container(
                        height: 200,
                        color: Colors.grey[300],
                        child: const Icon(Icons.broken_image, size: 60),
                      ),
                ),
              ),
            const SizedBox(height: 16),
            Text(
              news.title,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: 14,
                      backgroundImage:
                          news.authorImageUrl.isNotEmpty
                              ? NetworkImage(news.authorImageUrl)
                              : null,
                      child:
                          news.authorImageUrl.isEmpty
                              ? const Icon(Icons.person, size: 16)
                              : null,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'by ${news.author.isNotEmpty ? news.author : "Unknown"}',
                      style: const TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    publishedDateTime != null
                        ? timeago.format(publishedDateTime, locale: 'en')
                        : 'Unknown Time',
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(news.description, style: const TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }
}
