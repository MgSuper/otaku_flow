import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';

class MangaDetailLoadingView extends StatelessWidget {
  const MangaDetailLoadingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Skeletonizer(
      enabled: true,
      child: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 360,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(color: Colors.white24),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  const Bone.text(words: 2),
                  const SizedBox(height: 16),

                  // Chips (Using Bone for specific dimensions)
                  Row(
                    children: [
                      Bone(
                        width: 80,
                        height: 30,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      const SizedBox(width: 8),
                      Bone(
                        width: 80,
                        height: 30,
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Button
                  const Bone(
                    width: double.infinity,
                    height: 48,
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                  ),
                  const SizedBox(height: 24),

                  // Summary
                  const Bone.text(words: 1),
                  const SizedBox(height: 12),
                  const Bone.text(words: 5),
                  const Bone.text(words: 4),

                  const SizedBox(height: 24),
                  const Bone.text(words: 1),
                  const SizedBox(height: 12),
                ],
              ),
            ),
          ),

          // Chapter List
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) => Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 6,
                ),
                child: Card(
                  child: ListTile(
                    // Using circle for the leading icon placeholder
                    leading: Bone.circle(size: 40),
                    title: const Bone.text(words: 1),
                    subtitle: const Bone.text(words: 2),
                  ),
                ),
              ),
              childCount: 6,
            ),
          ),
        ],
      ),
    );
  }
}
