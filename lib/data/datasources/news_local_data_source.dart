import 'dart:convert';
import 'package:hive_flutter/hive_flutter.dart';

abstract class NewsLocalDataSource {
  Future<void> init();
  Future<void> cacheAggregatedPage(String cacheKey, Map<String, dynamic> json);
  Future<Map<String, dynamic>?> getAggregatedPage(String cacheKey);
}

class NewsLocalDataSourceImpl implements NewsLocalDataSource {
  static const _boxName = 'news_cache_box';
  Box<String>? _box;

  @override
  Future<void> init() async {
    await Hive.initFlutter();
    _box = await Hive.openBox<String>(_boxName);
  }

  @override
  Future<void> cacheAggregatedPage(String cacheKey, Map<String, dynamic> json) async {
    await _box?.put(cacheKey, jsonEncode(json));
  }

  @override
  Future<Map<String, dynamic>?> getAggregatedPage(String cacheKey) async {
    final raw = _box?.get(cacheKey);
    if (raw == null) return null;
    return jsonDecode(raw) as Map<String, dynamic>;
  }
}

