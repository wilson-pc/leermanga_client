import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:leermanga_client/models/ChapterHome.dart';
import 'package:leermanga_client/widgets/LastChapters.dart';

class LastChaptersPage extends StatelessWidget {
  final List<ChapterHome> chapters;

  const LastChaptersPage({required this.chapters});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: new StaggeredGridView.count(
        crossAxisCount: 4, // I only need two card horizontally
        padding: const EdgeInsets.all(2.0),
        children: chapters.map<Widget>((item) {
          //Do you need to go somewhere when you tap on this card, wrap using InkWell and add your route
          return new LastChaptersCard(
            chapter: item,
          );
        }).toList(),

        //Here is the place that we are getting flexible/ dynamic card for various images
        staggeredTiles:
            chapters.map<StaggeredTile>((_) => StaggeredTile.fit(2)).toList(),
        mainAxisSpacing: 3.0,
        crossAxisSpacing: 4.0, // add some space
      ),
    );
  }
}
