import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// ignore: must_be_immutable
class MyRssItem extends StatelessWidget {
  var item;

  MyRssItem(this.item);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      margin: EdgeInsets.all(5.0),
      child: Column(
        children: <Widget>[
          Text(
            item.title,
            textDirection: TextDirection.ltr,
            style: GoogleFonts.oswald(
              fontSize: 20,
            ),
          ),
          SizedBox(height: 5),
          Image.network(item.enclosure.url, height: 200, fit: BoxFit.fill),
          SizedBox(height: 5),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              item.description,
              style: GoogleFonts.oswald(fontSize: 15),
            ),
          ),
          SizedBox(height: 10),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              item.pubDate,
              textDirection: TextDirection.ltr,
              textAlign: TextAlign.left,
            ),
          )
        ],
      ),
    );
  }
}