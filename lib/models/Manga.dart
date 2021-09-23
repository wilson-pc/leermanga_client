import 'package:leermanga_client/models/MangaItem.dart';

class Manga extends MangaItem {
  final String age;
  final String sinopsis;
  final List<Item> genres;
  final List<Item> chapters;

  Manga(
      {required title,
      required cover,
      required type,
      required url,
      required color,
      required this.genres,
      required this.chapters,
      required this.age,
      required this.sinopsis})
      : super(title: title, cover: cover, type: type, url: url, color: color);
}

class Item {
  final String name;
  final String url;
  bool? read;
  Item({required this.name, required this.url, this.read});
}
