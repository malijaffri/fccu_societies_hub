import 'package:fccu_societies_hub/mock/mock_societies.dart';
import 'package:fccu_societies_hub/models/event.dart';

final mockEvents =
    mockSocieties
        .map(
          (society) => List.generate(
            5,
            (i) => Event(
              id: '${society.id}_$i',
              societyId: society.id,
              societyName: society.name,
              title: 'Event ${society.id}.$i',
              description: 'Description of Event ${society.id}.$i\n\nWith newlines. **bold**. _italic_.',
              start: .now().add(.new(hours: i * 12 - 24)),
              end: .now().add(.new(hours: i * 12 - 12)),
              location: i % 2 == 0 ? 'Building $i' : null,
              imageUrl: i % 3 == 0 ? 'https://placehold.co/600x600.jpg' : null,
            ),
          ),
        )
        .expand((i) => i)
        .toList()
      ..sort((a, b) => a.start.compareTo(b.start));
