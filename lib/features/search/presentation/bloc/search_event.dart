import 'package:equatable/equatable.dart';

abstract class SearchEvent extends Equatable {}

class SearchSubmitted extends SearchEvent {
  final String query;

  SearchSubmitted(this.query);

  @override
  List<Object?> get props => [query];
}

class SearchCleared extends SearchEvent {
  @override
  List<Object?> get props => [];
}

class LoadSearchHistory extends SearchEvent {
  @override
  List<Object?> get props => [];
}

class DeleteSearchHistory extends SearchEvent {
  final String query;
  DeleteSearchHistory(this.query);

  @override
  List<Object?> get props => [query];
}
