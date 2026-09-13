import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:startup_launch/core/telemetry/telemetry.dart';
import 'package:startup_launch/features/home/domain/usecases/get_home_usecase.dart';

import 'home_event.dart';
import 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final GetHomeUseCase getHome;

  HomeBloc(this.getHome) : super(HomeLoading()) {
    on<LoadHome>(_load);
    on<RefreshHome>(_load);
  }

  Future<void> _load(HomeEvent event, Emitter<HomeState> emit) async {
    await Telemetry.logEvent(
      event is RefreshHome ? 'home_refreshed' : 'home_loaded',
    );
    try {
      emit(HomeLoading());

      final data = await getHome();

      emit(HomeLoaded(data));
    } catch (e, stack) {
      await Telemetry.recordError(e, stack, reason: 'Home data load failed');
      emit(HomeError(e.toString()));
    }
  }
}
