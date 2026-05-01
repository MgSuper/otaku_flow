import 'package:equatable/equatable.dart';
import 'package:startup_launch/features/manga/domain/entities/manga.dart';

abstract class SearchState extends Equatable {
  @override
  List<Object?> get props => [];
}

class SearchIdle extends SearchState {
  final List<String> history;

  SearchIdle({this.history = const []});

  @override
  List<Object?> get props => [history];
}

class SearchLoading extends SearchState {}

class SearchLoaded extends SearchState {
  final String query;
  final List<Manga> mangas;
  final bool hasMore;
  final bool loadingMore;

  SearchLoaded({
    required this.query,
    required this.mangas,
    required this.hasMore,
    this.loadingMore = false,
  });

  SearchLoaded copyWith({
    List<Manga>? mangas,
    bool? hasMore,
    bool? loadingMore,
  }) {
    return SearchLoaded(
      query: query,
      mangas: mangas ?? this.mangas,
      hasMore: hasMore ?? this.hasMore,
      loadingMore: loadingMore ?? this.loadingMore,
    );
  }

  @override
  List<Object?> get props => [query, mangas, hasMore, loadingMore];
}

class SearchEmpty extends SearchState {}

class SearchError extends SearchState {
  final String message;

  SearchError(this.message);

  @override
  List<Object?> get props => [message];
}
