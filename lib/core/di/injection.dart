import 'package:get_it/get_it.dart';
import 'package:dio/dio.dart';

import '../network/dio_client.dart';
import '../../data/network/news_api_client.dart';
import '../../data/datasources/news_remote_data_source.dart';
import '../../data/datasources/news_local_data_source.dart';
import '../../data/repositories/news_repository_impl.dart';
import '../../domain/repositories/news_repository.dart';
import '../../domain/usecases/get_aggregated_news_headlines_usecase.dart';

final sl = GetIt.instance;

Future<void> initDI() async {
  // External
  sl.registerLazySingleton<Dio>(() => buildDio());

  // Data layer
  sl.registerLazySingleton<NewsApiClient>(() => NewsApiClient(sl<Dio>()));
  sl.registerLazySingleton<NewsRemoteDataSource>(() => NewsRemoteDataSourceImpl(sl<NewsApiClient>()));
  sl.registerLazySingleton<NewsLocalDataSource>(() => NewsLocalDataSourceImpl());

  // Repository
  sl.registerLazySingleton<NewsRepository>(
      () => NewsRepositoryImpl(remote: sl(), local: sl()));

  // UseCases
  sl.registerLazySingleton<GetAggregatedNewsHeadlinesUseCase>(() => GetAggregatedNewsHeadlinesUseCase(sl()));
}

