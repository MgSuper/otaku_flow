import 'package:flutter/material.dart';

class ChapterPagination extends StatelessWidget {
  final int currentPage;
  final int totalPages;
  final ValueChanged<int>? onPageChanged;

  const ChapterPagination({
    super.key,
    required this.currentPage,
    required this.totalPages,
    required this.onPageChanged,
  });

  @override
  Widget build(BuildContext context) {
    final pages = _buildPages();

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          _navButton(
            icon: Icons.chevron_left,
            enabled: currentPage > 1,
            onTap: () => onPageChanged!(currentPage - 1),
          ),

          const SizedBox(width: 8),

          ...pages.map((item) {
            if (item == -1) {
              return const Padding(
                padding: EdgeInsets.symmetric(horizontal: 6),
                child: Text('...'),
              );
            }

            final selected = item == currentPage;

            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: InkWell(
                onTap: () => onPageChanged!(item),
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  width: 42,
                  height: 42,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: selected
                        ? Theme.of(context).colorScheme.primary
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: selected
                          ? Theme.of(context).colorScheme.primary
                          : Colors.white12,
                    ),
                  ),
                  child: Text(
                    '$item',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            );
          }),

          _navButton(
            icon: Icons.chevron_right,
            enabled: currentPage < totalPages,
            onTap: () => onPageChanged!(currentPage + 1),
          ),
        ],
      ),
    );
  }

  Widget _navButton({
    required IconData icon,
    required bool enabled,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: enabled ? onTap : null,
      borderRadius: BorderRadius.circular(12),
      child: Opacity(
        opacity: enabled ? 1 : .4,
        child: Container(
          width: 42,
          height: 42,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.white12),
          ),
          child: Icon(icon),
        ),
      ),
    );
  }

  List<int> _buildPages() {
    if (totalPages <= 7) {
      return List.generate(totalPages, (i) => i + 1);
    }

    final pages = <int>[];

    /// Always show first pages
    pages.add(1);
    pages.add(2);

    /// Left gap
    if (currentPage > 4) {
      pages.add(-1);
    }

    /// Middle pages
    final start = currentPage - 1;
    final end = currentPage + 1;

    for (int i = start; i <= end; i++) {
      if (i > 2 && i < totalPages - 1) {
        pages.add(i);
      }
    }

    /// Right gap
    if (currentPage < totalPages - 3) {
      pages.add(-1);
    }

    /// Last pages
    pages.add(totalPages - 1);
    pages.add(totalPages);

    final result = pages.toSet().toList()..sort();

    return result;
  }
}
