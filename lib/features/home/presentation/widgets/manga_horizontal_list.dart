import 'package:flutter/material.dart';
import 'package:startup_launch/features/home/presentation/widgets/manga_card.dart';
import 'package:startup_launch/features/manga/domain/entities/manga.dart';

class MangaHorizontalList extends StatelessWidget {
  final List<Manga> mangas;

  const MangaHorizontalList({super.key, required this.mangas});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 240,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemBuilder: (_, index) => MangaCard(manga: mangas[index]),
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemCount: mangas.length,
      ),
    );
  }
}
