class RssItemModel {
  static String tableName = "news_items";

  int id;
  String link;
  String title;
  String imgUrl;
  String description;
  String pubDate;

  RssItemModel(this.id, this.link, this.title, this.imgUrl, this.description,
      this.pubDate);

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      "id": id,
      "link": link,
      "title": title,
      "imgUrl": imgUrl,
      "description": description,
      "pubDate": pubDate
    };
    return map;
  }

  static RssItemModel fromMap(Map<String, dynamic> map) {
    return RssItemModel(map["id"], map["link"], map["title"], map["imgUrl"],
        map["description"], map["pubDate"]);
  }
}
