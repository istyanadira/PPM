
class EventItem {
  final String id;
  final String title;
  final String description;
  final String category;
  final String date;
  final String location;
  final int price;
  final int quota;
  final String imageUrl;

  const EventItem({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.date,
    required this.location,
    required this.price,
    required this.quota,
    required this.imageUrl,
  });
}
