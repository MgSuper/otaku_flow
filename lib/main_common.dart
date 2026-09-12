import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:startup_launch/app/app.dart';
import 'package:startup_launch/app/localization/locale_cubit.dart';
import 'package:startup_launch/core/config/app_config.dart';
import 'package:startup_launch/core/config/environment.dart';
import 'package:startup_launch/core/di/service_locator.dart';
import 'package:startup_launch/core/utils/app_bloc_observer.dart';
import 'package:startup_launch/features/onboarding/data/onboarding_storage.dart';
import 'package:startup_launch/firebase_options.dart';

bool get _supportsFirebase {
  if (kIsWeb) return true;
  return switch (defaultTargetPlatform) {
    TargetPlatform.android ||
    TargetPlatform.iOS ||
    TargetPlatform.macOS ||
    TargetPlatform.windows => true,
    _ => false,
  };
}

bool get _supportsCrashlytics {
  if (kIsWeb) return false;
  return switch (defaultTargetPlatform) {
    TargetPlatform.android ||
    TargetPlatform.iOS ||
    TargetPlatform.macOS => true,
    _ => false,
  };
}

Future<void> bootstrap(Environment env) async {
  final widgetsBinding = WidgetsFlutterBinding.ensureInitialized();

  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  if (_supportsFirebase) {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }

  if (_supportsCrashlytics) {
    FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;
    PlatformDispatcher.instance.onError = (error, stack) {
      FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
      return true;
    };
  }

  final config = AppConfig.from(env);

  await setupLocator(config);
  await sl.allReady();

  await sl<LocaleCubit>().init();

  Bloc.observer = AppBlocObserver();

  final onboardingCompleted = await sl<OnboardingStorage>().isCompleted();

  runApp(App(showOnboardingFirst: !onboardingCompleted));
  FlutterNativeSplash.remove();
}
