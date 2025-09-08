
import 'package:flutter_news_clean_arch_full/core/errors/failures.dart';

import '../entities/article.dart';
import '../repositories/news_repository.dart';

import 'package:dartz/dartz.dart';


import '../entities/article.dart';
import '../repositories/news_repository.dart';

class GetAggregatedNewsHeadlinesUseCase {
  final NewsRepository _repo;
  GetAggregatedNewsHeadlinesUseCase(this._repo);

  Future<Either<Failure, List<Article>>> call({
    required DateTime from,
    required DateTime to,
    required int page,
    required int pageSize,
  }) {
    return _repo.getAggregatedNewsHeadlines(
      from: from,
      to: to,
      page: page,
      pageSize: pageSize,
    );
  }
}


