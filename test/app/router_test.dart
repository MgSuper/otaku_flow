import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:startup_launch/app/localization/locale_cubit.dart';

import 'package:startup_launch/app/routes/router.dart';
import 'package:startup_launch/app/theme/theme_cubit.dart';
import 'package:startup_launch/core/config/app_config.dart';
import 'package:startup_launch/core/config/environment.dart';
import 'package:startup_launch/core/di/service_locator.dart';
import 'package:startup_launch/features/onboarding/data/onboarding_storage.dart';
import 'package:startup_launch/l10n/generated/app_localizations.dart';

class FakeOnboardingStorage implements OnboardingStorage {
  @override
  Future<bool> isCompleted() async => true;

  @override
  Future<void> setCompleted() async {}
}

void main() {
  setUp(() async {
    SharedPreferences.setMockInitialValues({});

    await sl.reset();

    await setupLocator(AppConfig.from(Environment.dev));

    if (sl.isRegistered<OnboardingStorage>()) {
      sl.unregister<OnboardingStorage>();
    }

    sl.registerLazySingleton<OnboardingStorage>(FakeOnboardingStorage.new);
  });

  Widget buildTestable() {
    final router = AppRouter.createRouter(showOnboardingFirst: false);

    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: sl<ThemeCubit>()),
        BlocProvider.value(value: sl<LocaleCubit>()),
      ],
      child: MaterialApp.router(
        routerConfig: router,
        supportedLocales: AppLocalizations.supportedLocales,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
      ),
    );
  }

  testWidgets('home route loads', (tester) async {
    await tester.pumpWidget(buildTestable());

    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));

    expect(find.byKey(const Key('home_app_bar')), findsOneWidget);
  });

  testWidgets('go to settings works', (tester) async {
    await tester.pumpWidget(buildTestable());

    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));

    await tester.tap(find.byIcon(Icons.settings));

    await tester.pumpAndSettle();

    expect(find.text('Settings'), findsOneWidget);
  });
}
