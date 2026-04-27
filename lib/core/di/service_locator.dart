import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:startup_launch/app/localization/locale_cubit.dart';
import 'package:startup_launch/app/theme/theme_cubit.dart';
import 'package:startup_launch/core/config/app_config.dart';
import 'package:startup_launch/core/network/api_client.dart';
import 'package:startup_launch/core/network/dio_factory.dart';
import 'package:startup_launch/features/home/data/datasource/home_remote_data_source.dart';
import 'package:startup_launch/features/home/data/datasource/home_remote_data_source_impl.dart';
import 'package:startup_launch/features/home/data/repositories/home_repository_impl.dart';
import 'package:startup_launch/features/home/domain/repositories/home_repository.dart';
import 'package:startup_launch/features/home/domain/usecases/get_home_usecase.dart';
import 'package:startup_launch/features/home/presentation/bloc/home_bloc.dart';
import 'package:startup_launch/features/onboarding/data/onboarding_storage.dart';
import 'package:startup_launch/features/search/data/datasource/onboarding_storage.dart';
import 'package:startup_launch/features/search/data/datasource/search_remote_data_source.dart';
import 'package:startup_launch/features/search/data/datasource/search_remote_data_source_impl.dart';
import 'package:startup_launch/features/search/data/repositories/search_repository_impl.dart';
import 'package:startup_launch/features/search/domain/repositories/search_repository.dart';
import 'package:startup_launch/features/search/domain/usecases/search_manga_usecase.dart';
import 'package:startup_launch/features/search/presentation/bloc/search_bloc.dart';

final sl = GetIt.instance;

Future<void> setupLocator(AppConfig config) async {
  final sharedPrefs = await SharedPreferences.getInstance();
  sl.registerSingleton<SharedPreferences>(sharedPrefs);
  // 1. Config first
  sl.registerSingleton<AppConfig>(config);

  // 2. Network layer
  final dio = DioFactory.create();
  sl.registerSingleton(dio);
  sl.registerLazySingleton(() => ApiClient(sl()));

  // 3. UI State (Theme & Locale)
  // Use registerSingleton instead of Lazy if you plan to init them immediately
  sl.registerSingleton(ThemeCubit());
  sl.registerSingleton(LocaleCubit());

  if (!sl.isRegistered<OnboardingStorage>()) {
    sl.registerLazySingleton<OnboardingStorage>(
      () => SharedPrefsOnboardingStorage(sl<SharedPreferences>()),
    );
  }

  sl.registerLazySingleton<HomeRemoteDataSource>(
    () => HomeRemoteDataSourceImpl(sl<ApiClient>()),
  );

  sl.registerLazySingleton<HomeRepository>(() => HomeRepositoryImpl(sl()));

  sl.registerLazySingleton(() => GetHomeUseCase(sl()));

  sl.registerLazySingleton(() => HomeBloc(sl()));

  sl.registerLazySingleton<SearchRemoteDataSource>(
    () => SearchRemoteDataSourceImpl(sl()),
  );

  sl.registerLazySingleton<SearchRepository>(() => SearchRepositoryImpl(sl()));

  sl.registerLazySingleton(() => SearchMangaUseCase(sl()));

  sl.registerLazySingleton<SharedPrefsSearchStorage>(
    () => SharedPrefsSearchStorage(sl<SharedPreferences>()),
  );

  sl.registerFactory(() => SearchBloc(sl(), sl()));
}
