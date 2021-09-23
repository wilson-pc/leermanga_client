import 'package:flutter/material.dart';
import 'package:leermanga_client/entity/Chapter.dart';
import 'package:leermanga_client/entity/Favorites.dart';
import 'package:leermanga_client/entity/UserLocal.dart';
import 'package:supabase/supabase.dart';
import 'package:uuid/uuid.dart';

import 'package:leermanga_client/models/HexColor.dart';
import 'package:leermanga_client/models/Manga.dart';
import 'package:leermanga_client/models/MangaItem.dart';
import 'package:leermanga_client/services/MangaService.dart';

import '../repository.dart';
import '../supabase.dart';
import 'ViewFinderPage.dart';

class MangaPage extends StatefulWidget {
  final MangaItem manga;

  const MangaPage({required this.manga});

  @override
  _MangaPageState createState() => _MangaPageState();
}

class _MangaPageState extends State<MangaPage> {
  MangaService mangaService = new MangaService();
  bool favorite = false;
  Favorites? fv;
  late List<Chapter?> chap;
  late Future<Manga> manga;
  late UserLocal? user;
  void getUser() async {
    UserLocal? users = await currentUser();

    if (users == null) {
      var fav = await getFavoriteByUrl(widget.manga.url);
      if (fav != null) {
        setState(() {
          user = null;
          favorite = true;
          fv = fav;
        });
      } else {
        setState(() {
          user = null;
          fv = null;
        });
      }
    } else {
      var fav = await getFavoriteByUrlNet(widget.manga.url, users.id);
      if (fav != null) {
        setState(() {
          favorite = true;
          fv = fav;
          user = users;
        });
      } else {
        setState(() {
          user = users;
          fv = null;
        });
      }
    }
  }

  void getChapters() async {
    var fav = await getMangasChapters(widget.manga.url);

    chap = fav;
  }

  @override
  void initState() {
    super.initState();
    manga = mangaService.getDetail(widget.manga);

    getChapters();
    getUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.manga.title),
        ),
        body: SingleChildScrollView(
            child: Center(
                child: FutureBuilder(
                    future: manga,
                    builder: (context, snapshot) {
                      /*
                      */
                      if (snapshot.hasData) {
                        Manga localManga = snapshot.data as Manga;

                        return SafeArea(
                          child: Column(
                            children: [
                              hero(localManga, user ?? null),
                              section(localManga, chap, fv)
                            ],
                          ),
                        );
                      }

                      // By default, show a loading spinner.
                      return const CircularProgressIndicator();
                    }))));
  }

  Widget hero(Manga manga, UserLocal? user) {
    return Container(
      child: Stack(
        children: [
          new AspectRatio(
            aspectRatio: 550 / 451,
            child: new Container(
              child: Container(
                alignment: FractionalOffset.bottomLeft,
                child: Text(manga.title,
                    style: TextStyle(
                        color: Colors.white,
                        backgroundColor: Colors.black87,
                        fontWeight: FontWeight.bold,
                        fontSize: 22.0)),
              ),
              decoration: new BoxDecoration(
                  image: new DecorationImage(
                fit: BoxFit.fitWidth,
                alignment: FractionalOffset.topCenter,
                image: new NetworkImage(manga.cover),
              )),
            ),
          ),
          Positioned(
              bottom: 10,
              right: 20,
              child: FloatingActionButton(
                  onPressed: () async {
                    if (favorite) {
                      if (user == null) {
                        await deleteFavorite(fv!.id);
                      } else {
                        await supabaseClient
                            .from('favorites')
                            .delete()
                            .eq("id", fv!.id)
                            .execute();
                      }
                    } else {
                      const uuid = Uuid();
                      if (user == null) {
                        await saveFavorite(new Favorites(
                            id: uuid.v4(),
                            title: manga.title,
                            cover: manga.cover,
                            type: manga.type,
                            url: manga.url,
                            local: true,
                            createat: new DateTime.now().toString(),
                            color: manga.color));
                      } else {
                        await supabaseClient.from("favorites").insert({
                          'id': uuid.v4(),
                          'title': manga.title,
                          'userId': user.id,
                          'cover': manga.cover,
                          'type': manga.type,
                          'url': manga.url,
                          'color': manga.color,
                          'next': manga.next,
                        }).execute();
                      }
                    }
                    setState(() {
                      favorite = favorite ? false : true;
                    });
                  },
                  child:
                      Icon(favorite ? Icons.favorite : Icons.favorite_border),
                  backgroundColor: Colors.green))
        ],
      ),
    );
  }
}

Widget section(Manga manga, List<Chapter?> chap, Favorites? fv) {
  return Container(
    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
    child: Column(
      children: [
        Text(
          manga.sinopsis,
          textAlign: TextAlign.justify,
          style: TextStyle(color: Colors.black54, fontSize: 14, height: 1.5),
        ),
        SizedBox(height: 20),
        Wrap(
          spacing: 6.0,
          runSpacing: 6.0,
          children: manga.genres.map<Widget>((e) {
            return chips(e);
          }).toList(),
        ),
        Container(
          child: ListView.builder(
            // Let the ListView know how many items it needs to build.
            itemCount: manga.chapters.length,
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            // Provide a builder function. This is where the magic happens.
            // Convert each item into a widget based on the type of item it is.
            itemBuilder: (context, index) {
              final Item item = manga.chapters[index];

              return ListTile(
                focusColor: Colors.red,
                trailing: Icon(Icons.keyboard_arrow_right),
                leading: Icon(
                  Icons.check_circle,
                  color:
                      chap.where((element) => element!.url == item.url).length >
                              0
                          ? Colors.blue.shade400
                          : null,
                ),
                title: Text(item.name),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ViewFinderPage(
                                item: item,
                                title: manga.title,
                                mangaUrl: manga.url,
                              )));
                },
              );
            },
          ),
        )
      ],
    ),
  );
}

Widget chips(Item item) {
  return Chip(
    labelPadding: EdgeInsets.all(2.0),
    label: Text(
      item.name,
      style: TextStyle(
        color: Colors.white,
      ),
    ),
    backgroundColor: HexColor("#2C66A2"),
    elevation: 6.0,
    shadowColor: Colors.grey[60],
    padding: EdgeInsets.all(8.0),
  );
}

Future<void> saveFavorite(Favorites favorite) async {
  final database = await dbInstance();
  final dao = database.favoriteDao;

  await dao.insertFavorite(favorite);
}

Future<void> deleteFavorite(String id) async {
  final database = await dbInstance();
  final dao = database.favoriteDao;

  await dao.deleteFavorite(id);
}

Future<Favorites?> getFavoriteByUrl(String url) async {
  final database = await dbInstance();
  final dao = database.favoriteDao;

  return await dao.findFavoriteByUrl(url);
}

Future<Favorites?> getFavoriteByUrlNet(String url, String userId) async {
  final selectResponse = await supabaseClient
      .from("favorites")
      .select()
      .eq('url', url)
      .eq('userId', userId)
      .execute(count: CountOption.exact);
  if (selectResponse.error == null) {
    if (selectResponse.data.length == 0) {
      return null;
    } else {
      var fv = selectResponse.data[0];
      return new Favorites(
          id: fv['id'],
          title: fv['title'],
          cover: fv['cover'],
          type: fv['type'],
          url: fv['url'],
          createat: fv['created_at'],
          local: false,
          color: fv['color']);
    }
  } else {
    return null;
  }
}

Future<List<Chapter?>> getMangasChapters(String url) async {
  final database = await dbInstance();
  final dao = database.chapterDao;

  return await dao.findChapterByUrlmanga(url);
}

Future<UserLocal?> currentUser() async {
  final database = await dbInstance();
  final dao = database.userDao;

  return await dao.currentUser();
}
