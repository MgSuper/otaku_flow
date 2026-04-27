import 'package:flutter/material.dart';
import 'package:startup_launch/features/home/presentation/widgets/manga_horizontal_list.dart';
import 'package:startup_launch/features/manga/domain/entities/manga.dart';

class HomeSection extends StatelessWidget {
  final String title;
  final List<Manga> mangas;

  const HomeSection({super.key, required this.title, required this.mangas});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(title, style: Theme.of(context).textTheme.titleLarge),
          ),
          const SizedBox(height: 12),
          MangaHorizontalList(mangas: mangas),
        ],
      ),
    );
  }
}
