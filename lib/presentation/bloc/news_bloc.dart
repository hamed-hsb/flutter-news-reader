import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dartz/dartz.dart';


import '../../domain/entities/article.dart';
import '../../domain/usecases/get_aggregated_news_headlines_usecase.dart';

part 'news_event.dart';
part 'news_state.dart';

class NewsBloc extends Bloc<NewsEvent, NewsState> {
  final GetAggregatedNewsHeadlinesUseCase _get;

  int _page = 1;
  static const _pageSize = 20;

  NewsBloc(this._get) : super(const NewsState.initial()) {
    on<LoadNews>(_onLoad);
    on<LoadMoreNews>(_onMore);
    on<RefreshNews>(_onRefresh);
  }

  Future<void> _onLoad(LoadNews e, Emitter<NewsState> emit) async {
    emit(state.copyWith(status: NewsStatus.loading, error: null));

    final now = DateTime.now();
    final from = now.subtract(const Duration(days: 1));

    final nowDateOnly = DateTime(now.year, now.month, now.day);
    final fromDateOnly = DateTime(from.year, from.month, from.day);

    final result = await _get(
      from: fromDateOnly,
      to: nowDateOnly,
      page: _page,
      pageSize: _pageSize,
    );

    result.fold(
          (failure) => emit(
        state.copyWith(status: NewsStatus.failure, error: failure.message),
      ),
          (articles) => emit(
        state.copyWith(
          status: NewsStatus.success,
          articles: articles,
          hasMore: articles.length >= _pageSize,
        ),
      ),
    );
  }

  Future<void> _onMore(LoadMoreNews e, Emitter<NewsState> emit) async {
    if (state.status == NewsStatus.loadingMore) return;

    emit(state.copyWith(status: NewsStatus.loadingMore));
    _page += 1;

    final now = DateTime.now();
    final from = now.subtract(const Duration(days: 1));

    final result = await _get(
      from: from,
      to: now,
      page: _page,
      pageSize: _pageSize,
    );

    result.fold(
          (failure) => emit(
        state.copyWith(status: NewsStatus.failure, error: failure.message),
      ),
          (articles) {
        final combined = List<Article>.from(state.articles)..addAll(articles);
        emit(
          state.copyWith(
            status: NewsStatus.success,
            articles: combined,
            hasMore: articles.length >= _pageSize,
          ),
        );
      },
    );
  }

  Future<void> _onRefresh(RefreshNews e, Emitter<NewsState> emit) async {
    _page = 1;
    add(LoadNews());
  }
}
