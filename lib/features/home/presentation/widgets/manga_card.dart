import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:startup_launch/features/manga/domain/entities/manga.dart';

class MangaCard extends StatelessWidget {
  final Manga manga;

  const MangaCard({super.key, required this.manga});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 130,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Container(
                width: double.infinity,
                color: Colors.grey,
                child: manga.coverUrl.isNotEmpty
                    ? CachedNetworkImage(
                        imageUrl: manga.coverUrl,
                        fit: BoxFit.cover,
                      )
                    : const SizedBox.expand(),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            manga.title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }
}
