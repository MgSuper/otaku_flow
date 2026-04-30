import 'package:equatable/equatable.dart';
import 'package:startup_launch/features/manga/domain/entities/manga.dart';
import 'package:startup_launch/features/manga_detail/domain/entities/chapter.dart';

abstract class MangaDetailState extends Equatable {}

class MangaDetailLoading extends MangaDetailState {
  @override
  List<Object?> get props => [];
}

class MangaDetailLoaded extends MangaDetailState {
  final Manga manga;
  final List<Chapter> chapters;
  final int currentPage;
  final int totalPages;
  final bool loadingChapters;

  MangaDetailLoaded({
    required this.manga,
    required this.chapters,
    required this.currentPage,
    required this.totalPages,
    required this.loadingChapters,
  });

  MangaDetailLoaded copyWith({
    List<Chapter>? chapters,
    int? currentPage,
    int? totalPages,
    bool? loadingChapters,
  }) {
    return MangaDetailLoaded(
      manga: manga,
      chapters: chapters ?? this.chapters,
      currentPage: currentPage ?? this.currentPage,
      totalPages: totalPages ?? this.totalPages,
      loadingChapters: loadingChapters ?? this.loadingChapters,
    );
  }

  @override
  List<Object?> get props => [
    manga,
    chapters,
    currentPage,
    totalPages,
    loadingChapters,
  ];
}

class MangaDetailError extends MangaDetailState {
  final String message;

  MangaDetailError(this.message);

  @override
  List<Object?> get props => [message];
}
