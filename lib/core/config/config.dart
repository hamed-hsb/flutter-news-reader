class AppConfig {
  static const String newsApiKey = String.fromEnvironment(
    'NEWS_API_KEY',
    defaultValue: 'a3d859a6b843415caffbfacf1278ebb6',
  );

  static const String baseUrl = 'https://newsapi.org/v2';
  static const List<String> queries = ['microsoft', 'apple', 'google', 'tesla'];
  static const List<String> displayOrder = ['Microsoft', 'Apple', 'Google', 'Tesla'];
}

