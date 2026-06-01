import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class Society extends Equatable {
  final String id;

  final String name;
  final String? imageUrl;
  final String? description;

  final int followerCount;
  final int memberCount;

  // These are NOT stored in the Firestore document.
  // They are computed by the repository from the follows/memberships collections.
  final bool isFollowed;
  final bool isMember;

  final DateTime createdAt;

  const Society({
    required this.id,
    required this.name,
    this.imageUrl,
    this.description,
    required this.followerCount,
    required this.memberCount,
    required this.isFollowed,
    required this.isMember,
    required this.createdAt,
  });

  factory Society.fromMap(Map<String, dynamic> map) => Society(
    id: map['id'] as String,
    name: map['name'] as String,
    imageUrl: map['imageUrl'] as String?,
    description: map['description'] as String?,
    followerCount: map['followerCount'] as int? ?? 0,
    memberCount: map['memberCount'] as int? ?? 0,
    isFollowed: false,
    isMember: false,
    createdAt: (map['createdAt'] as Timestamp).toDate(),
  );

  Map<String, dynamic> toMap() => {
    'id': id,
    'name': name,
    'imageUrl': imageUrl,
    'description': description,
    'followerCount': followerCount,
    'memberCount': memberCount,
    'createdAt': Timestamp.fromDate(createdAt),
  };

  Society copyWith({
    String? id,
    DateTime? createdAt,
    String? name,
    String? imageUrl,
    String? description,
    int? followerCount,
    int? memberCount,
    bool? isFollowed,
    bool? isMember,
  }) => Society(
    id: id ?? this.id,
    createdAt: createdAt ?? this.createdAt,
    name: name ?? this.name,
    imageUrl: imageUrl ?? this.imageUrl,
    description: description ?? this.description,
    followerCount: followerCount ?? this.followerCount,
    memberCount: memberCount ?? this.memberCount,
    isFollowed: isFollowed ?? this.isFollowed,
    isMember: isMember ?? this.isMember,
  );

  @override
  List<Object?> get props => [id];
}
