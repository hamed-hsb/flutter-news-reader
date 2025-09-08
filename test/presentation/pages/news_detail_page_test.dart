import 'package:flutter/material.dart';
import 'package:flutter_news_clean_arch_full/domain/entities/article.dart';
import 'package:flutter_news_clean_arch_full/presentation/pages/news_detail_page.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

// platform interface for url_launcher
import 'package:url_launcher_platform_interface/url_launcher_platform_interface.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';


/// Mock برای UrlLauncherPlatform
class _MockUrlLauncher extends Mock
    with MockPlatformInterfaceMixin
    implements UrlLauncherPlatform {}

void main() {
  late _MockUrlLauncher mockLauncher;
  late UrlLauncherPlatform originalPlatform;

  setUpAll(() {

    registerFallbackValue(LaunchOptions(mode: PreferredLaunchMode.externalApplication));
  });

  setUp(() {

    originalPlatform = UrlLauncherPlatform.instance;

    mockLauncher = _MockUrlLauncher();


    UrlLauncherPlatform.instance = mockLauncher;


    when(() => mockLauncher.canLaunch(any())).thenAnswer((_) async => true);

    when(() => mockLauncher.launchUrl(any(), any())).thenAnswer((_) async => true);
  });

  tearDown(() {

    UrlLauncherPlatform.instance = originalPlatform;
    clearInteractions(mockLauncher);
  });

  testWidgets('renders article and calls platform.launchUrl when button tapped', (tester) async {
    final article = Article(
      title: "Test Article",
      description: "Desc",
      content: "Full content",
      url: "https://example.com/page",
      urlToImage: null,
      author: "Author",
      sourceName: "Source",
      publishedAt: DateTime(2025, 9, 8),
      queryTag: "Tag",
    );

    await tester.pumpWidget(
      MaterialApp(
        home: NewsDetailPage(article: article),
      ),
    );


    expect(find.text('Open original'), findsOneWidget);


    await tester.tap(find.text('Open original'));
    await tester.pumpAndSettle();

    verify(() => mockLauncher.launchUrl(article.url  ?? "", any())).called(1);
  });

  testWidgets('does not call launchUrl when canLaunch returns false', (tester) async {
    final article = Article(
      title: "Test Article",
      description: "Desc",
      content: "Full content",
      url: "https://example.com/page",
      urlToImage: null,
      author: "Author",
      sourceName: "Source",
      publishedAt: DateTime(2025, 9, 8),
      queryTag: "Tag",
    );

    when(() => mockLauncher.canLaunch(any())).thenAnswer((_) async => false);

    await tester.pumpWidget(
      MaterialApp(
        home: NewsDetailPage(article: article),
      ),
    );

    await tester.tap(find.text('Open original'));
    await tester.pumpAndSettle();

    verifyNever(() => mockLauncher.launchUrl(any(), any()));
  });
}
