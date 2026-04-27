import 'package:startup_launch/features/home/domain/entities/home_data.dart';
import 'package:startup_launch/features/home/domain/repositories/home_repository.dart';

class GetHomeUseCase {
  final HomeRepository repository;

  GetHomeUseCase(this.repository);

  Future<HomeData> call() {
    return repository.getHome();
  }
}
