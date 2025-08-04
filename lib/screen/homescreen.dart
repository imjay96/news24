import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:news24/models/news_model.dart';
import 'package:news24/screen/news.dart';
import 'package:news24/screen/search.dart';
import 'package:news24/screen/bookmark.dart';
import 'package:news24/services/news_api_service.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:news24/bookmarkpro.dart';
import 'package:timeago/timeago.dart' as timeago;

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final NewsApiService _apiService = NewsApiService();

  final List<String> _categories = [
    'For You',
    'Top',
    'World',
    'Politics',
    'Technology',
    'Sports',
    'Health',
  ];

  int _selectedCategoryIndex = 0;
  int _currentPage = 1;
  final int _pageSize = 5;

  bool _isLoading = false;
  bool _hasMore = true;

  List<News> _newsList = [];

  final RefreshController _refreshController = RefreshController();

  int _tabIndex = 0;

  final List<Widget> _tabs = const [SearchScreen(), BookmarkScreen()];

  @override
  void initState() {
    super.initState();

    timeago.setLocaleMessages('us', timeago.ThMessages());

    _fetchInitialNews();
  }

  Future<void> _fetchInitialNews() async {
    _currentPage = 1;
    _hasMore = true;
    _newsList.clear();
    await _fetchNews(isRefresh: true);
  }

  Future<void> _fetchNews({bool isRefresh = false}) async {
    if (_isLoading) return;
    setState(() => _isLoading = true);

    final categoryLabel = _categories[_selectedCategoryIndex];
    final Map<String, String> categoryMap = {
      'For You': 'general',
      'Top': 'general',
      'World': 'general',
      'Politics': 'general',
      'Technology': 'technology',
      'Sports': 'sports',
      'Health': 'health',
    };
    final category = categoryMap[categoryLabel] ?? 'general';

    try {
      final news = await _apiService.fetchnews(
        category: category,
        page: _currentPage,
        pageSize: _pageSize,
      );
      setState(() {
        if (isRefresh) {
          _newsList = news;
        } else {
          _newsList.addAll(news);
        }
        _hasMore = news.length == _pageSize;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('เกิดข้อผิดพลาดในการโหลดข่าว: $e')),
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
    _currentPage = 1;
    await _fetchNews(isRefresh: true);
  }

  void _onLoading() async {
    if (_hasMore && !_isLoading) {
      _currentPage++;
      await _fetchNews();
    } else {
      _refreshController.loadNoData();
    }
  }

  @override
  void dispose() {
    _refreshController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        centerTitle: true,
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: const [
            Icon(Icons.newspaper, color: Color.fromARGB(255, 0, 0, 0)),
            SizedBox(width: 8),
            Text(
              'News24',
              style: TextStyle(
                color: Color.fromARGB(255, 0, 0, 0),
                fontWeight: FontWeight.bold,
                letterSpacing: 1.2,
                fontSize: 20,
              ),
            ),
          ],
        ),
      ),
      body:
          _tabIndex == 0
              ? Column(
                children: [
                  _buildCategoryTabs(),
                  Expanded(child: _buildNewsList()),
                ],
              )
              : _tabs[_tabIndex - 1], // Search or Bookmark screens
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _tabIndex,
        onTap: (index) {
          setState(() {
            _tabIndex = index;
            if (_tabIndex == 0) {
              _fetchInitialNews();
            }
          });
        },
        selectedItemColor: const Color.fromARGB(255, 0, 0, 0),
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
          BottomNavigationBarItem(
            icon: Icon(Icons.bookmark),
            label: 'Bookmark',
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryTabs() {
    return SizedBox(
      height: 40,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: _categories.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final isSelected = _selectedCategoryIndex == index;
          return GestureDetector(
            onTap: () {
              setState(() => _selectedCategoryIndex = index);
              _fetchInitialNews();
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color:
                    isSelected
                        ? const Color.fromARGB(255, 0, 0, 0)
                        : const Color.fromARGB(255, 139, 135, 135),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.white),
              ),
              child: Text(
                _categories[index],
                style: TextStyle(
                  color:
                      isSelected
                          ? const Color.fromARGB(255, 161, 161, 161)
                          : const Color.fromARGB(255, 255, 255, 255),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildNewsList() {
    final bookmarkNotifier = ref.watch(bookmarkProvider.notifier);
    final bookmarked = ref.watch(bookmarkProvider);

    return SmartRefresher(
      controller: _refreshController,
      enablePullDown: true,
      enablePullUp: true,
      onRefresh: _onRefresh,
      onLoading: _onLoading,
      child: ListView.separated(
        padding: const EdgeInsets.all(8),
        itemCount: _newsList.length,
        separatorBuilder: (_, __) => const Divider(color: Colors.white54),
        itemBuilder: (context, index) {
          final news = _newsList[index];
          final isBookmarked = bookmarked.contains(news);

          final Map<String, String> categoryMap = {
            'general': 'General',
            'technology': 'Technology',
            'sports': 'Sports',
            'health': 'Health',
          };

          final categoryLabel =
              categoryMap[news.category?.toLowerCase() ?? ''] ?? '-';

          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => newscreen(news: news)),
              );
            },
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              color: const Color.fromARGB(255, 255, 255, 255),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: SizedBox(
                      width: 120,
                      height: 120,
                      child: Image.network(
                        news.imageUrl,
                        fit: BoxFit.cover,
                        errorBuilder:
                            (context, error, stackTrace) => const Icon(
                              Icons.broken_image,
                              size: 60,
                              color: Color.fromARGB(137, 0, 0, 0),
                            ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // ชื่อข่าว
                        Text(
                          news.title,
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                            color: Color.fromARGB(255, 0, 0, 0),
                          ),
                        ),
                        const SizedBox(height: 8),
                        // ชื่อผู้เขียน
                        Text(
                          'By ${news.author?.isNotEmpty == true ? news.author : '-'}',
                          style: const TextStyle(
                            fontStyle: FontStyle.italic,
                            color: Color.fromARGB(179, 0, 0, 0),
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 8),
                        // หมวดหมู่ + เวลาแยกชิดขวา
                        Row(
                          children: [
                            Text(
                              categoryLabel,
                              style: const TextStyle(
                                fontSize: 14,
                                color: Color.fromARGB(137, 0, 0, 0),
                              ),
                            ),
                            const Spacer(),
                            Text(
                              news.publishedDateTime != null
                                  ? timeago.format(
                                    news.publishedDateTime!,
                                    locale: 'Us',
                                  ) // <-- กำหนด locale 'th' หรือเปลี่ยนเป็น 'en' ได้
                                  : 'ไม่ทราบเวลา',
                              style: const TextStyle(
                                fontSize: 14,
                                color: Color.fromARGB(137, 0, 0, 0),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  PopupMenuButton<String>(
                    icon: const Text(
                      '...',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(137, 0, 0, 0),
                      ),
                    ),
                    onSelected: (value) {
                      if (value == 'bookmark') {
                        bookmarkNotifier.toggleBookmark(news);
                      }
                      if (value == 'share') {}
                    },
                    itemBuilder:
                        (context) => [
                          PopupMenuItem(
                            value: 'bookmark',
                            child: Text(
                              isBookmarked ? 'Remove Bookmark' : 'Add Bookmark',
                            ),
                          ),
                          const PopupMenuItem(
                            value: 'share',
                            child: Text('Share'),
                          ),
                        ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
