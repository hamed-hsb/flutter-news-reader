part of 'news_bloc.dart';

enum NewsStatus { initial, loading, success, failure, loadingMore }

class NewsState extends Equatable {
  final NewsStatus status;
  final List<Article> articles;
  final String? error;
  final bool hasMore;

  const NewsState({
    required this.status,
    required this.articles,
    required this.hasMore,
    this.error,
  });

  const NewsState.initial()
      : status = NewsStatus.initial,
        articles = const [],
        hasMore = true,
        error = null;

  NewsState copyWith({
    NewsStatus? status,
    List<Article>? articles,
    String? error,
    bool? hasMore,
  }) {
    return NewsState(
      status: status ?? this.status,
      articles: articles ?? this.articles,
      error: error,
      hasMore: hasMore ?? this.hasMore,
    );
  }

  @override
  List<Object?> get props => [status, articles, error, hasMore];
}

