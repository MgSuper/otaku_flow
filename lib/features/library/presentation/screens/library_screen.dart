import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:startup_launch/core/extensions/l10n.dart';
import 'package:startup_launch/features/favorites/domain/entities/favorite_manga.dart';
import 'package:startup_launch/features/favorites/presentation/cubit/favorites_cubit.dart';
import 'package:startup_launch/features/reader/presentation/screens/widgets/continue_reading_card.dart';
import 'package:startup_launch/features/reader_progress/presentation/cubit/reading_progress_cubit.dart';
import 'package:startup_launch/features/reader_progress/presentation/cubit/reading_progress_state.dart';

class LibraryScreen extends StatelessWidget {
  const LibraryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(centerTitle: false, title: Text(context.l10n.library)),
      body: ListView(
        children: [
          _buildContinueReading(context),

          const SizedBox(height: 24),

          _buildFavorites(context),

          // const SizedBox(height: 24),

          // _buildDownloads(),
        ],
      ),
    );
  }

  Widget _buildContinueReading(BuildContext context) {
    return BlocBuilder<ReadingProgressCubit, ReadingProgressState>(
      builder: (_, state) {
        final progress = state.progress;

        if (progress == null) {
          return const SizedBox();
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18.0),
              child: Text(
                context.l10n.continueReading,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),

            const SizedBox(height: 12),

            ContinueReadingCard(progress: progress),
          ],
        );
      },
    );
  }

  Widget _buildFavorites(BuildContext context) {
    return BlocBuilder<FavoritesCubit, List<FavoriteManga>>(
      builder: (_, items) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                context.l10n.favorites,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 12),

              items.isEmpty
                  ? Text(context.l10n.noFavoritesYet)
                  : GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: items.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            childAspectRatio: .58,
                            crossAxisSpacing: 12,
                            mainAxisSpacing: 12,
                          ),
                      itemBuilder: (_, index) {
                        final item = items[index];

                        return InkWell(
                          onTap: () {
                            context.push('/manga/${item.id}');
                          },
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: Image.network(
                                    item.coverUrl,
                                    fit: BoxFit.cover,
                                    width: double.infinity,
                                  ),
                                ),
                              ),

                              const SizedBox(height: 6),

                              Text(
                                item.title,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        );
                      },
                    ),
            ],
          ),
        );
      },
    );
  }

  // ignore: unused_element
  Widget _buildDownloads() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        Text(
          'Downloads',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),

        SizedBox(height: 12),

        Card(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Text('Offline reading coming soon.'),
          ),
        ),
      ],
    );
  }
}
