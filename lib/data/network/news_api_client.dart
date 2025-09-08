import 'package:retrofit/retrofit.dart';
import 'package:dio/dio.dart';
import '../models/news_response.dart';

part 'news_api_client.g.dart';

@RestApi(baseUrl: "https://newsapi.org/v2")
abstract class NewsApiClient {
  factory NewsApiClient(Dio dio, {String baseUrl}) = _NewsApiClient;

  @GET("/everything")
  Future<NewsResponse> fetchEverything(
    @Query("q") String query,
    @Query("from") String fromIso,
    @Query("to") String toIso,
    @Query("sortBy") String sortBy,
    @Query("language") String language,
    @Query("page") int page,
    @Query("pageSize") int pageSize,
    @Query("apiKey") String apiKey,
    @Query("searchIn") String? searchIn,
  );
}

