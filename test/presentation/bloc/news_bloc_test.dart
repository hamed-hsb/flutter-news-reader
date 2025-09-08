import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';

import 'package:flutter_news_clean_arch_full/core/errors/failures.dart';
import 'package:flutter_news_clean_arch_full/domain/entities/article.dart';
import 'package:flutter_news_clean_arch_full/domain/usecases/get_aggregated_news_headlines_usecase.dart';
import 'package:flutter_news_clean_arch_full/presentation/bloc/news_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

// Mock UseCase
class MockGetAggregatedNewsHeadlinesUseCase extends Mock
    implements GetAggregatedNewsHeadlinesUseCase {}

void main() {
  late MockGetAggregatedNewsHeadlinesUseCase mockUseCase;
  late NewsBloc bloc;

  setUp(() {
    mockUseCase = MockGetAggregatedNewsHeadlinesUseCase();
    bloc = NewsBloc(mockUseCase);
  });

  final tArticles = [
    Article(
      sourceName: 'Test Source',
      author: 'Test Author',
      title: 'Test Title',
      description: 'Test Description',
      url: 'https://newsapi.org',
      urlToImage: 'https://s0.wp.com/_si/?t=eyJpbWciOiJodHRwczpcL1wvczAud3AuY29tXC9pXC9ibGFuay5qcGciLCJ0eHQiOiJSZXNlYXJjaEJ1enoiLCJ0ZW1wbGF0ZSI6ImhpZ2h3YXkiLCJmb250IjoiIiwiYmxvZ19pZCI6NDMyODc1Nn0.BjdcPIDlw4ZG0Ki13B-quwxnrzAxn9iB5rJXagRMNlcMQ',
      publishedAt: DateTime.parse('2025-09-01'),
      content: 'Test Content',
      queryTag: 'TestTag',
    ),
  ];

  group('LoadNews', () {
    blocTest<NewsBloc, NewsState>(
      'emits [loading, success] when usecase returns Right(articles)',
      build: () {
        when(() => mockUseCase(
          from: any(named: 'from'),
          to: any(named: 'to'),
          page: any(named: 'page'),
          pageSize: any(named: 'pageSize'),
        )).thenAnswer((_) async => Right(tArticles));
        return bloc;
      },
      act: (bloc) => bloc.add(LoadNews()),
      expect: () => [
        isA<NewsState>().having((s) => s.status, 'status', NewsStatus.loading),
        isA<NewsState>()
            .having((s) => s.status, 'status', NewsStatus.success)
            .having((s) => s.articles, 'articles', tArticles)
            .having((s) => s.hasMore, 'hasMore', false),
      ],
    );

    blocTest<NewsBloc, NewsState>(
      'emits [loading, failure] when usecase returns Left(Failure)',
      build: () {
        when(() => mockUseCase(
          from: any(named: 'from'),
          to: any(named: 'to'),
          page: any(named: 'page'),
          pageSize: any(named: 'pageSize'),
        )).thenAnswer((_) async => Left(ServerFailure('network error')));
        return bloc;
      },
      act: (bloc) => bloc.add(LoadNews()),
      expect: () => [
        isA<NewsState>().having((s) => s.status, 'status', NewsStatus.loading),
        isA<NewsState>()
            .having((s) => s.status, 'status', NewsStatus.failure)
            .having((s) => s.error, 'error', contains('network error')),
      ],
    );
  });

  group('LoadMoreNews', () {
    blocTest<NewsBloc, NewsState>(
      'emits [loadingMore, success] and appends articles when Right',
      build: () {
        when(() => mockUseCase(
          from: any(named: 'from'),
          to: any(named: 'to'),
          page: any(named: 'page'),
          pageSize: any(named: 'pageSize'),
        )).thenAnswer((_) async => Right(tArticles));
        return bloc;
      },
      seed: () => NewsState(
        status: NewsStatus.success,
        articles: tArticles,
        hasMore: true,
      ),
      act: (bloc) => bloc.add(LoadMoreNews()),
      expect: () => [
        isA<NewsState>().having((s) => s.status, 'status', NewsStatus.loadingMore),
        isA<NewsState>()
            .having((s) => s.status, 'status', NewsStatus.success)
            .having((s) => s.articles.length, 'articles length', 2),
      ],
    );

    blocTest<NewsBloc, NewsState>(
      'emits [loadingMore, failure] when usecase returns Left',
      build: () {
        when(() => mockUseCase(
          from: any(named: 'from'),
          to: any(named: 'to'),
          page: any(named: 'page'),
          pageSize: any(named: 'pageSize'),
        )).thenAnswer((_) async => Left(ServerFailure('pagination error')));
        return bloc;
      },
      seed: () => NewsState(
        status: NewsStatus.success,
        articles: tArticles,
        hasMore: true,
      ),
      act: (bloc) => bloc.add(LoadMoreNews()),
      expect: () => [
        isA<NewsState>().having((s) => s.status, 'status', NewsStatus.loadingMore),
        isA<NewsState>()
            .having((s) => s.status, 'status', NewsStatus.failure)
            .having((s) => s.error, 'error', contains('pagination error')),
      ],
    );
  });

  group('RefreshNews', () {
    blocTest<NewsBloc, NewsState>(
      'resets page to 1 and triggers LoadNews with Right',
      build: () {
        when(() => mockUseCase(
          from: any(named: 'from'),
          to: any(named: 'to'),
          page: any(named: 'page'),
          pageSize: any(named: 'pageSize'),
        )).thenAnswer((_) async => Right(tArticles));
        return bloc;
      },
      act: (bloc) => bloc.add(RefreshNews()),
      wait: const Duration(milliseconds: 100),
      expect: () => [
        isA<NewsState>().having((s) => s.status, 'status', NewsStatus.loading),
        isA<NewsState>()
            .having((s) => s.status, 'status', NewsStatus.success)
            .having((s) => s.articles, 'articles', tArticles),
      ],
    );
  });
}
