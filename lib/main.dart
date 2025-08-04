import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'screen/homescreen.dart';
import 'screen/news.dart';
import 'screen/bookmark.dart';
import 'models/news_model.dart';

void main() {
  runApp(const ProviderScope(child: News24App()));
}

final _router = GoRouter(
  routes: [
    GoRoute(path: '/', builder: (context, state) => const HomeScreen()),
    GoRoute(
      path: '/detail',
      builder: (context, state) {
        final news = state.extra as News;
        return newscreen(news: news);
      },
    ),
    GoRoute(
      path: '/bookmark',
      builder: (context, state) => const BookmarkScreen(),
    ),
  ],
);

class News24App extends ConsumerWidget {
  const News24App({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp.router(
      title: 'News24',
      debugShowCheckedModeBanner: false,
      routerConfig: _router,
      theme: ThemeData(primarySwatch: Colors.blue),
    );
  }
}
