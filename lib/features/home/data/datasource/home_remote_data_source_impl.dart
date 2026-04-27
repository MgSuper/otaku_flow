import 'package:flutter/foundation.dart';
import 'package:startup_launch/core/network/api_client.dart';
import 'package:startup_launch/features/home/data/datasource/home_remote_data_source.dart';
import 'package:startup_launch/features/manga/data/models/manga_model.dart';

class HomeRemoteDataSourceImpl implements HomeRemoteDataSource {
  final ApiClient api;

  HomeRemoteDataSourceImpl(this.api);

  @override
  Future<List<MangaModel>> getTrending() async {
    final res = await api.get(
      '/manga',
      query: {
        'limit': 10,
        'order[followedCount]': 'desc',
        'includes[]': ['cover_art'],
      },
    );
    return compute(_parseMangaList, res.data['data'] as List);

    // return MangaModel.fromList(res.data['data']);
  }

  @override
  Future<List<MangaModel>> getLatest() async {
    final res = await api.get(
      '/manga',
      query: {
        'limit': 10,
        'order[latestUploadedChapter]': 'desc',
        'includes[]': ['cover_art'],
      },
    );

    return compute(_parseMangaList, res.data['data'] as List);
  }

  @override
  Future<List<MangaModel>> getPopular() async {
    final res = await api.get(
      '/manga',
      query: {
        'limit': 10,
        'order[rating]': 'desc',
        'includes[]': ['cover_art'],
      },
    );

    return compute(_parseMangaList, res.data['data'] as List);
  }
}

List<MangaModel> _parseMangaList(List data) {
  return data.map((json) => MangaModel.fromJson(json)).toList();
}
