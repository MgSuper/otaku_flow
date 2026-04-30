import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:startup_launch/core/extensions/l10n.dart';
import 'package:startup_launch/features/search/presentation/bloc/search_bloc.dart';
import 'package:startup_launch/features/search/presentation/bloc/search_event.dart';
import 'package:startup_launch/features/search/presentation/bloc/search_state.dart';
import 'package:startup_launch/features/search/presentation/screens/widgets/search_loaded_view.dart';
import 'package:startup_launch/features/search/presentation/screens/widgets/search_loading_view.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<SearchBloc>().add(LoadSearchHistory());
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SearchBloc, SearchState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: TextField(
              controller: _controller, // Link the controller
              autofocus: true,
              textInputAction: TextInputAction.search,
              onChanged: (value) {
                context.read<SearchBloc>().add(SearchSubmitted(value));
              },
              decoration: InputDecoration(
                hintText: context.l10n.searchMangaHint,
                border: InputBorder.none,
                // The Clear Button
                suffixIcon: IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    _controller.clear(); // Clears the UI
                    context.read<SearchBloc>().add(
                      SearchCleared(),
                    ); // Clears the Bloc state
                  },
                ),
              ),
            ),
          ),
          body: BlocBuilder<SearchBloc, SearchState>(
            builder: (_, state) {
              return switch (state) {
                SearchIdle() =>
                  state.history.isEmpty
                      ? Center(child: Text(context.l10n.searchManga))
                      : Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 18.0),
                          child: Wrap(
                            spacing: 8,
                            runSpacing: 4,
                            children: state.history
                                .map(
                                  (query) => InputChip(
                                    label: Text(query),
                                    labelStyle: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                    ),
                                    backgroundColor: Colors.white.withAlpha(
                                      2,
                                    ), // Subtle dark theme feel
                                    deleteIcon: const Icon(
                                      Icons.close,
                                      size: 14,
                                      color: Colors.white54,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                      side: BorderSide(
                                        color: Colors.white.withAlpha(2),
                                      ),
                                    ),
                                    onPressed: () => context
                                        .read<SearchBloc>()
                                        .add(SearchSubmitted(query)),
                                    onDeleted: () => context
                                        .read<SearchBloc>()
                                        .add(DeleteSearchHistory(query)),
                                  ),
                                )
                                .toList(),
                          ),
                        ),

                SearchLoading() => const SearchLoadingView(),

                SearchLoaded() => SearchLoadedView(mangas: state.mangas),

                SearchEmpty() => Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.search_off,
                        size: 80,
                        color: Colors.grey,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        context.l10n.mangaNotFound,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextButton(
                        onPressed: () =>
                            context.read<SearchBloc>().add(SearchCleared()),
                        child: Text(context.l10n.clearAndTryAgain),
                      ),
                    ],
                  ),
                ),
                SearchError() => Center(child: Text(state.message)),

                _ => const SizedBox(),
              };
            },
          ),
        );
      },
    );
  }
}
