import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'core/di/injection.dart';
import 'domain/usecases/get_aggregated_news_headlines_usecase.dart';
import 'presentation/bloc/news_bloc.dart';
import 'presentation/pages/news_home_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initDI();
  runApp(const MyApp());
}

/*Future<void> main() async {
  runZonedGuarded(() {
    FlutterError.onError = (FlutterErrorDetails details) {
      FlutterError.dumpErrorToConsole(details);
      // TODO: می‌تونی لاگ بفرستی به Sentry یا Firebase Crashlytics
    };

    runApp(const MyApp());
  }, (error, stack) {
    print('Caught by runZonedGuarded: $error');
  });
}*/

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => NewsBloc(sl<GetAggregatedNewsHeadlinesUseCase>())),
      ],
      child: MaterialApp(
        title: 'News Reader',
        theme: ThemeData(
          colorSchemeSeed: Colors.indigo,
          useMaterial3: true,
          brightness: Brightness.light,
        ),
        home: const NewsHomePage(),
      ),
    );
  }
}

