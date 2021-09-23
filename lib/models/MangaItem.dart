class MangaItem {
  final String title;
  final String cover;
  final String type;
  final String url;
  final String color;
  final String? next;

  MangaItem(
      {required this.title,
      required this.cover,
      required this.type,
      required this.url,
      required this.color,
      this.next});
}
