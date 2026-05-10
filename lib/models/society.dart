class Society {
  final String id;

  final String name;
  final String? imageUrl;
  final String? bio;

  final bool isFollowed;
  final bool isMember;

  const Society({
    required this.id,
    required this.name,
    this.imageUrl,
    this.bio,
    required this.isFollowed,
    required this.isMember,
  });
}
