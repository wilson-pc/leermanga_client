import 'package:flutter/material.dart';

import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:leermanga_client/models/MangaItem.dart';
import 'package:leermanga_client/services/MangaService.dart';
import 'package:leermanga_client/widgets/MangaCard.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  late List<MangaItem> mangas = [];
  MangaService mangaService = new MangaService();
  late ScrollController _scrollController;
  bool isLoading = false;
  String textSearch = "";
  bool end = false;
  List<String> urls = [];

  void loadMangas(url) async {
    List<MangaItem> localMangas = await mangaService.getMangas(url);

    this.setState(() {
      isLoading = false;
      if (localMangas.length > 0) {
        mangas.addAll(localMangas);

        if (!urls.contains(localMangas.last.next)) {
          urls.add(localMangas.last.next ?? '');
        } else {
          end = true;
        }
      } else {
        showDialog<String>(
            context: context,
            builder: (BuildContext context) => AlertDialog(
                  content: Text('No hay resultado para ' + this.textSearch),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () {
                        this.setState(() {
                          this.textSearch = '';
                        });
                        Navigator.pop(context, 'OK');
                      },
                      child: const Text('OK'),
                    ),
                  ],
                ));
      }
    });
  }

  _scrollListener() {
    if (_scrollController.offset >=
            _scrollController.position.maxScrollExtent &&
        !_scrollController.position.outOfRange) {
      print(mangas.last.next);
      setState(() {
        if (textSearch.length > 0) {
          if (!end) {
            if (mangas.last.next != null) {
              isLoading = true;

              if (isLoading) {
                loadMangas(mangas.last.next);
              }
            }
          }
        }
      });
    }
  }

  @override
  void initState() {
    super.initState();

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
        appBar: AppBar(
          title: TextField(
            style: TextStyle(color: Colors.white),
            cursorColor: Colors.white,
            onSubmitted: (value) {
              loadMangas('https://leermanga.net/biblioteca?search=' + value);
              this.setState(() {
                isLoading = true;
                textSearch = value;
              });
            },
            decoration: InputDecoration(
                hintStyle: TextStyle(color: Colors.white),
                hintText: 'Search',
                prefixIcon: Icon(Icons.search)),
          ),
        ),
        body: SingleChildScrollView(
            controller: _scrollController,
            scrollDirection: Axis.vertical,
            physics: const AlwaysScrollableScrollPhysics(),
            child: Center(
                child: SafeArea(
                    child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: textSearch.length > 1 && mangas.length == 0
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
