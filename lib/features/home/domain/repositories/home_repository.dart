import 'package:startup_launch/features/home/domain/entities/home_data.dart';

abstract class HomeRepository {
  Future<HomeData> getHome();
}
