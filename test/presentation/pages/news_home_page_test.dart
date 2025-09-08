import 'package:flutter/material.dart';
import 'package:flutter_news_clean_arch_full/domain/entities/article.dart';
import 'package:flutter_news_clean_arch_full/presentation/bloc/news_bloc.dart';
import 'package:flutter_news_clean_arch_full/presentation/pages/news_home_page.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mocktail/mocktail.dart';


class MockNewsBloc extends Mock implements NewsBloc {}

void main() {
  late MockNewsBloc mockBloc;

  setUp(() {
    mockBloc = MockNewsBloc();
  });

  Widget makeTestable(Widget child) {
    return MaterialApp(
      home: BlocProvider<NewsBloc>.value(
        value: mockBloc,
        child: child,
      ),
    );
  }

  testWidgets('shows loading indicator when loading and no articles', (tester) async {
    when(() => mockBloc.state).thenReturn(
      const NewsState(status: NewsStatus.loading, articles: [], hasMore: true),
    );

    await tester.pumpWidget(makeTestable(const NewsHomePage()));

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('shows error message when failure and no articles', (tester) async {
    when(() => mockBloc.state).thenReturn(
      const NewsState(status: NewsStatus.failure, articles: [], hasMore: true, error: 'Failed to load'),
    );

    await tester.pumpWidget(makeTestable(const NewsHomePage()));

    expect(find.text('Failed to load'), findsOneWidget);
  });

  testWidgets('shows list of articles when loaded', (tester) async {
    final articles = [
      Article(title: 'Title 1', description: 'Desc 1', url: '', urlToImage: '', publishedAt: DateTime.now()),
      Article(title: 'Title 2', description: 'Desc 2', url: '', urlToImage: '', publishedAt: DateTime.now()),
    ];

    when(() => mockBloc.state).thenReturn(
      NewsState(status: NewsStatus.success, articles: articles, hasMore: true),
    );

    await tester.pumpWidget(makeTestable(const NewsHomePage()));

    expect(find.text('Title 1'), findsOneWidget);
    expect(find.text('Title 2'), findsOneWidget);
  });

  testWidgets('shows loading more indicator at bottom when loadingMore', (tester) async {
    final articles = [
      Article(title: 'Title 1', description: 'Desc 1', url: '', urlToImage: '', publishedAt: DateTime.now()),
    ];

    when(() => mockBloc.state).thenReturn(
      NewsState(status: NewsStatus.loadingMore, articles: articles, hasMore: true),
    );

    await tester.pumpWidget(makeTestable(const NewsHomePage()));

    expect(find.byType(ListView), findsOneWidget);
    expect(find.byType(CircularProgressIndicator), findsWidgets);
  });

}
