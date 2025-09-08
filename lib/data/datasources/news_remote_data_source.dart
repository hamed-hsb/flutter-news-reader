
import '../../core/config/config.dart';
import '../../core/utils/date_utils.dart';
import '../models/news_response.dart';
import '../network/news_api_client.dart';

abstract class NewsRemoteDataSource {
  Future<NewsResponse> getEverything({
    required String query,
    required DateTime from,
    required DateTime to,
    required int page,
    required int pageSize,
  });
}

class NewsRemoteDataSourceImpl implements NewsRemoteDataSource {
  final NewsApiClient _client;

  NewsRemoteDataSourceImpl(this._client);

  @override
  Future<NewsResponse> getEverything({
    required String query,
    required DateTime from,
    required DateTime to,
    required int page,
    required int pageSize,
  }) {
    return _client.fetchEverything(
      query,
      DateUtilsX.toIso(from),
      DateUtilsX.toIso(to),
      "publishedAt",
      "en",
      page,
      pageSize,
      AppConfig.newsApiKey,
      "title,description",
    );
  }
}

