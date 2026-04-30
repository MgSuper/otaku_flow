import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:startup_launch/core/extensions/l10n.dart';
import 'package:startup_launch/features/favorites/domain/entities/favorite_manga.dart';
import 'package:startup_launch/features/favorites/presentation/cubit/favorites_cubit.dart';
import 'package:startup_launch/features/manga_detail/presentation/bloc/manga_detail_bloc.dart';
import 'package:startup_launch/features/manga_detail/presentation/bloc/manga_detail_event.dart';
import 'package:startup_launch/features/manga_detail/presentation/bloc/manga_detail_state.dart';
import 'package:startup_launch/features/manga_detail/presentation/screens/widgets/chapter_pagination.dart';
import 'package:startup_launch/features/manga_detail/presentation/screens/widgets/manga_detail_loading_view.dart';

class MangaDetailScreen extends StatelessWidget {
  const MangaDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<MangaDetailBloc, MangaDetailState>(
        builder: (_, state) {
          if (state is MangaDetailLoading) {
            return const MangaDetailLoadingView();
          }

          if (state is MangaDetailError) {
            return Center(child: Text(state.message));
          }

          final stateLoaded = state as MangaDetailLoaded;

          // final bool hasNextPage =
          //     stateLoaded.currentPage < stateLoaded.totalPages;
          // final bool hasPrevPage = stateLoaded.currentPage > 1;

          final manga = stateLoaded.manga;

          final chapters = stateLoaded.chapters;

          return CustomScrollView(
            slivers: [
              SliverAppBar(
                expandedHeight: 360,
                pinned: true,
                flexibleSpace: FlexibleSpaceBar(
                  background: Stack(
                    fit: StackFit.expand,
                    children: [
                      Image.network(manga.coverUrl, fit: BoxFit.cover),

                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.black.withValues(alpha: 0.2),
                              Colors.black.withValues(alpha: 0.9),
                            ],
                          ),
                        ),
                      ),

                      Align(
                        alignment: Alignment.bottomLeft,
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(14),
                                child: Image.network(
                                  manga.coverUrl,
                                  height: 160,
                                ),
                              ),

                              const SizedBox(width: 16),

                              Expanded(
                                child: Text(
                                  manga.title,
                                  maxLines: 3,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Skeletonizer(
                        enabled: state.loadingChapters,
                        child: Row(
                          children: [
                            _chip(context.l10n.manga),
                            const SizedBox(width: 8),
                            _chip('${chapters.length}  ${context.l10n.loaded}'),
                            const SizedBox(width: 8),
                            _chip(
                              '${stateLoaded.totalPages} ${context.l10n.pages}',
                            ),
                            const Spacer(),
                            BlocBuilder<FavoritesCubit, List<FavoriteManga>>(
                              builder: (_, state) {
                                final isFav = context
                                    .read<FavoritesCubit>()
                                    .isFavorite(manga.id);

                                return IconButton(
                                  icon: Icon(
                                    isFav
                                        ? Icons.favorite
                                        : Icons.favorite_border,
                                    color: isFav ? Colors.red : Colors.grey,
                                  ),
                                  onPressed: () {
                                    context.read<FavoritesCubit>().toggle(
                                      FavoriteManga(
                                        id: manga.id,
                                        title: manga.title,
                                        coverUrl: manga.coverUrl,
                                      ),
                                    );
                                  },
                                );
                              },
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 16),

                      const SizedBox(height: 20),

                      Skeletonizer(
                        enabled: state.loadingChapters,
                        child: Text(
                          context.l10n.summary,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),

                      const SizedBox(height: 8),

                      Skeletonizer(
                        enabled: state.loadingChapters,
                        child: Text(
                          manga.description,
                          maxLines: 5,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),

                      const SizedBox(height: 24),

                      Skeletonizer(
                        enabled: state.loadingChapters,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              context.l10n.chapters,
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),

                            Text(
                              '${context.l10n.page} ${state.currentPage}/${stateLoaded.totalPages}',
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 12),
                    ],
                  ),
                ),
              ),

              SliverToBoxAdapter(
                child: Skeletonizer(
                  enabled: state.loadingChapters,
                  child: ChapterPagination(
                    currentPage: state.currentPage,
                    totalPages: stateLoaded.totalPages,
                    onPageChanged: (page) {
                      context.read<MangaDetailBloc>().add(
                        ChangeChapterPage(page),
                      );
                    },
                  ),
                ),
              ),
              SliverList(
                delegate: SliverChildBuilderDelegate((context, index) {
                  final c = chapters[index];

                  return Skeletonizer(
                    enabled: state.loadingChapters,
                    child: Card(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 6,
                      ),
                      child: ListTile(
                        onTap: () async {
                          _openReader(context, c, index, stateLoaded);
                        },
                        title: Text('${context.l10n.chapter} ${c.chapter}'),
                        subtitle: Text(c.title),
                        trailing: const Icon(Icons.chevron_right),
                      ),
                    ),
                  );
                }, childCount: chapters.length),
              ),

              SliverToBoxAdapter(
                child: Skeletonizer(
                  enabled: state.loadingChapters,
                  child: ChapterPagination(
                    currentPage: state.currentPage,
                    totalPages: stateLoaded.totalPages,
                    onPageChanged: state.loadingChapters
                        ? null
                        : (page) {
                            context.read<MangaDetailBloc>().add(
                              ChangeChapterPage(page),
                            );
                          },
                  ),
                ),
              ),

              const SliverToBoxAdapter(child: SizedBox(height: 30)),
            ],
          );
        },
      ),
    );
  }

  Widget _chip(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white10,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Text(text),
    );
  }

  void _openReader(
    BuildContext context,
    dynamic chapter,
    int index,
    MangaDetailLoaded state,
  ) async {
    final result = await context.push(
      '/reader/${chapter.id}',
      extra: {
        'chapters': state.chapters,
        'index': index,
        'mangaId': state.manga.id,
        'mangaTitle': state.manga.title,
        'coverUrl': state.manga.coverUrl,
        'hasNextPage': state.currentPage < state.totalPages,
        'hasPrevPage': state.currentPage > 1,
        'currentPage': state.currentPage, // <--- Passing the current page
      },
    );

    if (result is int && context.mounted) {
      // If the reader returns a page number, just switch the page in the UI
      context.read<MangaDetailBloc>().add(ChangeChapterPage(result));
    }
  }
}
