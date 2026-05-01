import 'package:startup_launch/core/network/api_client.dart';
import 'package:startup_launch/features/manga/data/models/manga_model.dart';
import 'package:startup_launch/features/search/data/datasource/search_remote_data_source.dart';

class SearchRemoteDataSourceImpl implements SearchRemoteDataSource {
  final ApiClient api;

  SearchRemoteDataSourceImpl(this.api);

  @override
  Future<List<MangaModel>> search(String query, {int offset = 0}) async {
    final res = await api.get(
      '/manga',
      query: {
        'title': query,
        'limit': 20,
        'offset': offset,
        'includes[]': ['cover_art'],
        'contentRating[]': ['safe', 'suggestive'],
      },
    );

    return MangaModel.fromList(res.data['data']);
  }
}
