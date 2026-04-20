import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class EventsListContent extends StatelessWidget {
  const EventsListContent({super.key});

  @override
  Widget build(BuildContext context) => ListView.builder(
    padding: const EdgeInsets.all(16),
    itemCount: 3, // TODO: Mock data count
    itemBuilder: (context, index) => EventCard(
      title: 'Event Name',
      posterName: 'Society Name',
      venue: 'S Block',
      startsAt: DateTime.now(),
      endsAt: DateTime.now(),
    ),
  );
}

class EventCard extends StatelessWidget {
  const EventCard({
    super.key,
    required this.title,
    required this.posterName,
    required this.venue,
    required this.startsAt,
    required this.endsAt,
  });

  final String title;
  final String posterName;
  final String venue;
  final DateTime startsAt;
  final DateTime endsAt;

  @override
  Widget build(BuildContext context) => Card(
    margin: const EdgeInsets.fromLTRB(4, 4, 4, 16),
    clipBehavior: .hardEdge,
    child: InkWell(
      onTap: () => debugPrint('Card tapped.'),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: .start,
          children: [
            const CircleAvatar(child: Icon(Icons.person)),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: .start,
                children: [
                  Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
                  Text(
                    posterName,
                    style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant, fontSize: 16),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.pin_drop),
                      const SizedBox(width: 4),
                      Text('$venue · ${DateFormat('d MMM, H:mm a').format(startsAt)}'),
                    ],
                  ),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward),
          ],
        ),
      ),
    ),
  );
}
