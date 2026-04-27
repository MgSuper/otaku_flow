import 'package:flutter/material.dart';

class HomeHeader extends StatelessWidget {
  final VoidCallback? onSearchTap;

  const HomeHeader({super.key, required this.onSearchTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Discover Manga',
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 16),

          InkWell(
            borderRadius: BorderRadius.circular(14),
            onTap: onSearchTap,
            child: Container(
              height: 52,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.white10,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: Colors.white12),
              ),
              child: const Row(
                children: [
                  Icon(Icons.search, size: 20),
                  SizedBox(width: 12),
                  Text('Search manga...'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
