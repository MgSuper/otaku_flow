import 'package:startup_launch/core/network/api_client.dart';
import 'package:startup_launch/features/reader/data/datasource/reader_remote_data_source.dart';
import 'package:startup_launch/features/reader/data/models/reader_chapter_model.dart';

class ReaderRemoteDataSourceImpl implements ReaderRemoteDataSource {
  final ApiClient api;

  ReaderRemoteDataSourceImpl(this.api);

  @override
  Future<ReaderChapterModel> getChapter(String chapterId) async {
    final res = await api.get('/at-home/server/$chapterId');
    return ReaderChapterModel.fromJson(chapterId, res.data);
  }
}
