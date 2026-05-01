import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';

class SearchLoadingView extends StatelessWidget {
  const SearchLoadingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Skeletonizer(
      enabled: true,
      child: GridView.builder(
        padding: const EdgeInsets.all(16),
        // Matching the item count to fill the initial screen
        itemCount: 9,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          // MATCHED: Changed from 4 to 3 to match your SearchLoadedView
          crossAxisCount: 3,
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
          // MATCHED: Aspect ratio 0.62 from your SearchLoadedView
          childAspectRatio: .62,
        ),
        itemBuilder: (_, index) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // The Manga Poster placeholder
              const Expanded(
                child: Bone(
                  width: double.infinity,
                  borderRadius: BorderRadius.all(Radius.circular(14)),
                ),
              ),

              const SizedBox(height: 10),

              // Title placeholder (usually longer)
              const Bone.text(words: 2),

              const SizedBox(height: 8),

              // Subtitle/Author placeholder (usually shorter)
              const Bone.text(words: 1, fontSize: 12),
            ],
          );
        },
      ),
    );
  }
}
