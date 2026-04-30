import 'package:startup_launch/core/network/api_client.dart';
import 'package:startup_launch/features/manga_detail/data/datasource/manga_detail_remote_data_source.dart';
import 'package:startup_launch/features/manga_detail/data/models/manga_detail_model.dart';

class MangaDetailRemoteDataSourceImpl implements MangaDetailRemoteDataSource {
  final ApiClient api;

  MangaDetailRemoteDataSourceImpl(this.api);

  static const perPage = 20;

  Map<String, dynamic>? _cachedManga;

  String? _cachedId;

  @override
  Future<MangaDetailModel> getDetail({
    required String mangaId,
    required int page,
  }) async {
    /// fetch manga once
    if (_cachedId != mangaId || _cachedManga == null) {
      final mangaRes = await api.get(
        '/manga/$mangaId',
        query: {
          'includes[]': ['cover_art'],
        },
      );

      _cachedManga = mangaRes.data['data'];

      _cachedId = mangaId;
    }

    final offset = (page - 1) * perPage;

    final chapterRes = await api.get(
      '/chapter',
      query: {
        'manga': mangaId,
        'limit': perPage,
        'offset': offset,
        'translatedLanguage[]': ['en'],
        'order[chapter]': 'desc',
      },
    );

    final total = chapterRes.data['total'] as int;

    final totalPages = (total / perPage).ceil();

    return MangaDetailModel.fromJson(
      mangaJson: _cachedManga!,
      chaptersJson: chapterRes.data['data'],
      totalPages: totalPages,
    );
  }
}
