import 'package:dio/dio.dart';
import 'package:news24/models/news_model.dart';

class NewsApiService {
  final Dio _dio = Dio();
  final String _apiKey = '91168506603a49e9bb9254220fda1486';

  Future<List<News>> fetchnews({
    String country = 'Us',
    String category = 'technology',
    int page = 1,
    int pageSize = 5,
  }) async {
    final response = await _dio.get(
      'https://newsapi.org/v2/top-headlines',
      queryParameters: {
        'country': country,
        'category': category,
        'page': page,
        'pageSize': pageSize,
        'apiKey': _apiKey,
      },
    );

    if (response.statusCode == 200) {
      final articles = response.data['articles'] as List;
      return articles.map((json) {
        final news = News.fromJson(json);
        return News(
          title: news.title,
          author: news.author,
          description: news.description,
          urlToImage: news.urlToImage,
          publishedAt: news.publishedAt,
          category: category,
        );
      }).toList();
    } else {
      throw Exception('Failed to load top headlines');
    }
  }

  Future<List<News>> searchNews({
    required String query,
    int page = 1,
    int pageSize = 5,
  }) async {
    final response = await _dio.get(
      'https://newsapi.org/v2/everything',
      queryParameters: {
        'q': query,
        'sortBy': 'publishedAt',
        'language': 'en',
        'page': page,
        'pageSize': pageSize,
        'apiKey': _apiKey,
      },
    );

    if (response.statusCode == 200) {
      final articles = response.data['articles'] as List;
      return articles.map((json) {
        final news = News.fromJson(json);
        return News(
          title: news.title,
          author: news.author,
          description: news.description,
          urlToImage: news.urlToImage,
          publishedAt: news.publishedAt,
          category: 'search',
        );
      }).toList();
    } else {
      throw Exception('Failed to search news');
    }
  }
}
