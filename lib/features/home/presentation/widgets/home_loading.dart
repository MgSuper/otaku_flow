import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:startup_launch/features/home/presentation/widgets/home_header.dart';

class HomeLoadingView extends StatelessWidget {
  const HomeLoadingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Skeletonizer(
      enabled: true,
      containersColor: Theme.of(context).cardColor, // Force color recognition
      child: ListView(
        children: const [
          HomeLoadingSection(),
          HomeLoadingSection(),
          HomeLoadingSection(),
        ],
      ),
    );
  }
}

class HomeLoadingSection extends StatelessWidget {
  const HomeLoadingSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(height: 24, width: 120, margin: EdgeInsets.all(16)),
        SizedBox(
          height: 240,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: 6,
            itemBuilder: (_, _) => const MangaCardSkeleton(),
            separatorBuilder: (_, _) => const SizedBox(width: 12),
          ),
        ),
      ],
    );
  }
}

class MangaCardSkeleton extends StatelessWidget {
  const MangaCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 130,
      child: Column(
        children: [
          Expanded(child: Container()),
          SizedBox(height: 8),
          Container(height: 14),
          SizedBox(height: 6),
          SizedBox(height: 12, width: 80),
        ],
      ),
    );
  }
}
