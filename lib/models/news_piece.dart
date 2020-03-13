class NewsPiece {
  final String source;

  final String url;
  final String title;
  final String description;
  final String thumbnailUrl;

  final DateTime published;
  const NewsPiece({
    this.source,

    this.url,
    this.title,
    this.description,
    this.thumbnailUrl,

    this.published
  });
}