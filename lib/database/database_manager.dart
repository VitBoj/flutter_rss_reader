import 'package:rss_news_feed/models/rss_item_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:webfeed/domain/rss_item.dart';

abstract class DataBaseManager {
  static Database _database;

  static int get _version => 1;

  static Future<void> init() async {
    if (_database != null) {
      return;
    }
    try {
      String _path = await getDatabasesPath() + 'rss_news_app';
      _database =
          await openDatabase(_path, version: _version, onCreate: onCreate);
    } catch (ex) {
      print(ex);
    }
  }

  static void onCreate(Database db, int version) async =>
      await db.execute('CREATE TABLE news_items ('
          'id INTEGER PRIMARY KEY NOT NULL,'
          'link STRING,'
          'title STRING,'
          ' imgUrl STRING, '
          'description STRING,'
          'pubDate String)');

  static Future<List<Map<String, dynamic>>> query(String table) async =>
      _database.query(table);

  static Future<int> insert(String table, RssItemModel model) async =>
      await _database.insert(table, model.toMap());

  static Future<int> deleteAll(String table) async =>
      await _database.delete(table);

  //get all items from database
  static Future getItemsFromDB() async {
    List<Map<String, dynamic>> _results =
        await DataBaseManager.query(RssItemModel.tableName);
  }

//save items to database
  static void saveItemsToDB(List<RssItemModel> list) async {
    DataBaseManager.deleteAll(RssItemModel.tableName);
    if (list.length > 0) {
      for (int i = 0; i < list.length; i++) {
        var listItem = list[i];
        try {
          DataBaseManager.insert(RssItemModel.tableName, listItem);
        } catch (e) {
        }
      }
    }
  }
}
