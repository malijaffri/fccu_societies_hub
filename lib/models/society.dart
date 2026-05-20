import 'package:equatable/equatable.dart';

class Society extends Equatable {
  final String id;

  final String name;
  final String? imageUrl;
  final String? description;

  final int followerCount;
  final int memberCount;
  final bool isFollowed;
  final bool isMember;

  const Society({
    required this.id,
    required this.name,
    this.imageUrl,
    this.description,
    required this.followerCount,
    required this.memberCount,
    required this.isFollowed,
    required this.isMember,
  });

  factory Society.fromMap(Map<String, dynamic> map) => Society(
    id: map['id'],
    name: map['name'],
    imageUrl: map['imageUrl'],
    description: map['description'],
    followerCount: map['followerCount'],
    memberCount: map['memberCount'],
    isFollowed: map['isFollowed'],
    isMember: map['isMember'],
  );

  Map<String, dynamic> toMap() => {
    'id': id,
    'name': name,
    'imageUrl': imageUrl,
    'description': description,
    'followerCount': followerCount,
    'memberCount': memberCount,
    'isFollowed': isFollowed,
    'isMember': isMember,
  };

  Society copyWith({
    String? id,
    String? name,
    String? imageUrl,
    String? description,
    int? followerCount,
    int? memberCount,
    bool? isFollowed,
    bool? isMember,
  }) => Society(
    id: id ?? this.id,
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
