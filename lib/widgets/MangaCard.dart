import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:leermanga_client/models/HexColor.dart';
import 'package:leermanga_client/models/MangaItem.dart';
import 'package:leermanga_client/pages/MangaPage.dart';

class MangaCard extends StatefulWidget {
  final MangaItem manga;

  const MangaCard({required this.manga});

  @override
  _MangaCardState createState() => _MangaCardState();
}

class _MangaCardState extends State<MangaCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
        color: HexColor(widget.manga.color),
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
                    builder: (context) => MangaPage(
                          manga: widget.manga,
                        )));
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              CachedNetworkImage(
                imageUrl: widget.manga.cover,
                placeholder: (context, url) => CircularProgressIndicator(),
                errorWidget: (context, url, error) => Icon(Icons.error),
              ),
              Text(
                widget.manga.title,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(widget.manga.type),
            ],
          ),
        ));
  }
}
