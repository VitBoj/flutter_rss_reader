import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:rss_news_feed/data/rss_loader.dart';
import 'package:rss_news_feed/widgets/list_item.dart';
import 'package:url_launcher/url_launcher.dart';

import '../database/database_manager.dart';
import '../models/rss_item_model.dart';
import '../helpers/converter.dart';
import 'package:fluttertoast/fluttertoast.dart';

class NewsFeedScreen extends StatefulWidget {
  NewsFeedScreen() : super();

  @override
  NewsFeedScreenState createState() => NewsFeedScreenState();
}

class NewsFeedScreenState extends State<NewsFeedScreen> {
  List<RssItemModel> _data = [];

  GlobalKey<RefreshIndicatorState> _refreshKey;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: body(),
      ),
    );
  }

  //body
  body() {
    return RefreshIndicator(
      key: _refreshKey,
      child: buildList(),
      onRefresh: () => loadData(),
    );
  }

  @override
  void initState() {
    super.initState();
    _refreshKey = GlobalKey<RefreshIndicatorState>();
    loadData();
  }

  //refresh the RSS data
  updateData(feed) {
    setState(() {
      _data = feed;
    });
  }

  // open feed review page
  Future<void> openFeed(String url) async {
    if (await canLaunch(url)) {
      await launch(
        url,
        forceWebView: true,
      );
      return;
    }
  }

  // load the RSS data
  loadData() async {
    try {
      RssLoader.loadRssFromUrl().then((result) {
        if (result == null || result.toString().isEmpty) {
          getItemsFromDB();
        } else {
          updateData(ConvertRssFeedToItemList.converting(result));
          DataBaseManager.saveItemsToDB(
              ConvertRssFeedToItemList.converting(result));
        }
      });
    } catch (e) {}
  }

  //build list
  buildList() {
    return Container(
      child: ListView.builder(
        padding: EdgeInsets.all(5.0),
        itemCount: _data.length,
        itemBuilder: (BuildContext context, int index) {
          final item = _data[index];
          return InkWell(
              onTap: () => openFeed(item.link),
              child: Container(
                  padding: EdgeInsets.all(10.0),
                  margin: EdgeInsets.only(bottom: 10.0),
                  decoration: customBoxDecoration(),
                  child: ListItem(item)));
        },
      ),
    );
  }

  //box decoration for the Container Widgets
  BoxDecoration customBoxDecoration() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.all(Radius.circular(5)),
      boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(1),
          spreadRadius: 2,
          blurRadius: 5,
          offset: Offset(0, 3), // changes position of shadow
        ),
      ],
    );
  }

  getItemsFromDB() {
    DataBaseManager.getItemsFromDB().then((result) {
      if (result == null) {
        showNoDataMessage();
      } else {
        List<RssItemModel> list =
            result.map((item) => RssItemModel.fromMap(item)).toList();
        updateData(list);
      }
    });
  }

  showNoDataMessage() {
    Fluttertoast.showToast(
        msg:
            "No data,Please check your internet connection and swipe to refresh",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.TOP,
        timeInSecForIosWeb: 2,
        backgroundColor: Colors.white,
        textColor: Colors.black,
        fontSize: 20.0);
  }
}
