import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import 'package:leermanga_client/models/MangaItem.dart';
import 'package:leermanga_client/widgets/MangaCard.dart';

class LastMangasPage extends StatelessWidget {
  final List<MangaItem> mangas;

  const LastMangasPage({required this.mangas});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: new StaggeredGridView.count(
        crossAxisCount: 4, // I only need two card horizontally
        padding: const EdgeInsets.all(2.0),
        children: mangas.map<Widget>((item) {
          //Do you need to go somewhere when you tap on this card, wrap using InkWell and add your route
          return new MangaCard(
            manga: item,
          );
        }).toList(),

        //Here is the place that we are getting flexible/ dynamic card for various images
        staggeredTiles:
            mangas.map<StaggeredTile>((_) => StaggeredTile.fit(2)).toList(),
        mainAxisSpacing: 3.0,
        crossAxisSpacing: 4.0, // add some space
      ),
    );
  }
}
