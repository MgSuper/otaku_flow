import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:startup_launch/core/di/service_locator.dart';
import 'package:startup_launch/features/manga_detail/domain/entities/manga_detail.dart';
import 'package:startup_launch/features/manga_detail/domain/usecases/get_manga_detail_usecase.dart';
import 'package:startup_launch/features/reader_progress/domain/entities/reading_progress.dart';

class ContinueReadingCard extends StatelessWidget {
  final ReadingProgress progress;

  const ContinueReadingCard({super.key, required this.progress});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(16),
      child: ListTile(
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.network(progress.coverUrl, width: 50, fit: BoxFit.cover),
        ),
        title: Text(progress.mangaTitle),
        subtitle: Text(progress.chapterTitle),
        trailing: const Icon(Icons.play_arrow),
        onTap: () async {
          try {
            // 1. Fetch the data using the PAGE stored in progress
            // Note: If your progress doesn't have .page yet, you'll need to add it
            // to your ReadingProgress entity/model.
            final targetPage = progress.page;

            final result = await sl<GetMangaDetailUseCase>().call(
              mangaId: progress.mangaId,
              page: targetPage,
            );

            final mangaDetail = result as MangaDetail;
            final allChapters = mangaDetail.chapters;

            final currentIndex = allChapters.indexWhere(
              (c) => c.id == progress.chapterId,
            );

            if (context.mounted) {
              // context.read<MangaDetailBloc>().add(
              //   ChangeChapterPage(targetPage),
              // );
              // 2. Add Detail Screen to stack
              context.push(
                '/manga/${progress.mangaId}',
                extra: {'page': targetPage},
              );

              debugPrint('progress.page ${progress.page}');

              // 3. Push Reader with CORRECT Pagination Flags
              context.push(
                '/reader/${progress.chapterId}',
                extra: {
                  'chapters': allChapters,
                  'index': currentIndex != -1 ? currentIndex : 0,
                  'mangaId': progress.mangaId,
                  'mangaTitle': progress.mangaTitle,
                  'coverUrl': progress.coverUrl,
                  // THESE ARE CRITICAL FOR THE BOTTOM BAR
                  'hasNextPage': targetPage < mangaDetail.totalPages,
                  'hasPrevPage': targetPage > 1,
                  'currentPage': progress.page,
                },
              );
            }
          } catch (e) {
            debugPrint('Error loading continue reading context: $e');
            if (context.mounted) {
              context.push(
                '/reader/${progress.chapterId}',
                extra: {
                  'chapters': [],
                  'index': 0,
                  'mangaId': progress.mangaId,
                  'mangaTitle': progress.mangaTitle,
                  'coverUrl': progress.coverUrl,
                  'hasNextPage': false,
                  'hasPrevPage': false,
                },
              );
            }
          }
        },
      ),
    );
  }
}
