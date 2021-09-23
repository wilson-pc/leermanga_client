import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:leermanga_client/entity/Favorites.dart';
import 'package:leermanga_client/entity/UserLocal.dart';

import 'package:leermanga_client/models/MangaItem.dart';

import 'package:leermanga_client/services/MangaService.dart';
import 'package:leermanga_client/widgets/MangaCard.dart';
import 'package:leermanga_client/widgets/NavDrawer.dart';

import '../repository.dart';
import '../supabase.dart';

class FavoritesPage extends StatefulWidget {
  @override
  _FavoritesPageState createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  late List<MangaItem> mangas = [];
  String title = "Favoritos";

  MangaService mangaService = new MangaService();
  late UserLocal? user;
  bool loading = true;
  void getUser() async {
    UserLocal? users = await currentUser();

    if (users == null) {
      List<Favorites?> localMangas = await getFavorites();

      List<MangaItem> fv = [];
      localMangas.forEach((element) {
        print(element!.color);
        fv.add(new MangaItem(
            title: element.title,
            cover: element.cover,
            type: element.type,
            url: element.url,
            color: element.color));
      });

      this.setState(() {
        mangas.addAll(fv);
        loading = false;
      });
    } else {
      List<dynamic> localMangas = await getFavoritesNet(users);

      List<MangaItem> fv = [];
      localMangas.forEach((element) {
        fv.add(new MangaItem(
            title: element['title'],
            cover: element['cover'],
            type: element['type'],
            url: element['url'],
            color: element['color']));
      });

      this.setState(() {
        loading = false;
        mangas.addAll(fv);
      });
    }
  }

  @override
  void initState() {
    super.initState();

    getUser();
  }

  @override
  void dispose() {
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
        ),
        body: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            physics: const AlwaysScrollableScrollPhysics(),
            child: Center(
                child: SafeArea(
                    child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: loading
                  ? const CircularProgressIndicator()
                  : mangas.length == 0
                      ? const Text("No hay favoritos")
                      : new StaggeredGridView.count(
                          physics: NeverScrollableScrollPhysics(),

                          shrinkWrap: true,
                          crossAxisCount:
                              4, // I only need two card horizontally
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

Future<List<Favorites?>> getFavorites() async {
  final database = await dbInstance();
  final dao = database.favoriteDao;

  return await dao.findAllFavorites();
}

Future<UserLocal?> currentUser() async {
  final database = await dbInstance();
  final dao = database.userDao;

  return await dao.currentUser();
}

Future<List<dynamic>> getFavoritesNet(UserLocal user) async {
  final selectResponse = await supabaseClient
      .from("favorites")
      .select()
      .eq('userId', user.id)
      .order("created_at")
      .execute();
  if (selectResponse.error == null) {
    return selectResponse.data;
  } else {
    return [];
  }
}
