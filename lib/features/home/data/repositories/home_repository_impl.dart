import 'package:startup_launch/features/home/data/datasource/home_remote_data_source.dart';
import 'package:startup_launch/features/home/domain/entities/home_data.dart';
import 'package:startup_launch/features/home/domain/repositories/home_repository.dart';

class HomeRepositoryImpl implements HomeRepository {
  final HomeRemoteDataSource remote;

  HomeRepositoryImpl(this.remote);

  @override
  Future<HomeData> getHome() async {
    final results = await Future.wait([
      remote.getTrending(),
      remote.getLatest(),
      remote.getPopular(),
    ]);

    return HomeData(
      trending: results[0],
      latest: results[1],
      popular: results[2],
    );
  }
}
