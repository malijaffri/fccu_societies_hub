class UserModel {
  final String id;

  final String name;
  final String? imageUrl;
  final String? description;
  final DateTime createdAt;

  const UserModel({required this.id, required this.name, this.imageUrl, this.description, required this.createdAt});

  factory UserModel.fromMap(Map<String, dynamic> map) => UserModel(
    id: map['id'],
    name: map['name'],
    imageUrl: map['imageUrl'],
    description: map['description'],
    createdAt: map['createdAt'],
  );

  Map<String, dynamic> toMap() => {
    'id': id,
    'name': name,
    'imageUrl': imageUrl,
    'description': description,
    'createdAt': createdAt,
  };

  UserModel copyWith({String? id, String? name, String? imageUrl, String? description, DateTime? createdAt}) =>
      UserModel(
        id: id ?? this.id,
        name: name ?? this.name,
        imageUrl: imageUrl ?? this.imageUrl,
        description: description ?? this.description,
        createdAt: createdAt ?? this.createdAt,
      );
}
