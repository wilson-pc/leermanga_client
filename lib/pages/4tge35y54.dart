import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:leermanga_client/models/MangaItem.dart';
import 'package:leermanga_client/services/MangaService.dart';
import 'package:leermanga_client/widgets/MangaCard.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class MangasPage extends StatefulWidget {
  @override
  _MangasPageState createState() => _MangasPageState();
}

class _MangasPageState extends State<MangasPage> {
  late List<MangaItem> mangas = [];
  MangaService mangaService = new MangaService();
  late ScrollController _scrollController;
  bool isLoading = false;
  void loadMangas(url) async {
    List<MangaItem> localMangas = await mangaService.getMangas(url);
    this.setState(() {
      mangas.addAll(localMangas);
      isLoading = false;
    });
  }

  _scrollListener() {
    if (_scrollController.offset >=
            _scrollController.position.maxScrollExtent &&
        !_scrollController.position.outOfRange) {
      setState(() {
        isLoading = true;
        print("comes to bottom $isLoading");
        if (isLoading) {
          print("RUNNING LOAD MORE");

          // loadMangas(mangas.last.next);
        }
      });
    }
  }

  @override
  void initState() {
    super.initState();
    loadMangas('https://leermanga.net/biblioteca');
    _scrollController = new ScrollController(initialScrollOffset: 5.0)
      ..addListener(_scrollListener);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Bibioteca'),
        ),
        body: SingleChildScrollView(
            controller: _scrollController,
            scrollDirection: Axis.vertical,
            physics: const AlwaysScrollableScrollPhysics(),
            child: Center(
                child: SafeArea(
                    child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: new StaggeredGridView.count(
                physics: NeverScrollableScrollPhysics(),

                shrinkWrap: true,
                crossAxisCount: 4, // I only need two card horizontally
                padding: const EdgeInsets.all(2.0),

                children: [
                  ...mangas.map<Widget>((item) {
                    //Do you need to go somewhere when you tap on this card, wrap using InkWell and add your route
                    return new MangaCard(
                      manga: item,
                    );
                  }).toList(),
                  const SpinKitRotatingCircle(color: Colors.blue),
                ],
                //Here is the place that we are getting flexible/ dynamic card for various images
                staggeredTiles: mangas
                    .map<StaggeredTile>((_) => StaggeredTile.fit(2))
                    .toList(),
                mainAxisSpacing: 3.0,
                crossAxisSpacing: 4.0, // add some space
              ),
            )))));
  }
}
