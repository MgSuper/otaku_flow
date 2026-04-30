import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:startup_launch/features/reader/presentation/bloc/reader_bloc.dart';
import 'package:startup_launch/features/reader/presentation/bloc/reader_event.dart';
import 'package:startup_launch/features/reader/presentation/bloc/reader_state.dart';

class ReaderUnavailableView extends StatelessWidget {
  final ReaderError state;
  final bool hasNextPage; // true if older chapters exist (Page 1 -> 2)
  final bool hasPrevPage; // true if newer chapters exist (Page 2 -> 1)

  const ReaderUnavailableView({
    super.key,
    required this.state,
    required this.hasNextPage,
    required this.hasPrevPage,
  });

  @override
  Widget build(BuildContext context) {
    final hasPrev = state.index > 0;

    final hasNext = state.index < state.chapters.length - 1;

    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.menu_book_outlined, size: 72),

            const SizedBox(height: 20),

            const Text(
              'Chapter Unavailable',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 12),

            Text(state.message, textAlign: TextAlign.center),

            const SizedBox(height: 28),

            if (hasNext)
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                    final next = state.chapters[state.index + 1];

                    context.read<ReaderBloc>().add(
                      LoadReaderChapter(
                        chapterId: next.id,
                        chapters: state.chapters,
                        index: state.index + 1,
                        hasNextPage: hasNextPage,
                        hasPrevPage: hasPrevPage,
                      ),
                    );
                  },
                  icon: const Icon(Icons.skip_next),
                  label: const Text('Try Next Available'),
                ),
              ),

            const SizedBox(height: 12),

            if (hasPrev)
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () {
                    final prev = state.chapters[state.index - 1];

                    context.read<ReaderBloc>().add(
                      LoadReaderChapter(
                        chapterId: prev.id,
                        chapters: state.chapters,
                        index: state.index - 1,
                        hasNextPage: hasNextPage,
                        hasPrevPage: hasPrevPage,
                      ),
                    );
                  },
                  icon: const Icon(Icons.skip_previous),
                  label: const Text('Try Previous'),
                ),
              ),

            const SizedBox(height: 12),

            TextButton.icon(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(Icons.layers_outlined),
              label: const Text('Back to Chapters'),
            ),
          ],
        ),
      ),
    );
  }
}
