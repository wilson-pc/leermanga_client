import 'package:floor/floor.dart';

@entity
class Favorites {
  @primaryKey
  final String id;
  final String title;
  final bool local;
  final String cover;
  final String type;
  final String url;
  final String color;
  final String? next;
  final String createat;

  Favorites(
      {required this.id,
      required this.title,
      required this.cover,
      required this.type,
      required this.local,
      required this.url,
      required this.color,
      required this.createat,
      this.next});
}
