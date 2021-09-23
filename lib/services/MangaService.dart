import 'package:leermanga_client/models/ChapterHome.dart';
import 'package:leermanga_client/models/HomeData.dart';
import 'package:leermanga_client/models/Manga.dart';
import 'package:leermanga_client/models/MangaItem.dart';

import 'package:http/http.dart' as http;
import 'package:html/parser.dart';
import 'package:leermanga_client/models/MangaImages.dart';

class MangaService {
  Future<HomeData> getInit() async {
    http.Response response = await http.get(
      Uri.parse('https://leermanga.net/'),
    );

    var document = parse(response.body);
    var cards = document
        .getElementsByClassName("page-listing-item")
        .first
        .getElementsByClassName("page-item-detail");
    var mangasHtml = document
        .getElementsByClassName('page-listing-item')[1]
        .getElementsByClassName('page-item-detail');
    List<ChapterHome> chaptersLocal = [];
    for (var item in cards) {
      chaptersLocal.add(ChapterHome(
          title: item.getElementsByClassName("manga-title-updated").first.text,
          cover: item
                  .getElementsByClassName('img-responsive')
                  .first
                  .attributes['src'] ??
              '',
          chapter:
              item.getElementsByClassName("manga-episode-title").first.text,
          url: item.getElementsByTagName('a').first.attributes['href'] ?? ''));
    }

    List<MangaItem> mangaLocal = [];
    for (var item in mangasHtml) {
      //  print(item.querySelector(".content-ellipsis a")!.attributes['href']);
      //print(item.getElementsByClassName("manga-episode-title").first.text);

      // print(item.getElementsByClassName('img-responsive').first.attributes['src']);
      var option = {
        "manhua": "#8D6E63",
        "manhwa": "#81C784",
        "manga": "#7986CB",
        "novela": "#E57373",
        "doujinshi": "#F6B952",
        "one_shot": "#F06292"
      };
      String type = item.getElementsByTagName('span').first.text;

      mangaLocal.add(MangaItem(
          title: item.querySelector(".content-ellipsis a")!.text,
          cover: item.getElementsByTagName('img').first.attributes['src'] ?? '',
          type: type,
          color: option[type.toLowerCase().trim()] ?? '',
          url: item.querySelector(".content-ellipsis a")!.attributes['href'] ??
              ''));
    }
    return new HomeData(chapters: chaptersLocal, mangas: mangaLocal);
  }

  Future<Manga> getDetail(MangaItem manga) async {
    http.Response response = await http.get(
      Uri.parse(manga.url),
    );

    var document = parse(response.body);
    String sinopsis =
        document.getElementsByClassName('summary__content').first.text.trim();
    String cover =
        document.querySelector('.summary_image img')!.attributes['src'] ?? "";

    String age =
        document.querySelector(".post-content_item .summary-content")!.text;
    List<Item> genres = [];
    var tags = document.getElementsByClassName('tags_manga');
    tags.forEach((element) {
      genres.add(
          new Item(name: element.text, url: element.attributes['href'] ?? ''));
    });

    List<Item> chapters = [];
    var chaps = document.querySelectorAll('.wp-manga-chapter a');
    chaps.forEach((element) {
      chapters.add(new Item(
          name: element.text.trim(),
          url: element.attributes['href'] ?? '',
          read: false));
    });

    return new Manga(
        genres: genres,
        chapters: chapters,
        age: age,
        sinopsis: sinopsis,
        url: manga.url,
        title: manga.title,
        type: manga.type,
        color: manga.color,
        cover: cover);
  }

  Future<MangaImages> getPages(Item item) async {
    http.Response response = await http.get(
      Uri.parse(item.url),
    );

    var document = parse(response.body);
    String? previous =
        document.querySelector('.nav-previous a')!.attributes['href'];

    String? next;
    try {
      next = document.querySelector(".nav-next a")!.attributes['href'];
    } catch (e) {}

    List<String> pages = [];
    var page = document.querySelectorAll('#images_chapter img');

    page.forEach((element) {
      pages.add(element.attributes['data-src'] ?? '');
    });

    return new MangaImages(pages: pages, previous: previous, next: next);
  }

  Future<List<MangaItem>> getMangas(String url) async {
    print("totptotototo" + url);
    http.Response response = await http.get(
      Uri.parse(url),
    );

    var document = parse(response.body);

    var mangasHtml = document.getElementsByClassName('page-item-detail');

    String? next;
    try {
      next = document
              .querySelector('.pagination .page-item [rel="next"]')!
              .attributes['href'] ??
          null;
    } catch (e) {
      next = null;
    }
    print(next);
    List<MangaItem> mangaLocal = [];
    for (var item in mangasHtml) {
      var option = {
        "manhwa": "#81C784",
        "manhua": "#8D6E63",
        "manga": "#7986CB",
        "novela": "#E57373",
        "doujinshi": "#F6B952",
        "one_shot": "#F06292"
      };

      String type = item.getElementsByTagName('span').first.text;

      mangaLocal.add(MangaItem(
          title: item.querySelector(".manga-title-updated a")!.text,
          cover: item.getElementsByTagName('img').first.attributes['src'] ?? '',
          type: type,
          color: option[type.toLowerCase().trim()] ?? '',
          url: item.querySelector(".manga_biblioteca a")!.attributes['href'] ??
              '',
          next: next));
    }

    return mangaLocal;
  }

  Future<List<Item>> getCategories() async {
    http.Response response = await http.get(
      Uri.parse('https://leermanga.net/biblioteca'),
    );

    var document = parse(response.body);

    var generesHtml = document.querySelectorAll('.list-unstyled li a');
    List<Item> genres = [];
    for (var item in generesHtml) {
      String name = item.text;
      String url = item.attributes['href'] ?? '';

      genres.add(Item(
        name: name,
        url: url,
      ));
    }

    return genres;
  }
}
