import 'package:dartz/dartz.dart';

import 'package:flutter_news_clean_arch_full/core/errors/failures.dart';
import 'package:flutter_news_clean_arch_full/data/datasources/news_local_data_source.dart';
import 'package:flutter_news_clean_arch_full/data/datasources/news_remote_data_source.dart';
import 'package:flutter_news_clean_arch_full/data/models/article_model.dart';
import 'package:flutter_news_clean_arch_full/data/models/news_response.dart';
import 'package:flutter_news_clean_arch_full/data/repositories/news_repository_impl.dart';
import 'package:flutter_news_clean_arch_full/domain/entities/article.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

// Mocks
class MockRemoteDataSource extends Mock implements NewsRemoteDataSource {}
class MockLocalDataSource extends Mock implements NewsLocalDataSource {}

void main() {
  late MockRemoteDataSource mockRemote;
  late MockLocalDataSource mockLocal;
  late NewsRepositoryImpl repository;

  setUp(() {
    mockRemote = MockRemoteDataSource();
    mockLocal = MockLocalDataSource();
    repository = NewsRepositoryImpl(remote: mockRemote, local: mockLocal);
  });

  final tFrom = DateTime.parse('2025-09-01');
  final tTo = DateTime.parse('2025-09-02');
  final tPage = 1;
  final tPageSize = 5;

  final tArticleModel = ArticleModel(
    source: null,
    author: 'Test Author',
    title: 'Test Title',
    description: 'Test Description',
    url: 'https://newsapi.org',
    urlToImage: 'https://s0.wp.com/_si/?t=eyJpbWciOiJodHRwczpcL1wvczAud3AuY29tXC9pXC9ibGFuay5qcGciLCJ0eHQiOiJSZXNlYXJjaEJ1enoiLCJ0ZW1wbGF0ZSI6ImhpZ2h3YXkiLCJmb250IjoiIiwiYmxvZ19pZCI6NDMyODc1Nn0.BjdcPIDlw4ZG0Ki13B-quwxnrzAxn9iB5rJXagRMNlcMQ',
    publishedAt: '2025-09-01',
    content: 'Test Content',
    queryTag: null,
  );

  final tNewsResponse = NewsResponse(articles: [tArticleModel]);

  test('should fetch news from remote and cache it', () async {
    // Arrange
    when(() => mockLocal.init()).thenAnswer((_) async {});
    when(() => mockRemote.getEverything(
      query: any(named: 'query'),
      from: tFrom,
      to: tTo,
      page: tPage,
      pageSize: tPageSize,
    )).thenAnswer((_) async => tNewsResponse);
    when(() => mockLocal.cacheAggregatedPage(any(), any()))
        .thenAnswer((_) async {});

    // Act
    final result = await repository.getAggregatedNewsHeadlines(
      from: tFrom,
      to: tTo,
      page: tPage,
      pageSize: tPageSize,
    );

    // Assert
    expect(result.isRight(), true);
    result.fold(
          (_) => fail('Expected Right, got Failure'),
          (articles) {
        expect(articles, isA<List<Article>>());
        expect(articles.length, 4);
      },
    );
    verify(() => mockLocal.cacheAggregatedPage(any(), any())).called(1);
    verify(() => mockRemote.getEverything(
      query: 'microsoft',
      from: tFrom,
      to: tTo,
      page: tPage,
      pageSize: tPageSize,
    )).called(1);
  });

  test('should return cached data when remote fails', () async {
    final cacheKey =
        'agg:${tFrom.toUtc().toIso8601String()}_${tTo.toUtc().toIso8601String()}_${tPage}_$tPageSize';

    // Arrange
    when(() => mockLocal.init()).thenAnswer((_) async {});
    when(() => mockRemote.getEverything(
      query: any(named: 'query'),
      from: tFrom,
      to: tTo,
      page: tPage,
      pageSize: tPageSize,
    )).thenThrow(Exception('Network error'));

    when(() => mockLocal.getAggregatedPage(cacheKey)).thenAnswer((_) async => {
      'articles': [tArticleModel.toJson()..['queryTag'] = 'Microsoft'],
    });

    // Act
    final result = await repository.getAggregatedNewsHeadlines(
      from: tFrom,
      to: tTo,
      page: tPage,
      pageSize: tPageSize,
    );

    // Assert
    expect(result.isRight(), true);
    result.fold(
          (_) => fail('Expected Right, got Failure'),
          (articles) {
        expect(articles, isA<List<Article>>());
        expect(articles.first.queryTag, 'Microsoft');
      },
    );
    verify(() => mockLocal.getAggregatedPage(cacheKey)).called(1);
  });

  test('should return Failure when no cache available and remote fails', () async {
    final cacheKey =
        'agg:${tFrom.toUtc().toIso8601String()}_${tTo.toUtc().toIso8601String()}_${tPage}_$tPageSize';

    // Arrange
    when(() => mockLocal.init()).thenAnswer((_) async {});
    when(() => mockRemote.getEverything(
      query: any(named: 'query'),
      from: tFrom,
      to: tTo,
      page: tPage,
      pageSize: tPageSize,
    )).thenThrow(Exception('Network error'));

    when(() => mockLocal.getAggregatedPage(cacheKey))
        .thenAnswer((_) async => null);

    // Act
    final result = await repository.getAggregatedNewsHeadlines(
      from: tFrom,
      to: tTo,
      page: tPage,
      pageSize: tPageSize,
    );

    // Assert
    expect(result.isLeft(), true);
    result.fold(
          (failure) {
        expect(failure, isA<Failure>());
        expect(failure.message, contains('Network error'));
      },
          (_) => fail('Expected Left, got Articles'),
    );
  });
}
