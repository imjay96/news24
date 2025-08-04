import 'package:flutter/material.dart';
import 'package:news24/models/news_model.dart';
import 'package:news24/screen/news.dart';
import 'package:news24/services/news_api_service.dart';
import 'package:news24/widgets/title.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final NewsApiService _apiService = NewsApiService();
  final TextEditingController _searchController = TextEditingController();
  final RefreshController _refreshController = RefreshController();

  List<News> _searchResults = [];
  bool _isLoading = false;
  int _currentPage = 1;
  final int _pageSize = 10;
  bool _hasMore = true;

  Future<void> _searchNews({bool isRefresh = false}) async {
    final query = _searchController.text.trim();
    if (query.isEmpty) return;

    if (_isLoading) return;
    setState(() => _isLoading = true);

    if (isRefresh) {
      _currentPage = 1;
      _hasMore = true;
      _searchResults.clear();
    }

    try {
      final results = await _apiService.searchNews(
        query: query,
        page: _currentPage,
        pageSize: _pageSize,
      );

      setState(() {
        if (isRefresh) {
          _searchResults = results;
        } else {
          _searchResults.addAll(results);
        }
        _hasMore = results.length == _pageSize;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('ค้นหาไม่สำเร็จ: $e')),
      );
    }

    setState(() => _isLoading = false);
    if (isRefresh) {
      _refreshController.refreshCompleted();
    } else {
      if (_hasMore) {
        _refreshController.loadComplete();
      } else {
        _refreshController.loadNoData();
      }
    }
  }

  void _onRefresh() async {
    await _searchNews(isRefresh: true);
  }

  void _onLoading() async {
    if (_hasMore) {
      _currentPage++;
      await _searchNews();
    } else {
      _refreshController.loadNoData();
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    _refreshController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ค้นหาข่าว'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextField(
              controller: _searchController,
              onSubmitted: (_) => _searchNews(isRefresh: true),
              decoration: InputDecoration(
                hintText: 'พิมพ์คำค้นหา...',
                suffixIcon: IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: () => _searchNews(isRefresh: true),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
          Expanded(
            child: SmartRefresher(
              controller: _refreshController,
              enablePullDown: true,
              enablePullUp: true,
              onRefresh: _onRefresh,
              onLoading: _onLoading,
              child: _isLoading && _searchResults.isEmpty
                  ? const Center(child: CircularProgressIndicator())
                  : _searchResults.isEmpty
                      ? const Center(child: Text('ยังไม่มีผลลัพธ์'))
                      : ListView.builder(
                          itemCount: _searchResults.length,
                          itemBuilder: (context, index) {
                            final news = _searchResults[index];
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
            ),
          ),
        ],
      ),
    );
  }
}
