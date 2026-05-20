import 'package:fccu_societies_hub/models/user_model.dart';

final mockUsers = List.generate(
  5,
  (i) => UserModel(
    id: '$i',
    name: 'User $i',
    imageUrl: i % 2 == 0 ? 'https://placehold.co/600x600.jpg' : null,
    description: 'Description of User $i\n\nWith newlines. **bold**. _italic_.',
    createdAt: .now().subtract(.new(hours: i * 12)),
  ),
)..sort((a, b) => a.createdAt.compareTo(b.createdAt));
