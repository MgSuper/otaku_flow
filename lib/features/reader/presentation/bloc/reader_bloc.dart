import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:startup_launch/features/reader/domain/usecases/get_reader_chapter_usecase.dart';
import 'package:startup_launch/features/reader/presentation/bloc/reader_event.dart';
import 'package:startup_launch/features/reader/presentation/bloc/reader_state.dart';

class ReaderBloc extends Bloc<ReaderEvent, ReaderState> {
  final GetReaderChapterUseCase getChapter;

  ReaderBloc(this.getChapter) : super(ReaderLoading()) {
    on<LoadReaderChapter>(_load);
  }

  Future<void> _load(LoadReaderChapter event, Emitter<ReaderState> emit) async {
    try {
      emit(ReaderLoading());

      // 1. Fetch images from your usecase
      final result = await getChapter(event.chapterId);

      // 2. Determine the list
      // Priority: 1. Event (from Detail) -> 2. Result (from Entity) -> 3. Empty
      final List<dynamic> finalChapters = event.chapters.isNotEmpty
          ? event.chapters
          : (result.mangaChapters ?? []);

      // 3. Determine the index
      int finalIndex = event.index;
      if (event.chapters.isEmpty && finalChapters.isNotEmpty) {
        finalIndex = finalChapters.indexWhere((c) => c.id == event.chapterId);
      }

      emit(
        ReaderLoaded(
          result,
          chapters: finalChapters,
          index: finalIndex.clamp(0, finalChapters.length),
          hasNextPage: event.hasNextPage, // Pass from event
          hasPrevPage: event.hasPrevPage, // Pass from event
        ),
      );
    } catch (e) {
      emit(
        ReaderError(e.toString(), chapters: event.chapters, index: event.index),
      );
    }
  }
}
