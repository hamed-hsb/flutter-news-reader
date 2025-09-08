
import 'package:dartz/dartz.dart';

import '../../core/errors/failures.dart';
import '../entities/article.dart';

abstract class NewsRepository {
  Future<Either<Failure, List<Article>>> getAggregatedNewsHeadlines({
    required DateTime from,
    required DateTime to,
    required int page,
    required int pageSize,
  });
}

