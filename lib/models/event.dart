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

  const Event({
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

  factory Event.fromMap(Map<String, dynamic> map) => Event(
    id: map['id'],
    societyId: map['societyId'],
    societyName: map['societyName'],
    title: map['title'],
    description: map['description'],
    start: map['start'],
    end: map['end'],
    location: map['location'],
    imageUrl: map['imageUrl'],
  );

  Map<String, dynamic> toMap() => {
    'id': id,
    'societyId': societyId,
    'societyName': societyName,
    'title': title,
    'description': description,
    'start': start,
    'end': end,
    'location': location,
    'imageUrl': imageUrl,
  };

  Event copyWith({
    String? id,
    String? societyId,
    String? societyName,
    String? title,
    String? description,
    DateTime? start,
    DateTime? end,
    String? location,
    String? imageUrl,
  }) => Event(
    id: id ?? this.id,
    societyId: societyId ?? this.societyId,
    societyName: societyName ?? this.societyName,
    title: title ?? this.title,
    description: description ?? this.description,
    start: start ?? this.start,
    end: end ?? this.end,
    location: location ?? this.location,
    imageUrl: imageUrl ?? this.imageUrl,
  );
}
