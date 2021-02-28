import 'package:flutter/material.dart';
import 'rss_reader.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: RSSReader(),
    );
  }
}
