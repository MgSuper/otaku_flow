import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ReaderChapterBottomBar extends StatelessWidget {
  final List<dynamic> chapters;
  final int index;
  final String mangaId;
  final String mangaTitle;
  final String coverUrl;
  final bool hasNextPage; // true if older chapters exist (Page 1 -> 2)
  final bool hasPrevPage; // true if newer chapters exist (Page 2 -> 1)
  final int currentPage;

  const ReaderChapterBottomBar({
    super.key,
    required this.chapters,
    required this.index,
    required this.mangaId,
    required this.mangaTitle,
    required this.coverUrl,
    required this.hasNextPage,
    required this.hasPrevPage,
    required this.currentPage,
  });

  @override
  Widget build(BuildContext context) {
    final bool hasData =
        chapters.isNotEmpty && index >= 0 && index < chapters.length;

    return SafeArea(
      top: false,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          border: const Border(top: BorderSide(color: Colors.white12)),
        ),
        child: hasData
            ? _buildNavigationRow(context)
            : _buildSimpleRow(context),
      ),
    );
  }

  Widget _buildNavigationRow(BuildContext context) {
    // index 0 is Newest in current list, chapters.length-1 is Oldest
    final bool isNewestInList = index == 0;
    final bool isOldestInList = index == chapters.length - 1;

    final currentChapter = chapters[index];
    final chapterLabel = currentChapter.title ?? 'Chapter ${index + 1}';
    final progressLabel = '${chapters.length - index} of ${chapters.length}';

    return Row(
      children: [
        // PREVIOUS BUTTON (Go to Older)
        IconButton.outlined(
          onPressed: isOldestInList ? null : () => _open(context, index + 1),
          icon: const Icon(Icons.arrow_back_ios_new, size: 20),
        ),

        Expanded(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                chapterLabel,
                style: const TextStyle(fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              Text(progressLabel, style: Theme.of(context).textTheme.bodySmall),
            ],
          ),
        ),

        // NEXT BUTTON (Go to Newer)
        IconButton.filled(
          onPressed: isNewestInList
              ? () {
                  // Instead of a bottom sheet, we just go back with a signal
                  // to potentially change the page for the user on the detail screen
                  Navigator.of(
                    context,
                  ).pop(hasPrevPage ? currentPage - 1 : null);
                }
              : () => _open(context, index - 1),
          icon: Icon(
            isNewestInList ? Icons.exit_to_app : Icons.arrow_forward_ios,
            size: 20,
          ),
        ),
      ],
    );
  }

  Widget _buildSimpleRow(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        TextButton.icon(
          onPressed: () => context.pop(),
          icon: const Icon(Icons.menu_book),
          label: const Text('VIEW CHAPTER LIST'),
        ),
      ],
    );
  }

  void _open(BuildContext context, int newIndex) {
    final chapter = chapters[newIndex];
    context.pushReplacement(
      '/reader/${chapter.id}',
      extra: {
        'chapters': chapters,
        'index': newIndex,
        'mangaId': mangaId,
        'mangaTitle': mangaTitle,
        'coverUrl': coverUrl,
        'hasNextPage': hasNextPage,
        'hasPrevPage': hasPrevPage,
      },
    );
  }
}
