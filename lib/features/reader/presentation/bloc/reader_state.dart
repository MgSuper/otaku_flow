import 'package:equatable/equatable.dart';
import 'package:startup_launch/features/reader/domain/entities/reader_chapter.dart';

abstract class ReaderState extends Equatable {}

class ReaderLoading extends ReaderState {
  @override
  List<Object?> get props => [];
}

class ReaderLoaded extends ReaderState {
  final ReaderChapter chapter;
  final List<dynamic> chapters;
  final int index;
  // Add these two
  final bool hasNextPage;
  final bool hasPrevPage;

  ReaderLoaded(
    this.chapter, {
    required this.chapters,
    required this.index,
    required this.hasNextPage, // New
    required this.hasPrevPage, // New
  });

  @override
  List<Object?> get props => [
    chapter,
    chapters,
    index,
    hasNextPage,
    hasPrevPage,
  ];
}

class ReaderError extends ReaderState {
  final String message;
  final List<dynamic> chapters;
  final int index;

  ReaderError(this.message, {required this.chapters, required this.index});

  @override
  List<Object?> get props => [message, chapters, index];
}
