import 'package:flutter/material.dart';
import 'package:leermanga_client/entity/Chapter.dart';
import 'package:leermanga_client/models/Manga.dart';
import 'package:leermanga_client/models/MangaItem.dart';
import 'package:leermanga_client/widgets/NavDrawer.dart';
import 'package:intl/intl.dart';
import '../repository.dart';
import 'MangaPage.dart';
import 'ViewFinderPage.dart';

class HistoryPage extends StatefulWidget {
  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  List<Chapter?> history = [];
  bool loading = true;
  void getChapters() async {
    var fav = await getHistory();

    setState(() {
      history = fav;
      loading = false;
    });
  }

  @override
  void initState() {
    super.initState();

    getChapters();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: NavDrawer(),
      appBar: AppBar(
        title: Text('Historial'),
        leading: Builder(
          builder: (context) => // Ensure Scaffold is in context
              IconButton(
                  icon: Icon(Icons.menu),
                  onPressed: () => Scaffold.of(context).openDrawer()),
        ),
      ),
      body: loading
          ? const CircularProgressIndicator()
          : ListView.builder(
              itemCount: history.length,
              itemBuilder: (BuildContext context, int index) {
                Chapter? item = history[index];

                return ListTile(
                  trailing: Padding(
                    padding: EdgeInsets.only(right: 20.0),
                    child: PopupMenuButton(
                        child: Icon(Icons.more_vert),
                        onSelected: (value) {
                          if (value == "more") {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => MangaPage(
                                          manga: new MangaItem(
                                              title: item!.manga,
                                              cover: "",
                                              type: "",
                                              url: item.urlmanga,
                                              color: ""),
                                        )));
                          } else {}
                        },
                        itemBuilder: (context) => [
                              PopupMenuItem(
                                child: Text("Borrar"),
                                value: 'delete',
                              ),
                              PopupMenuItem(
                                child: Text('Mas capitulos'),
                                value: 'more',
                              ),
                            ]),
                  ),
                  title: Text(item!.manga),
                  onTap: () {
                    print(item.url);
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ViewFinderPage(
                                item: new Item(name: item.name, url: item.url),
                                title: item.manga)));
                  },
                  subtitle: Row(children: <Widget>[
                    Expanded(child: Text(item.name)),
                    /*  Expanded(
                        child: Text(DateFormat('dd-MM-yyyy hh:mm a')
                            .parse(item.createat)
                            .toString())),*/
                  ]),
                );
              }),
    );
  }
}

Future<List<Chapter?>> getHistory() async {
  final database = await dbInstance();
  final dao = database.chapterDao;

  return await dao.findAllChapter();
}
