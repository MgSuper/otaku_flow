import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:startup_launch/core/extensions/l10n.dart';
import 'package:startup_launch/features/home/presentation/bloc/home_bloc.dart';
import 'package:startup_launch/features/home/presentation/bloc/home_event.dart';
import 'package:startup_launch/features/home/presentation/bloc/home_state.dart';
import 'package:startup_launch/features/home/presentation/widgets/home_error.dart';
import 'package:startup_launch/features/home/presentation/widgets/home_loading.dart';
import 'package:startup_launch/features/home/presentation/widgets/home_section.dart';
import 'package:startup_launch/features/manga/domain/entities/manga.dart';
import 'package:startup_launch/features/reader/presentation/screens/widgets/continue_reading_card.dart';
import 'package:startup_launch/features/reader_progress/presentation/cubit/reading_progress_cubit.dart';
import 'package:startup_launch/features/reader_progress/presentation/cubit/reading_progress_state.dart';

const fakeManga = Manga(
  id: '0',
  title: 'Loading Manga Title',
  description: 'Loading description',
  status: 'ongoing',
  year: 2026,
  coverUrl: 'loading',
  genres: ['Action'],
);

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: Text(context.l10n.library),
        actions: [
          IconButton(
            onPressed: () {
              context.push('/search');
            },
            icon: Icon(Icons.search),
          ),
          IconButton(
            onPressed: () {
              context.push('/settings');
            },
            icon: Icon(Icons.settings),
          ),
        ],
      ),
      body: BlocBuilder<HomeBloc, HomeState>(
        builder: (context, state) {
          return AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: switch (state) {
              HomeLoading() => const HomeLoadingView(),
              HomeLoaded() => ListView(
                key: const ValueKey('loaded'),
                children: [
                  BlocBuilder<ReadingProgressCubit, ReadingProgressState>(
                    builder: (_, state) {
                      final progress = state.progress;

                      if (progress == null) {
                        return const SizedBox();
                      }

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            context.l10n.continueReading,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          const SizedBox(height: 8),

                          ContinueReadingCard(progress: progress),
                        ],
                      );
                    },
                  ),
                  HomeSection(
                    title: context.l10n.trending,
                    mangas: state.data.trending,
                  ),
                  HomeSection(
                    title: context.l10n.latest,
                    mangas: state.data.latest,
                  ),
                  HomeSection(
                    title: context.l10n.popular,
                    mangas: state.data.popular,
                  ),
                ],
              ),
              HomeError() => HomeErrorRetry(
                message: state.message,
                onRetry: () {
                  context.read<HomeBloc>().add(LoadHome());
                },
              ),
              _ => const SizedBox(),
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.favorite_outline),
        onPressed: () {
          context.push('/library');
        },
      ),
    );
  }
}
