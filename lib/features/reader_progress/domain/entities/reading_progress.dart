class ReadingProgress {
  final String mangaId;
  final String mangaTitle;
  final String coverUrl;

  final String chapterId;
  final String chapterTitle;

  final double offset;

  final int pageIndex;
  final int page;

  const ReadingProgress({
    required this.mangaId,
    required this.mangaTitle,
    required this.coverUrl,
    required this.chapterId,
    required this.chapterTitle,
    required this.offset,
    required this.pageIndex,
    required this.page,
  });
}
