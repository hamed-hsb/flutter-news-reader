import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/news_bloc.dart';
import '../widgets/article_list_item.dart';
import 'news_detail_page.dart';

class NewsHomePage extends StatefulWidget {
  const NewsHomePage({super.key});

  @override
  State<NewsHomePage> createState() => _NewsHomePageState();
}

class _NewsHomePageState extends State<NewsHomePage> {
  final _controller = ScrollController();

  @override
  void initState() {
    super.initState();
    context.read<NewsBloc>().add(LoadNews());

    _controller.addListener(() {
      if (_controller.position.pixels > _controller.position.maxScrollExtent - 200) {
        final state = context.read<NewsBloc>().state;
        if (state.hasMore && state.status != NewsStatus.loadingMore) {
          context.read<NewsBloc>().add(LoadMoreNews());
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('News Reader'),
        actions: [
          IconButton(
            onPressed: () => context.read<NewsBloc>().add(RefreshNews()),
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async => context.read<NewsBloc>().add(RefreshNews()),
        child: BlocBuilder<NewsBloc, NewsState>(
          builder: (context, state) {
            if (state.status == NewsStatus.loading && state.articles.isEmpty) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state.status == NewsStatus.failure && state.articles.isEmpty) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Text(state.error ?? 'Error', textAlign: TextAlign.center),
                ),
              );
            }
            return ListView.builder(
              controller: _controller,
              itemCount: state.articles.length + (state.status == NewsStatus.loadingMore ? 1 : 0),
              itemBuilder: (context, index) {
                if (index >= state.articles.length) {
                  return const Padding(
                    padding: EdgeInsets.all(16),
                    child: Center(child: CircularProgressIndicator()),
                  );
                }
                final item = state.articles[index];
                return ArticleListItem(
                  item: item,
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => NewsDetailPage(article: item)),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}

