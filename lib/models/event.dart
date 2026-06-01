import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class Event extends Equatable {
  final String id;

  final String societyId;
  final String societyName;

  final String title;
  final String description;

  final DateTime start;
  final DateTime? end;

  final String? location;

  final String? imageUrl;

  final int rsvpCount;
  // Computed by repository — not stored in the document.
  final bool isRsvped;

  final DateTime createdAt;

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
    this.rsvpCount = 0,
    this.isRsvped = false,
    required this.createdAt,
  });

  factory Event.fromMap(Map<String, dynamic> map) => Event(
    id: map['id'] as String,
    societyId: map['societyId'] as String,
    societyName: map['societyName'] as String,
    title: map['title'] as String,
    description: map['description'] as String,
    start: (map['start'] as Timestamp).toDate(),
    end: map['end'] != null ? (map['end'] as Timestamp).toDate() : null,
    location: map['location'] as String?,
    imageUrl: map['imageUrl'] as String?,
    rsvpCount: map['rsvpCount'] as int? ?? 0,
    createdAt: (map['createdAt'] as Timestamp).toDate(),
  );

  Map<String, dynamic> toMap() => {
    'id': id,
    'societyId': societyId,
    'societyName': societyName,
    'title': title,
    'description': description,
    'start': Timestamp.fromDate(start),
    'end': end != null ? Timestamp.fromDate(end!) : null,
    'location': location,
    'imageUrl': imageUrl,
    'rsvpCount': rsvpCount,
    'createdAt': Timestamp.fromDate(createdAt),
  };

  Event copyWith({
    String? id,
    DateTime? createdAt,
    String? societyId,
    String? societyName,
    String? title,
    String? description,
    DateTime? start,
    DateTime? end,
    String? location,
    String? imageUrl,
    int? rsvpCount,
    bool? isRsvped,
  }) => Event(
    id: id ?? this.id,
    createdAt: createdAt ?? this.createdAt,
    societyId: societyId ?? this.societyId,
    societyName: societyName ?? this.societyName,
    title: title ?? this.title,
    description: description ?? this.description,
    start: start ?? this.start,
    end: end ?? this.end,
    location: location ?? this.location,
    imageUrl: imageUrl ?? this.imageUrl,
    rsvpCount: rsvpCount ?? this.rsvpCount,
    isRsvped: isRsvped ?? this.isRsvped,
  );

  @override
  List<Object?> get props => [id];
}
