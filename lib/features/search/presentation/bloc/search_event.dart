import 'package:equatable/equatable.dart';

abstract class SearchEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class SearchSubmitted extends SearchEvent {
  final String query;

  SearchSubmitted(this.query);

  @override
  List<Object?> get props => [query];
}

class SearchLoadMore extends SearchEvent {}

class SearchCleared extends SearchEvent {}

class LoadSearchHistory extends SearchEvent {}

class DeleteSearchHistory extends SearchEvent {
  final String query;

  DeleteSearchHistory(this.query);

  @override
  List<Object?> get props => [query];
}
