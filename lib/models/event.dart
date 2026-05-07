class Event {
  final String id;

  final String societyId;
  final String societyName;

  final String title;
  final String description;

  final DateTime start;
  final DateTime? end;

  final String? location;

  final String? imageUrl;

  Event({
    required this.id,
    required this.societyId,
    required this.societyName,
    required this.title,
    required this.description,
    required this.start,
    this.end,
    this.location,
    this.imageUrl,
  });
}
