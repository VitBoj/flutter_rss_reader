import 'package:webfeed/domain/rss_feed.dart';
import 'package:http/http.dart' as http;

class RssLoader{
  static const String FEED_URL =""; //rss url

  static Future<RssFeed> loadRssFromUrl() async {
    try {
      final client = http.Client();
      final response = await client.get(FEED_URL);
      return RssFeed.parse(response.body);
    } catch (e) {}

    return null;
  }

}