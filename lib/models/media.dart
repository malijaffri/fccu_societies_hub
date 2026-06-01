import 'package:equatable/equatable.dart';

class Media extends Equatable {
  final String url;
  final MediaType type;

  const Media({required this.url, required this.type});

  factory Media.fromMap(Map<String, dynamic> map) => Media(
    url: map['url'] as String,
    type: MediaType.values.byName(map['type'] as String),
  );

  Map<String, dynamic> toMap() => {'url': url, 'type': type.name};

  Media copyWith({String? url, MediaType? type}) => Media(url: url ?? this.url, type: type ?? this.type);

  @override
  List<Object?> get props => [url];
}

enum MediaType {
  image,
  video, // TODO: future
}
