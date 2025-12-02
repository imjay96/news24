import 'package:dio/dio.dart';
import 'package:news24/models/news_model.dart';

class NewsApiService {
  final Dio _dio = Dio(BaseOptions(baseUrl: 'https://newsapi.org/v2'));
  final String _apiKey = '5544c70b151c467fbcc61edc8459ae9f';

  // Categories ที่ API รองรับ
  static const List<String> validCategories = [
    'business',
    'entertainment',
    'general',
    'health',
    'science',
    'sports',
    'technology',
  ];

  // สำหรับ category ตาม API
  Future<List<News>> fetchNews({
    String country = 'us',
    String category = 'general',
    int page = 1,
    int pageSize = 20,
  }) async {
    if (!validCategories.contains(category)) {
      print('Category "$category" not valid. Using "general" instead.');
      category = 'general';
    }

    try {
      final response = await _dio.get(
        '/top-headlines',
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
        return articles
            .map((json) => News.fromJson(json, category: category))
            .toList();
      } else {
        throw Exception(
          'Failed to load top headlines, status: ${response.statusCode}',
        );
      }
    } on DioException catch (dioError) {
      print('Dio error in fetchNews: ${dioError.message}');
      rethrow;
    } catch (e) {
      print('Unexpected error in fetchNews: $e');
      rethrow;
    }
  }

  // สำหรับ "For You" / รวมหลายหมวด
  Future<List<News>> fetchForYou({
    String query = 'general OR trending OR latest',
    int page = 1,
    int pageSize = 50,
  }) async {
    try {
      final response = await _dio.get(
        '/everything',
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
        return articles.map((json) => News.fromJson(json)).toList();
      } else {
        throw Exception(
          'Failed to fetch For You news, status: ${response.statusCode}',
        );
      }
    } on DioException catch (dioError) {
      print('Dio error in fetchForYou: ${dioError.message}');
      rethrow;
    } catch (e) {
      print('Unexpected error in fetchForYou: $e');
      rethrow;
    }
  }

  // สำหรับ search keyword เฉพาะ
  Future<List<News>> searchNews({
    required String query,
    int page = 1,
    int pageSize = 50,
  }) async {
    try {
      final response = await _dio.get(
        '/everything',
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
        return articles.map((json) => News.fromJson(json)).toList();
      } else {
        throw Exception(
          'Failed to search news, status: ${response.statusCode}',
        );
      }
    } on DioException catch (dioError) {
      print('Dio error in searchNews: ${dioError.message}');
      rethrow;
    } catch (e) {
      print('Unexpected error in searchNews: $e');
      rethrow;
    }
  }
}
