import 'package:flutter/material.dart';
import 'package:startup_launch/features/home/presentation/widgets/manga_card.dart';
import 'package:startup_launch/features/manga/domain/entities/manga.dart';

class SearchLoadedView extends StatelessWidget {
  final List<Manga> mangas;

  const SearchLoadedView({super.key, required this.mangas});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        childAspectRatio: .62,
      ),
      itemCount: mangas.length,
      itemBuilder: (_, i) => MangaCard(manga: mangas[i]),
    );
  }
}
