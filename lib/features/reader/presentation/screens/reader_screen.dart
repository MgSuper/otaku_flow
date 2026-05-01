import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:startup_launch/core/di/service_locator.dart';
import 'package:startup_launch/features/reader/presentation/bloc/reader_bloc.dart';
import 'package:startup_launch/features/reader/presentation/bloc/reader_state.dart';
import 'package:startup_launch/features/reader/presentation/screens/widgets/reader_chapter_bottom_bar.dart';
import 'package:startup_launch/features/reader/presentation/screens/widgets/reader_loading_view.dart';
import 'package:startup_launch/features/reader/presentation/screens/widgets/reader_unavailable_view.dart';
import 'package:startup_launch/features/reader/presentation/screens/widgets/zoomable_manga_page.dart';
import 'package:startup_launch/features/reader_progress/data/reading_progress_storage.dart';
import 'package:startup_launch/features/reader_progress/domain/entities/reading_progress.dart';
import 'package:startup_launch/features/reader_progress/presentation/cubit/reading_progress_cubit.dart';

class ReaderScreen extends StatefulWidget {
  final String mangaId;
  final String mangaTitle;
  final String coverUrl;
  final String chapterId;
  final List<dynamic> chapters;
  final int index;
  final int currentPage;

  final bool hasNextPage;
  final bool hasPrevPage;
  const ReaderScreen({
    super.key,
    required this.mangaId,
    required this.mangaTitle,
    required this.coverUrl,
    required this.chapterId,
    required this.chapters,
    required this.index,
    required this.hasNextPage,
    required this.hasPrevPage,
    required this.currentPage,
  });

  @override
  State<ReaderScreen> createState() => _ReaderScreenState();
}

class _ReaderScreenState extends State<ReaderScreen>
    with WidgetsBindingObserver {
  late final ScrollController controller;
  late ReaderBloc readerBloc;
  late ReadingProgressStorage progressStorage;
  bool restored = false;
  double savedOffset = 0;
  int currentPageIndex = 0;

  final itemKeys = <GlobalKey>[];

  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    controller = ScrollController();

    // FIX 1: Initialize the savedOffset from existing progress
    final progress = sl<ReadingProgressCubit>().state.progress;
    if (progress != null && progress.chapterId == widget.chapterId) {
      savedOffset = progress.offset;
    }

    controller.addListener(() {
      // FIX 2: Update currentPageIndex so the saved data is accurate
      final offset = controller.offset;
      final viewportHeight = MediaQuery.of(context).size.height;
      if (viewportHeight > 0) {
        currentPageIndex = (offset / viewportHeight).floor();
      }

      _debounce?.cancel();
      _debounce = Timer(
        const Duration(milliseconds: 500),
        _saveCurrentProgress,
      );
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // If app goes to background or is paused, save immediately!
    if (state == AppLifecycleState.inactive ||
        state == AppLifecycleState.paused) {
      _saveCurrentProgress();
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    readerBloc = context.read<ReaderBloc>();

    progressStorage = sl<ReadingProgressStorage>();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this); // Clean up observer
    _debounce?.cancel();
    // _saveCurrentProgress(); // Final attempt to save (synchronous part)
    controller.dispose();
    super.dispose();
  }

  Future<void> _restoreScroll() async {
    if (restored || savedOffset <= 0 || !controller.hasClients) return;

    // Ensure the scroll view has actually laid out the children
    // We check if the current maxScrollExtent can actually reach our savedOffset
    if (controller.position.maxScrollExtent >= savedOffset) {
      controller.jumpTo(savedOffset);
      restored = true;
    } else {
      // If the list isn't long enough yet (images still loading/rendering),
      // try again on the next frame.
      WidgetsBinding.instance.addPostFrameCallback((_) => _restoreScroll());
    }
  }

  void _saveCurrentProgress() {
    final state = readerBloc.state;
    if (state is ReaderLoaded && controller.hasClients) {
      sl<ReadingProgressCubit>().save(
        ReadingProgress(
          mangaId: widget.mangaId,
          mangaTitle: widget.mangaTitle,
          coverUrl: widget.coverUrl,
          chapterId: state.chapter.chapterId,
          chapterTitle: state.chapter.title,
          offset: controller.offset,
          pageIndex: currentPageIndex,
          page: widget.currentPage,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) {
          _saveCurrentProgress();
          // The result here contains the {'action': ..., 'targetPage': ...}
          // Ensure your navigation logic is actually receiving this!
        }
      },
      child: Scaffold(
        body: BlocBuilder<ReaderBloc, ReaderState>(
          builder: (_, state) {
            if (state is ReaderLoading) {
              return const ReaderLoadingView();
            }

            if (state is ReaderError) {
              return ReaderUnavailableView(
                state: state,
                hasNextPage: widget.hasNextPage,
                hasPrevPage: widget.hasPrevPage,
              );
            }

            final chapter = (state as ReaderLoaded).chapter;

            WidgetsBinding.instance.addPostFrameCallback((_) {
              _restoreScroll();
            });

            return CustomScrollView(
              controller: controller,
              slivers: [
                SliverAppBar(pinned: true, title: Text(chapter.title)),

                SliverList(
                  delegate: SliverChildBuilderDelegate((context, index) {
                    return ZoomableMangaPage(
                      imageUrl: chapter.imageUrls[index],
                    );
                  }, childCount: chapter.imageUrls.length),
                ),
              ],
            );
          },
        ),
        bottomNavigationBar: BlocBuilder<ReaderBloc, ReaderState>(
          builder: (context, state) {
            // If the Bloc has loaded, use the chapters from the STATE
            if (state is ReaderLoaded) {
              return ReaderChapterBottomBar(
                // Use state.chapters (which the Bloc now holds), NOT widget.chapters
                chapters: state.chapters,
                index: state.index,
                mangaId: widget.mangaId,
                mangaTitle: widget.mangaTitle,
                coverUrl: widget.coverUrl,
                hasNextPage: widget.hasNextPage,
                hasPrevPage: widget.hasPrevPage,
                currentPage: widget.currentPage,
              );
            }

            // While loading or in error, show nothing
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
