import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class Society extends Equatable {
  final String id;

  final String name;
  final String? imageUrl;
  final String? description;

  final List<String> followerIds;
  final List<String> memberIds;
  final int followerCount;
  final int memberCount;
  final bool isFollowed;
  final bool isMember;

  final DateTime createdAt;

  const Society({
    required this.id,
    required this.name,
    this.imageUrl,
    this.description,
    required this.followerIds,
    required this.memberIds,
    required this.followerCount,
    required this.memberCount,
    required this.isFollowed,
    required this.isMember,
    required this.createdAt,
  });

  factory Society.fromMap(Map<String, dynamic> map, {String? currentUserId}) {
    final followerIds = List<String>.from(map['followerIds'] ?? []);
    final memberIds = List<String>.from(map['memberIds'] ?? []);
    return Society(
      id: map['id'] as String,
      name: map['name'] as String,
      imageUrl: map['imageUrl'] as String?,
      description: map['description'] as String?,
      followerIds: followerIds,
      memberIds: memberIds,
      followerCount: followerIds.length,
      memberCount: memberIds.length,
      isFollowed: currentUserId != null && followerIds.contains(currentUserId),
      isMember: currentUserId != null && memberIds.contains(currentUserId),
      createdAt: (map['createdAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toMap() => {
    'id': id,
    'name': name,
    'imageUrl': imageUrl,
    'description': description,
    'followerIds': followerIds,
    'memberIds': memberIds,
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
    List<String>? followerIds,
    List<String>? memberIds,
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
    followerIds: followerIds ?? this.followerIds,
    memberIds: memberIds ?? this.memberIds,
    followerCount: followerCount ?? this.followerCount,
    memberCount: memberCount ?? this.memberCount,
    isFollowed: isFollowed ?? this.isFollowed,
    isMember: isMember ?? this.isMember,
  );

  @override
  List<Object?> get props => [id];
}
