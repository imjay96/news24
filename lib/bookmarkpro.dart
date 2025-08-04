import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:news24/models/news_model.dart';

final bookmarkProvider = StateNotifierProvider<BookmarkNotifier, List<News>>((
  ref,
) {
  return BookmarkNotifier();
});

class BookmarkNotifier extends StateNotifier<List<News>> {
  BookmarkNotifier() : super([]);

  void addBookmark(News news) {
    if (!state.contains(news)) {
      state = [...state, news];
    }
  }

  void removeBookmark(News news) {
    state = state.where((item) => item != news).toList();
  }

  bool isBookmarked(News news) {
    return state.contains(news);
  }

  void toggleBookmark(News news) {
    if (isBookmarked(news)) {
      removeBookmark(news);
    } else {
      addBookmark(news);
    }
  }
}
