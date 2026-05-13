class Society {
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
}
