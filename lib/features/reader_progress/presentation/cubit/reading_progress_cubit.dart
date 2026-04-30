import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:startup_launch/features/reader_progress/data/reading_progress_storage.dart';
import 'package:startup_launch/features/reader_progress/domain/entities/reading_progress.dart';
import 'package:startup_launch/features/reader_progress/presentation/cubit/reading_progress_state.dart';

class ReadingProgressCubit extends Cubit<ReadingProgressState> {
  final ReadingProgressStorage storage;

  ReadingProgressCubit(this.storage)
    : super(const ReadingProgressState(progress: null));

  void load() {
    emit(ReadingProgressState(progress: storage.get()));
  }

  Future<void> save(ReadingProgress item) async {
    await storage.save(item);

    emit(ReadingProgressState(progress: item));
  }

  Future<void> clear() async {
    await storage.clear();

    emit(const ReadingProgressState(progress: null));
  }
}
