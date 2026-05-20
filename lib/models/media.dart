import 'package:equatable/equatable.dart';

class Media extends Equatable {
  final String url;
  final MediaType type;

  const Media({required this.url, required this.type});

  factory Media.fromMap(Map<String, dynamic> map) => Media(url: map['url'], type: map['type']);

  Map<String, dynamic> toMap() => {'url': url, 'type': type};

  Media copyWith({String? url, MediaType? type}) => Media(url: url ?? this.url, type: type ?? this.type);

  @override
  List<Object?> get props => [url];
}

enum MediaType {
  image,
  video, // TODO: future
}
