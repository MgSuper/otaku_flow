import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:startup_launch/app/localization/locale_cubit.dart';
import 'package:startup_launch/app/routes/router.dart';
import 'package:startup_launch/app/theme/app_theme.dart';
import 'package:startup_launch/app/theme/theme_cubit.dart';
import 'package:startup_launch/core/config/app_config.dart';
import 'package:startup_launch/core/di/service_locator.dart';
import 'package:startup_launch/features/favorites/presentation/cubit/favorites_cubit.dart';
import 'package:startup_launch/features/reader_progress/presentation/cubit/reading_progress_cubit.dart';
import 'package:startup_launch/l10n/generated/app_localizations.dart';

class App extends StatelessWidget {
  const App({super.key, required this.showOnboardingFirst});

  final bool showOnboardingFirst;

  @override
  Widget build(BuildContext context) {
    final config = sl<AppConfig>();
    final GoRouter router = AppRouter.createRouter(
      showOnboardingFirst: showOnboardingFirst,
    );
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: sl<ThemeCubit>()),
        BlocProvider.value(value: sl<LocaleCubit>()),
        BlocProvider(create: (_) => sl<ReadingProgressCubit>()),
        BlocProvider(create: (_) => sl<FavoritesCubit>()),
      ],
      child: BlocBuilder<ThemeCubit, ThemeMode>(
        builder: (context, mode) {
          return BlocBuilder<LocaleCubit, Locale>(
            builder: (context, locale) {
              final Widget child = MaterialApp.router(
                title: config.appName,
                debugShowCheckedModeBanner: false,
                routerConfig: router,
                theme: AppTheme.light,
                darkTheme: AppTheme.dark,
                themeMode: mode,
                locale: locale,
                supportedLocales: AppLocalizations.supportedLocales,
                localizationsDelegates: AppLocalizations.localizationsDelegates,

                builder: (context, child) {
                  if (!config.isProd) {
                    return Stack(
                      children: [
                        child!,

                        SafeArea(
                          child: Align(
                            alignment: Alignment.topRight,
                            child: Padding(
                              padding: const EdgeInsets.all(12),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: config.bannerColor.withValues(
                                    alpha: 0.85,
                                  ),
                                  borderRadius: BorderRadius.circular(20),
                                  boxShadow: const [
                                    BoxShadow(
                                      blurRadius: 12,
                                      color: Colors.black26,
                                    ),
                                  ],
                                ),
                                child: Text(
                                  config.bannerLabel,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 1.2,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  }
                  return child!;
                },
              );

              return child;
            },
          );
        },
      ),
    );
  }
}
