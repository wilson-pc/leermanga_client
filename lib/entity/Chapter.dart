import 'package:floor/floor.dart';

@entity
class Chapter {
  @primaryKey
  final String id;
  final bool local;
  final String name;
  final String url;
  final String urlmanga;
  final String manga;
  final String createat;

  Chapter(
      {required this.id,
      required this.local,
      required this.createat,
      required this.name,
      required this.url,
      required this.urlmanga,
      required this.manga});
}
