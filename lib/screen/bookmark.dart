import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:news24/screen/news.dart';
import 'package:news24/widgets/title.dart';
import 'package:news24/bookmarkpro.dart';

class BookmarkScreen extends ConsumerWidget {
  const BookmarkScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bookmarkedNews = ref.watch(bookmarkProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('บุ๊คมาร์ค'), centerTitle: true),
      body:
          bookmarkedNews.isEmpty
              ? const Center(child: Text('ยังไม่มีข่าวที่บันทึกไว้'))
              : ListView.builder(
                itemCount: bookmarkedNews.length,
                itemBuilder: (context, index) {
                  final news = bookmarkedNews[index];
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => newscreen(news: news),
                        ),
                      );
                    },
                    child: NewsTile(news: news),
                  );
                },
              ),
    );
  }
}
