import 'package:rss_news_feed/models/rss_item_model.dart';
import 'package:webfeed/domain/rss_feed.dart';

class ConvertRssFeedToItemList {
  static List<RssItemModel> converting(RssFeed rssFeed) {
    List<RssItemModel> list = [];
    for (int i = 0; i < rssFeed.items.length; i++) {
      var item = rssFeed.items[i];
      RssItemModel rssItemModel = RssItemModel(i, item.link, item.title,
          item.enclosure.url, item.description, item.pubDate);
      list.add(rssItemModel);
    }
    return list;
  }
}
