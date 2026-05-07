class Media {
  final String url;
  final MediaType type;

  Media({required this.url, required this.type});
}

enum MediaType {
  image,
  video, // TODO: future
}
