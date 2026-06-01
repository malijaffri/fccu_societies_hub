import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:uuid/uuid.dart';

class StorageService {
  final _storage = FirebaseStorage.instance;

  final Uuid _uuid = Uuid();

  Future<String> uploadPostImage(File file) async {
    final name = _uuid.v7();
    final ref = _storage.ref().child('post_images/$name.jpg');
    await ref.putFile(file);
    return ref.getDownloadURL();
  }

  Future<String> uploadAvatarImage(File file) async {
    final name = _uuid.v7();
    final ref = _storage.ref().child('avatars/$name.jpg');
    await ref.putFile(file);
    return ref.getDownloadURL();
  }
}
