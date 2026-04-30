import 'package:equatable/equatable.dart';

abstract class ReaderEvent extends Equatable {}

class LoadReaderChapter extends ReaderEvent {
  final String chapterId;
  final List<dynamic> chapters;
  final int index;
  // Add these
  final bool hasNextPage;
  final bool hasPrevPage;

  LoadReaderChapter({
    required this.chapterId,
    required this.chapters,
    required this.index,
    required this.hasNextPage,
    required this.hasPrevPage,
  });

  @override
  List<Object?> get props => [
    chapterId,
    chapters,
    index,
    hasNextPage,
    hasPrevPage,
  ];
}
