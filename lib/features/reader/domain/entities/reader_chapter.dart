class ReaderChapter {
  final String chapterId;
  final String title;
  final List<String> imageUrls;
  final List<dynamic>? mangaChapters;

  const ReaderChapter({
    required this.chapterId,
    required this.title,
    required this.imageUrls,
    this.mangaChapters,
  });
}
