import 'package:flutter/material.dart';
import 'package:rss_news_feed/database/database_manager.dart';
import 'screens/news_feed_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DataBaseManager.init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: NewsFeedScreen(),
    );
  }
}
