import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:webfeed/webfeed.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import 'package:google_fonts/google_fonts.dart';

class RSSReader extends StatefulWidget {
  RSSReader() : super();

  @override
  RSSReaderState createState() => RSSReaderState();
}

class RSSReaderState extends State<RSSReader> {
  static const String FEED_URL = ''; //rss url
  static const String loadingMessage = 'Loading Feed...';
  static const String feedLoadErrorMessage = 'Error Loading Feed.';
  static const String feedOpenErrorMessage = 'Error Opening Feed.';
  RssFeed _feed;

  GlobalKey<RefreshIndicatorState> _refreshKey;

  //refresh the RSS data
  updateFeeds(feed) {
    setState(() {
      _feed = feed;
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
  load() async {
    loadFeed().then((result) {
      if (result == null || result.toString().isEmpty) {
        return;
      }else{
        updateFeeds(result);
      }
    });
  }

  // get the RSS data from given URL
  Future<RssFeed> loadFeed() async {
    try {
      final client = http.Client();
      final response = await client.get(FEED_URL);
      return RssFeed.parse(response.body);
    } catch (e) {}
    return null;
  }

  @override
  void initState() {
    super.initState();
    _refreshKey = GlobalKey<RefreshIndicatorState>();
    load();
  }

  // check if the RSS feed is empty
  isFeedEmpty() {
    return null == _feed || null == _feed.items;
  }

  //show refresh indicator or list
  body() {
    return isFeedEmpty()
        ? Center(
            child: CircularProgressIndicator(),

          )
        : RefreshIndicator(
            key: _refreshKey,
            child: list(),
            onRefresh: () => load(),
          );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: body(),
      ),
    );
  }

  //build list
  list() {
    return Container(
      child: ListView.builder(
        padding: EdgeInsets.all(5.0),
        itemCount: _feed.items.length,
        itemBuilder: (BuildContext context, int index) {
          final item = _feed.items[index];

          return InkWell(
              onTap: () => openFeed(item.link),
              child: Container(
                  padding: EdgeInsets.all(10.0),
                  margin: EdgeInsets.only(
                    bottom: 10.0,
                  ),
                  decoration: customBoxDecoration(),
                  child: Column(
                    children: <Widget>[
                      Text(
                        item.title,
                        textDirection: TextDirection.ltr,
                        style: GoogleFonts.oswald(
                          fontSize: 20,
                        ),
                      ),
                      Image.network(item.enclosure.url,
                          height: 200, fit: BoxFit.fill),
                      Text(
                        item.description,
                        style: GoogleFonts.oswald(),
                        textAlign: TextAlign.justify,
                      ),
                    ],
                  )));
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
}