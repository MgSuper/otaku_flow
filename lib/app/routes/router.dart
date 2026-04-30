import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:startup_launch/app/routes/app_routes.dart';
import 'package:startup_launch/core/di/service_locator.dart';
import 'package:startup_launch/features/home/presentation/bloc/home_bloc.dart';
import 'package:startup_launch/features/home/presentation/bloc/home_event.dart';
import 'package:startup_launch/features/home/presentation/home_screen.dart';
import 'package:startup_launch/features/library/presentation/screens/library_screen.dart';
import 'package:startup_launch/features/manga_detail/presentation/bloc/manga_detail_bloc.dart';
import 'package:startup_launch/features/manga_detail/presentation/bloc/manga_detail_event.dart';
import 'package:startup_launch/features/manga_detail/presentation/screens/manga_detail_screen.dart';
import 'package:startup_launch/features/onboarding/data/onboarding_storage.dart';
import 'package:startup_launch/features/onboarding/presentation/cubit/onboarding_cubit.dart';
import 'package:startup_launch/features/onboarding/presentation/onboarding_screen.dart';
import 'package:startup_launch/features/reader/presentation/bloc/reader_bloc.dart';
import 'package:startup_launch/features/reader/presentation/bloc/reader_event.dart';
import 'package:startup_launch/features/reader/presentation/screens/reader_screen.dart';
import 'package:startup_launch/features/search/presentation/bloc/search_bloc.dart';
import 'package:startup_launch/features/search/presentation/screens/search_screen.dart';
import 'package:startup_launch/features/settings/presentation/screens/settings_screen.dart';

final RouteObserver<PageRoute> routeObserver = RouteObserver<PageRoute>();

class AppRouter {
  static GoRouter createRouter({required bool showOnboardingFirst}) {
    return GoRouter(
      observers: [routeObserver],
      initialLocation: showOnboardingFirst
          ? AppRoutes.onboarding
          : AppRoutes.home,
      routes: <RouteBase>[
        GoRoute(
          path: AppRoutes.onboarding,
          builder: (context, state) {
            return BlocProvider(
              create: (_) => OnboardingCubit(storage: sl<OnboardingStorage>()),
              child: const OnboardingScreen(),
            );
          },
        ),

        GoRoute(
          path: AppRoutes.home,
          builder: (context, state) {
            return BlocProvider(
              // The Bloc is created at the Router level
              create: (_) => sl<HomeBloc>()..add(LoadHome()),
              child: const HomeScreen(),
            );
          },
        ),

        GoRoute(
          path: AppRoutes.settings,
          builder: (context, state) {
            return SettingsPage();
          },
        ),
        GoRoute(
          path: AppRoutes.search,
          builder: (context, state) {
            return BlocProvider(
              create: (context) => sl<SearchBloc>(),
              child: const SearchScreen(),
            );
          },
        ),
        GoRoute(
          path: '/manga/:id', // The ':id' is the key
          builder: (context, state) {
            // Extract the id from pathParameters
            final mangaId = state.pathParameters['id']!;
            final extra = state.extra as Map?;
            final page = extra?['page'] ?? 1;

            return BlocProvider(
              create: (context) =>
                  sl<MangaDetailBloc>()..add(LoadMangaDetail(mangaId, page)),
              child: const MangaDetailScreen(),
            );
          },
        ),

        GoRoute(
          path: '/reader/:id',
          builder: (context, state) {
            final id = state.pathParameters['id']!;

            debugPrint('ROUTER reader => id=$id');

            final extra = state.extra as Map?;

            final chapters = (extra?['chapters'] as List?) ?? [];

            final index = extra?['index'] ?? 0;

            final mangaId = extra?['mangaId'] ?? '';

            final mangaTitle = extra?['mangaTitle'] ?? '';

            final coverUrl = extra?['coverUrl'] ?? '';

            final hasNextPage = extra?['hasNextPage'] ?? false;
            final hasPrevPage = extra?['hasPrevPage'] ?? false;

            final currentPage = extra?['currentPage'] ?? 1;

            debugPrint('currentPage: $currentPage');

            return MultiBlocProvider(
              providers: [
                BlocProvider(
                  create: (_) => sl<ReaderBloc>()
                    ..add(
                      LoadReaderChapter(
                        chapterId: id,
                        chapters: chapters,
                        index: index,
                        hasNextPage: hasNextPage,
                        hasPrevPage: hasPrevPage,
                      ),
                    ),
                ),
                BlocProvider(
                  create: (context) =>
                      sl<MangaDetailBloc>()
                        ..add(ChangeChapterPage(currentPage)),
                ),
              ],
              child: ReaderScreen(
                mangaId: mangaId,
                mangaTitle: mangaTitle,
                coverUrl: coverUrl,
                chapterId: id,
                chapters: chapters,
                index: index,
                hasNextPage: hasNextPage,
                hasPrevPage: hasPrevPage,
                currentPage: currentPage,
              ),
            );
          },
        ),
        GoRoute(path: '/library', builder: (_, _) => const LibraryScreen()),
      ],
      errorBuilder: (context, state) => _ErrorScreen(error: state.error),
    );
  }
}

class _ErrorScreen extends StatelessWidget {
  const _ErrorScreen({this.error});

  final Exception? error;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Navigation error')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Text(
          error?.toString() ?? 'Unknown routing error',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ),
    );
  }
}
