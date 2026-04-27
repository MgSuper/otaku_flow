import 'package:startup_launch/features/home/domain/entities/home_data.dart';

abstract class HomeState {}

class HomeLoading extends HomeState {}

class HomeLoaded extends HomeState {
  final HomeData data;

  HomeLoaded(this.data);
}

class HomeError extends HomeState {
  final String message;

  HomeError(this.message);
}
