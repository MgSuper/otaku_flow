import 'package:equatable/equatable.dart';
import 'package:startup_launch/features/manga/domain/entities/manga.dart';

abstract class SearchState extends Equatable {}

class SearchIdle extends SearchState {
  final List<String> history;
  SearchIdle({this.history = const []});

  @override
  List<Object?> get props => [history];
}

class SearchLoading extends SearchState {
  @override
  List<Object?> get props => [];
}

class SearchLoaded extends SearchState {
  final List<Manga> mangas;

  SearchLoaded(this.mangas);

  @override
  List<Object?> get props => [mangas];
}

class SearchEmpty extends SearchState {
  @override
  List<Object?> get props => [];
}

class SearchError extends SearchState {
  final String message;

  SearchError(this.message);

  @override
  List<Object?> get props => [];
}
