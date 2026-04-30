import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

Widget buildQuickActions(BuildContext context) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    child: Row(
      children: [
        Expanded(
          child: _QuickActionCard(
            icon: Icons.home_rounded,
            title: 'Library',
            subtitle: 'Main Home',
            onTap: () {
              context.push('/library');
            },
          ),
        ),

        const SizedBox(width: 12),

        Expanded(
          child: _QuickActionCard(
            icon: Icons.favorite,
            title: 'Favorites',
            subtitle: 'Saved manga',
            onTap: () {
              context.push('/library');
            },
          ),
        ),
      ],
    ),
  );
}

class _QuickActionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _QuickActionCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Ink(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          color: theme.colorScheme.surfaceContainerHighest,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon),

            const SizedBox(height: 14),

            Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),

            const SizedBox(height: 4),

            Text(subtitle, style: theme.textTheme.bodySmall),
          ],
        ),
      ),
    );
  }
}
