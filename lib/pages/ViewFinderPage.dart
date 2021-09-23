import 'dart:io';
import 'dart:ui';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:leermanga_client/entity/Chapter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:socket_io_client/socket_io_client.dart';
import 'package:uuid/uuid.dart';
import 'package:leermanga_client/models/Manga.dart';
import 'package:ndialog/ndialog.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:leermanga_client/models/MangaImages.dart';
import 'package:leermanga_client/services/MangaService.dart';

import '../repository.dart';

class ViewFinderPage extends StatefulWidget {
  final Item item;
  final String title;
  final String? mangaUrl;

  const ViewFinderPage(
      {required this.item, required this.title, this.mangaUrl});

  get manga => null;

  @override
  _ViewFinderPageState createState() => _ViewFinderPageState();
}

class _ViewFinderPageState extends State<ViewFinderPage> {
  MangaService mangaService = new MangaService();
  late Future<MangaImages> page;
  bool appbar = true;
  late DragStartDetails startVerticalDragDetails;
  late Socket socket;
  late ProgressDialog progressDialog;
  bool downloading = true;
  String downloadingStr = "No data";
  double download = 0.0;
  late File f;

  void getChapter() async {
    var fav = await getChapterByUrl(widget.item.url);

    if (fav == null) {
      if (widget.mangaUrl == null) {
      } else {
        const uud = Uuid();
        try {
          await saveChapter(new Chapter(
              id: uud.v4(),
              createat: new DateTime.now().toString(),
              name: widget.item.name,
              url: widget.item.url,
              local: true,
              urlmanga: widget.mangaUrl!,
              manga: widget.title));
        } catch (e) {
          print(e.toString());
        }
      }
    }
  }

  @override
  void dispose() {
    SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);

    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    connectToServer();
    getChapter();

    page = mangaService.getPages(widget.item);
  }

  void connectToServer() {
    try {
      print("llega");
      // Configure socket transports must be sepecified
      socket = io('https://comicdownloader.tk', <String, dynamic>{
        'transports': ['websocket'],
        'autoConnect': true,
      });

      // Connect to websocket
      socket.connect();
      print("pappapa");

      // Handle socket events
      socket.on('connect', (_) => print('connect: ${socket.id}'));
      socket.on('disconnect', (_) => print('disconnect'));
      socket.on('progress-event', (data) => {print(data.toString())});
      socket.on('complete-event', (data) async {
        final isPermissionStatusGranted = await _requestPermissions();
        if (isPermissionStatusGranted) {
          progressDialog.setTitle(Text("Descargando"));
          Dio dio = Dio();
          const uuid = Uuid();
          String url = await getFilePath("${uuid.v4()}.pdf");
          String uri = 'https://comicdownloader.tk/' + data['file'];
          print(uri);
          final response =
              await dio.download(uri, url, onReceiveProgress: (rec, total) {
            setState(() {
              downloading = true;
              download = (rec / total) * 100;

              progressDialog.setTitle(Text("Descargando"));
              progressDialog.setMessage(
                  Text("descargando" + (download).toStringAsFixed(0)));
              if (download.toStringAsFixed(0) == '100') {
                progressDialog.dismiss();
              }
            });
          });
          progressDialog.dismiss();
        } else {
          progressDialog.dismiss();
        }
      });
    } catch (e) {
      print("error");
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return WillPopScope(
        onWillPop: () async {
          return true;
        },
        child: Scaffold(
            extendBodyBehindAppBar: true,
            backgroundColor: Colors.green,
            appBar: appbar
                ? AppBar(
                    backgroundColor: Colors.transparent,
                    iconTheme: IconThemeData(color: Colors.black),
                    elevation: 0.0,
                    brightness: Brightness.dark,
                    title: Text(
                      widget.item.name,
                      style: TextStyle(color: Colors.black),
                    ),
                    centerTitle: true,
                    bottom: PreferredSize(
                        child: Text(widget.title), preferredSize: Size.zero),
                    actions: <Widget>[
                        Padding(
                            padding: EdgeInsets.only(right: 20.0),
                            child: GestureDetector(
                              onTap: () {
                                socket.emit('download-click',
                                    {"value": widget.item.url});
                                progressDialog = ProgressDialog(context,
                                    blur: 10, title: Text("Preparando"));
                                progressDialog.setLoadingWidget(
                                    CircularProgressIndicator(
                                        valueColor: AlwaysStoppedAnimation(
                                            Colors.red)));
                                progressDialog.show();
                              },
                              child: Icon(
                                Icons.download,
                                size: 26.0,
                              ),
                            ))
                      ])
                : null,
            body: SingleChildScrollView(
                child: Center(
                    child: FutureBuilder(
                        future: page,
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            MangaImages data = snapshot.data as MangaImages;
                            if (data.pages.length > 1) {
                              SystemChrome.setEnabledSystemUIOverlays([]);
                              return SafeArea(
                                  child: Center(
                                      child: Column(
                                children: data.pages.map<Widget>((e) {
                                  return GestureDetector(
                                      onTap: () async {
                                        this.setState(() {
                                          appbar = appbar ? false : true;
                                        });
                                      },
                                      child: Container(
                                        child: Image.network(
                                          e,
                                          alignment: Alignment.center,
                                          loadingBuilder: (context, child,
                                              loadingProgress) {
                                            if (loadingProgress == null)
                                              return child;

                                            return Center(
                                                child:
                                                    new CircularProgressIndicator());
                                            // You can use LinearProgressIndicator or CircularProgressIndicator instead
                                          },
                                        ),
                                      ));
                                }).toList(),
                              )));
                            } else {
                              return Container(
                                width: size.width * 0.85,
                                margin: const EdgeInsets.only(top: 100.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Text(
                                      'No hay servidores para el capitulo',
                                      style: TextStyle(
                                          fontSize: 15, color: Colors.red),
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                ),
                              );
                            }
                          } else if (snapshot.hasError) {
                            return Flex(
                                direction: Axis.horizontal,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                      padding: EdgeInsets.all(20),
                                      child: Text("No Records found"))
                                ]);
                          }

                          // By default, show a loading spinner.
                          return const CircularProgressIndicator();
                        })))));
  }
}

Future<void> saveChapter(Chapter chapter) async {
  final database = await dbInstance();
  final dao = database.chapterDao;

  return await dao.insertChapter(chapter);
}

Future<Chapter?> getChapterByUrl(String url) async {
  final database = await dbInstance();
  final dao = database.chapterDao;

  return await dao.findChapterByUrl(url);
}

Future<bool> _requestPermissions() async {
  if (await Permission.storage.request().isGranted) {
    // Either the permission was already granted before or the user just granted it.
    return true;
  } else {
    return false;
  }
}

Future<String> getFilePath(uniqueFileName) async {
  String path = '';

  Directory dir = await getApplicationDocumentsDirectory();

  path = '${dir.path}/$uniqueFileName';

  return path;
}
