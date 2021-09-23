import 'package:flutter/material.dart';
import 'package:leermanga_client/models/ChapterHome.dart';
import 'package:leermanga_client/models/HomeData.dart';
import 'package:leermanga_client/models/MangaItem.dart';
import 'package:leermanga_client/pages/LastChaptesPage.dart';
import 'package:leermanga_client/pages/LastMangasPage.dart';
import 'package:leermanga_client/services/MangaService.dart';
import 'package:leermanga_client/widgets/NavDrawer.dart';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin {
  /*
  final String arrayObjsText =
      '[{"name": "dart", "quantity": 12}, {"name": "flutter", "quantity": 25}, {"name": "json", "quantity": 8}]';
  */

  MangaService mangaService = new MangaService();
  List<ChapterHome> chapters = [];
  List<MangaItem> mangas = [];

  void initData() async {
    HomeData data = await mangaService.getInit();

    this.setState(() {
      chapters = data.chapters;
      mangas = data.mangas;
    });
  }

  late TabController tabController;

  @override
  void initState() {
    initData();
    tabController = new TabController(initialIndex: 0, length: 2, vsync: this);
    super.initState();
    // print(this.chapters);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: NavDrawer(),
      appBar: AppBar(
        bottom: TabBar(
          controller: tabController,
          tabs: [
            Tab(text: 'Capitulos actualizados'),
            Tab(
              text: 'Mangas agredados',
            ),
          ],
        ),
        title: Text('Recien agregados'),
      ),
      body: chapters.length == 0
          ? Center(
              child: const CircularProgressIndicator(),
            )
          : TabBarView(
              controller: tabController,
              children: [
                LastChaptersPage(chapters: chapters),
                LastMangasPage(mangas: mangas)
              ],
            ),
    );
  }
}
