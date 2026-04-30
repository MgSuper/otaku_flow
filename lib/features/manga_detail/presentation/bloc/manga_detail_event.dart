import 'package:equatable/equatable.dart';

abstract class MangaDetailEvent extends Equatable {}

class LoadMangaDetail extends MangaDetailEvent {
  final String mangaId;
  final int? page;

  LoadMangaDetail(this.mangaId, this.page);

  @override
  List<Object?> get props => [mangaId, page];
}

class ChangeChapterPage extends MangaDetailEvent {
  final int page;

  ChangeChapterPage(this.page);

  @override
  List<Object?> get props => [page];
}
