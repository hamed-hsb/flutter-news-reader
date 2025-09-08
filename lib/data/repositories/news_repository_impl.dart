import 'package:dartz/dartz.dart'; // مطمئن شو توی pubspec.yaml اضافه شده
import 'package:flutter_news_clean_arch_full/core/errors/failures.dart';


import '../../domain/entities/article.dart';
import '../../domain/repositories/news_repository.dart';
import '../datasources/news_local_data_source.dart';
import '../datasources/news_remote_data_source.dart';
import '../models/article_model.dart';
import '../models/news_response.dart';

class NewsRepositoryImpl implements NewsRepository {
  final NewsRemoteDataSource remote;
  final NewsLocalDataSource local;

  NewsRepositoryImpl({required this.remote, required this.local});

  String _cacheKey(DateTime from, DateTime to, int page, int pageSize) =>
      'agg:${from.toUtc().toIso8601String()}_${to.toUtc().toIso8601String()}_${page}_$pageSize';

  List<Article> _mapModels(List<ArticleModel> models) {
    return models.map((m) {
      DateTime? dt;
      if (m.publishedAt != null) {
        try {
          dt = DateTime.parse(m.publishedAt!);
        } catch (_) {}
      }
      return Article(
        sourceName: m.source?.name,
        author: m.author,
        title: m.title,
        description: m.description,
        url: m.url,
        urlToImage: m.urlToImage,
        publishedAt: dt,
        content: m.content,
        queryTag: m.queryTag,
      );
    }).toList();
  }

  List<ArticleModel> _interleave(
      List<ArticleModel> m,
      List<ArticleModel> a,
      List<ArticleModel> g,
      List<ArticleModel> t,
      ) {
    final maxLen = [m.length, a.length, g.length, t.length].reduce((x, y) => x > y ? x : y);
    final result = <ArticleModel>[];
    for (var i = 0; i < maxLen; i++) {
      if (i < m.length) result.add(m[i]..queryTag = 'Microsoft');
      if (i < a.length) result.add(a[i]..queryTag = 'Apple');
      if (i < g.length) result.add(g[i]..queryTag = 'Google');
      if (i < t.length) result.add(t[i]..queryTag = 'Tesla');
    }
    return result;
  }

  @override
  Future<Either<Failure, List<Article>>> getAggregatedNewsHeadlines({
    required DateTime from,
    required DateTime to,
    required int page,
    required int pageSize,
  }) async {
    await local.init();
    final cacheKey = _cacheKey(from, to, page, pageSize);

    try {
      Future<NewsResponse> fetchQ(String q) => remote.getEverything(
        query: q,
        from: from,
        to: to,
        page: page,
        pageSize: pageSize,
      );

      final m = await fetchQ('microsoft');
      final a = await fetchQ('apple');
      final g = await fetchQ('google');
      final t = await fetchQ('tesla');

      final interleaved = _interleave(
        m.articles ?? [],
        a.articles ?? [],
        g.articles ?? [],
        t.articles ?? [],
      );

      final cacheJson = {
        'articles': interleaved.map((e) => e.toJson()..['queryTag'] = e.queryTag).toList(),
      };
      await local.cacheAggregatedPage(cacheKey, cacheJson);

      return Right(_mapModels(interleaved));
    } on Exception catch (e) {
      // تلاش برای بازیابی از کش
      final cached = await local.getAggregatedPage(cacheKey);
      if (cached != null) {
        final list = (cached['articles'] as List<dynamic>).cast<Map<String, dynamic>>();
        final models = list.map((j) {
          final m = ArticleModel.fromJson(j);
          if (j.containsKey('queryTag')) {
            m.queryTag = j['queryTag'] as String?;
          }
          return m;
        }).toList();
        return Right(_mapModels(models));
      }
      return Left(ServerFailure(e.toString()));
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }
}
