import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:leermanga_client/models/Manga.dart';
import 'package:leermanga_client/models/MangaItem.dart';
import 'package:leermanga_client/pages/SearchPage.dart';
import 'package:leermanga_client/services/MangaService.dart';
import 'package:leermanga_client/widgets/MangaCard.dart';
import 'package:leermanga_client/widgets/NavDrawer.dart';

class MangasPage extends StatefulWidget {
  @override
  _MangasPageState createState() => _MangasPageState();
}

class _MangasPageState extends State<MangasPage> {
  late List<MangaItem> mangas = [];
  String title = "Biblioteca";
  late List<Item> categories = [];
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

  void loadCategories() async {
    List<Item> localCategories = await mangaService.getCategories();
    this.setState(() {
      categories = localCategories;
    });
  }

  _scrollListener() {
    if (_scrollController.offset >=
            _scrollController.position.maxScrollExtent &&
        !_scrollController.position.outOfRange) {
      setState(() {
        if (mangas.last.next != null) {
          isLoading = true;

          if (isLoading) {
            loadMangas(mangas.last.next);
          }
        }
      });
    }
  }

  @override
  void initState() {
    super.initState();
    loadMangas('https://leermanga.net/biblioteca');
    loadCategories();
    _scrollController = new ScrollController()..addListener(_scrollListener);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    GlobalKey<ScaffoldState> _key = GlobalKey();
    return Scaffold(
        drawer: NavDrawer(),
        appBar: AppBar(
          title: Text(title),
          leading: Builder(
            builder: (context) => // Ensure Scaffold is in context
                IconButton(
                    icon: Icon(Icons.menu),
                    onPressed: () => Scaffold.of(context).openDrawer()),
          ),
          actions: <Widget>[
            Padding(
                padding: EdgeInsets.only(right: 20.0),
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => SearchPage()));
                  },
                  child: Icon(
                    Icons.search,
                    size: 26.0,
                  ),
                )),
            Padding(
              padding: EdgeInsets.only(right: 20.0),
              child: PopupMenuButton(
                  child: Icon(Icons.more_vert),
                  onSelected: (value) {
                    Item item = value as Item;
                    this.loadMangas(item.url);
                    this.setState(() {
                      this.mangas = [];
                      this.title = item.name;
                      this.isLoading = true;
                    });
                  },
                  itemBuilder: (context) => [
                        PopupMenuItem(
                          child: Text('Todos'),
                          value: 'https://leermanga.net/biblioteca',
                        ),
                        ...categories
                            .map<PopupMenuEntry>((e) => PopupMenuItem(
                                  child: Text(e.name),
                                  value: e,
                                ))
                            .toList()
                      ]),
            ),
          ],
        ),
        body: SingleChildScrollView(
            controller: _scrollController,
            scrollDirection: Axis.vertical,
            physics: const AlwaysScrollableScrollPhysics(),
            child: Center(
                child: SafeArea(
                    child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: mangas.length == 0
                  ? const CircularProgressIndicator()
                  : new StaggeredGridView.count(
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
