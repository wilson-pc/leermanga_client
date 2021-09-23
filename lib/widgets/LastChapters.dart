import 'package:flutter/material.dart';
import 'package:leermanga_client/models/ChapterHome.dart';
import 'package:leermanga_client/models/Manga.dart';
import 'package:leermanga_client/pages/ViewFinderPage.dart';

class LastChaptersCard extends StatefulWidget {
  final ChapterHome chapter;

  const LastChaptersCard({required this.chapter});

  @override
  _LastChaptersCardState createState() => _LastChaptersCardState();
}

class _LastChaptersCardState extends State<LastChaptersCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
        semanticContainer: false,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(4.0)),
        ),
        child: InkWell(
          onTap: () {
            // Function is executed on tap.

            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ViewFinderPage(
                          item: new Item(
                              name: widget.chapter.chapter,
                              url: widget.chapter.url),
                          title: widget.chapter.title,
                        )));
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Image.network(widget.chapter.cover),
              Text(
                widget.chapter.title,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(widget.chapter.chapter),
            ],
          ),
        ));
  }
}
