import 'package:dartz/dartz.dart';
import 'package:flutter_news_clean_arch_full/core/errors/failures.dart';
import 'package:flutter_news_clean_arch_full/domain/entities/article.dart';
import 'package:flutter_news_clean_arch_full/domain/repositories/news_repository.dart';
import 'package:flutter_news_clean_arch_full/domain/usecases/get_aggregated_news_headlines_usecase.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

// Mock Repository
class MockNewsRepository extends Mock implements NewsRepository {}

void main() {
  late MockNewsRepository mockRepo;
  late GetAggregatedNewsHeadlinesUseCase useCase;

  setUp(() {
    mockRepo = MockNewsRepository();
    useCase = GetAggregatedNewsHeadlinesUseCase(mockRepo);
  });

  final tFrom = DateTime.parse('2025-09-01T00:00:00Z');
  final tTo = DateTime.parse('2025-09-02T00:00:00Z');
  const tPage = 1;
  const tPageSize = 5;

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

  test('should forward call to repository and return Right(articles)', () async {
    // Arrange
    when(() => mockRepo.getAggregatedNewsHeadlines(
      from: tFrom,
      to: tTo,
      page: tPage,
      pageSize: tPageSize,
    )).thenAnswer((_) async => Right(tArticles));

    // Act
    final result = await useCase(
      from: tFrom,
      to: tTo,
      page: tPage,
      pageSize: tPageSize,
    );

    // Assert
    expect(result.isRight(), true);
    result.fold(
          (_) => fail('Expected Right, got Failure'),
          (articles) => expect(articles, equals(tArticles)),
    );

    verify(() => mockRepo.getAggregatedNewsHeadlines(
      from: tFrom,
      to: tTo,
      page: tPage,
      pageSize: tPageSize,
    )).called(1);
    verifyNoMoreInteractions(mockRepo);
  });

  test('should return Left(Failure) when repository fails', () async {
    // Arrange
    when(() => mockRepo.getAggregatedNewsHeadlines(
      from: tFrom,
      to: tTo,
      page: tPage,
      pageSize: tPageSize,
    )).thenAnswer((_) async => Left(ServerFailure('Error occurred')));

    // Act
    final result = await useCase(
      from: tFrom,
      to: tTo,
      page: tPage,
      pageSize: tPageSize,
    );

    // Assert
    expect(result.isLeft(), true);
    result.fold(
          (failure) {
        expect(failure, isA<ServerFailure>());
        expect(failure.message, contains('Error'));
      },
          (_) => fail('Expected Left, got Articles'),
    );

    verify(() => mockRepo.getAggregatedNewsHeadlines(
      from: tFrom,
      to: tTo,
      page: tPage,
      pageSize: tPageSize,
    )).called(1);
    verifyNoMoreInteractions(mockRepo);
  });
}
