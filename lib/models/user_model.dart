import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class UserModel extends Equatable {
  final String id;

  final String name;

  final String email;

  final String? avatarUrl;

  final String? description;

  final DateTime createdAt;

  const UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.createdAt,
    this.avatarUrl,
    this.description,
  });

  factory UserModel.fromMap(Map<String, dynamic> map) => UserModel(
    id: map['id'],
    name: map['name'],
    email: map['email'],
    avatarUrl: map['avatarUrl'],
    createdAt: (map['createdAt'] as Timestamp).toDate(),
    description: map['description'],
  );

  Map<String, dynamic> toMap() => {
    'id': id,
    'name': name,
    'email': email,
    'avatarUrl': avatarUrl,
    'description': description,
    'createdAt': Timestamp.fromDate(createdAt),
  };

  UserModel copyWith({
    String? id,
    DateTime? createdAt,
    String? name,
    String? email,
    String? avatarUrl,
    String? description,
  }) => UserModel(
    id: id ?? this.id,
    createdAt: createdAt ?? this.createdAt,
    name: name ?? this.name,
    email: email ?? this.email,
    avatarUrl: avatarUrl ?? this.avatarUrl,
    description: description ?? this.description,
  );

  @override
  List<Object?> get props => [id];
}
