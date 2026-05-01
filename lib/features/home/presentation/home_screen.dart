import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:startup_launch/core/config/app_config.dart';
import 'package:startup_launch/core/di/service_locator.dart';
import 'package:startup_launch/core/extensions/l10n.dart';
import 'package:startup_launch/features/home/presentation/bloc/home_bloc.dart';
import 'package:startup_launch/features/home/presentation/bloc/home_event.dart';
import 'package:startup_launch/features/home/presentation/bloc/home_state.dart';
import 'package:startup_launch/features/home/presentation/widgets/dev_badge.dart';
import 'package:startup_launch/features/home/presentation/widgets/home_error.dart';
import 'package:startup_launch/features/home/presentation/widgets/home_loading.dart';
import 'package:startup_launch/features/home/presentation/widgets/home_section.dart';
import 'package:startup_launch/features/reader/presentation/screens/widgets/continue_reading_card.dart';
import 'package:startup_launch/features/reader_progress/presentation/cubit/reading_progress_cubit.dart';
import 'package:startup_launch/features/reader_progress/presentation/cubit/reading_progress_state.dart';
import 'package:startup_launch/l10n/generated/app_localizations.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  final config = sl<AppConfig>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        key: const Key('home_app_bar'),
        centerTitle: false,
        title: _PremiumGreetingHeader(),
        actions: [
          if (!config.isProd)
            DevBadge(label: config.bannerLabel, color: config.bannerColor),
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
                  const SizedBox(height: 4),
                  BlocBuilder<ReadingProgressCubit, ReadingProgressState>(
                    builder: (_, state) {
                      final progress = state.progress;

                      if (progress == null) {
                        return const SizedBox();
                      }

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 18.0,
                            ),
                            child: Text(
                              context.l10n.continueReading,
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
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

class _PremiumGreetingHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    final greeting = _getGreeting(l10n);

    final quote = _getDailyQuote(l10n);

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 600),
      transitionBuilder: (child, animation) {
        return FadeTransition(opacity: animation, child: child);
      },
      child: Column(
        key: ValueKey(greeting + quote),
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            greeting,
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 2),
          Text(quote, style: Theme.of(context).textTheme.bodySmall),
        ],
      ),
    );
  }

  String _getGreeting(AppLocalizations l10n) {
    final hour = DateTime.now().hour;

    if (hour >= 5 && hour < 12) {
      return l10n.goodMorning;
    }

    if (hour >= 12 && hour < 17) {
      return l10n.goodAfternoon;
    }

    if (hour >= 17 && hour < 22) {
      return l10n.goodEvening;
    }

    return l10n.goodNight;
  }

  String _getDailyQuote(AppLocalizations l10n) {
    final day = DateTime.now().day;

    final quotes = [
      l10n.quote1,
      l10n.quote2,
      l10n.quote3,
      l10n.quote4,
      l10n.quote5,
    ];

    return quotes[day % quotes.length];
  }
}
